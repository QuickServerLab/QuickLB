package com.quickserverlab.quicklb.server;

import org.quickserver.net.server.ClientData;

import java.net.*;
import java.io.*;
import java.util.concurrent.atomic.AtomicLong;
import java.util.logging.*;
import org.apache.commons.pool.BasePoolableObjectFactory;
import org.apache.commons.pool.PoolableObjectFactory;
import org.quickserver.net.client.BlockingClient;

import org.quickserver.net.server.ClientHandler;
import org.quickserver.util.pool.PoolableObject;

/**
 *
 * @author Akshathkumar Shetty
 */
public class Data extends Thread implements ClientData, PoolableObject {
	private static final Logger logger = Logger.getLogger(Data.class.getName());
	private static int threadId = 0;

	private static boolean logHex = false;
	private static boolean logText = false;

	private Socket socket;
	private ClientHandler handler;
	private BufferedInputStream bin;
	private BufferedOutputStream bout;

	private String remoteHost = "127.0.0.1";
	private int remotePort = 8080;

	private boolean init = false;	
	private boolean closed = false;
	private final Object lock = new Object();
	
	private boolean stopThead;
	
	private InterfaceServer interfaceServer;

	public Data(){
		super();
		int tid = 0;
		synchronized(lock) {
			tid = ++threadId;
		}
		setName("DataThread-"+tid);
		setDaemon(true);
		start();
	}

	public void setRemoteHost(String remoteHost) {
		this.remoteHost = remoteHost;
	}
	public String getRemoteHost() {
		return remoteHost;
	}

	public void setRemotePort(int remotePort) {
		this.remotePort = remotePort;
	}
	public int getRemotePort() {
		return remotePort;
	}

	public void setClosed(boolean flag) {
		closed = flag;
	}

	public void init(Socket socket, ClientHandler handler) {
		this.socket = socket;
		this.handler = handler;
		closed = false;
		try	{
			bin = new BufferedInputStream(socket.getInputStream());
			bout = new BufferedOutputStream(socket.getOutputStream());
			init = true;
			synchronized(lock) {
				lock.notify();
			}
		} catch(Exception e) {
			logger.log(Level.WARNING, "Error in init: "+e, e);
			interfaceServer.getStats().getConErrorCount().incrementAndGet();
			handler.closeConnection();
			init = false;
			closed = true;
		}
	}

	public void preclean() {
		try	{
			if(bin!=null) bin.close();
		} catch(Exception e) {
			logger.log(Level.FINE, "Error in preclean1: "+e, e);
		}
		
		try	{
			if(bout!=null) bout.close();
		} catch(Exception e) {
			logger.log(Level.FINE, "Error in preclean2: "+e, e);
		}
		
		try	{
			if(socket!=null) socket.close();
		} catch(Exception e) {
			logger.log(Level.FINE, "Error in preclean3: "+e, e);
		}
	}

	public void run() {
		logger.log(Level.FINE, "start thread {0}", getName());
		
		byte data[];
		while(true) {
			try	{
				if(init==false) {
					synchronized(lock) {
						lock.wait();
					}
					
					if(stopThead) {
						logger.log(Level.FINE, "stop thread {0}", getName());
						return;
					} else {
						continue;
					}
				}
				
				data = BlockingClient.readInputStream(bin);
				if(data==null) {
					init = false;
					logger.fine("got eof from remote pipe");
					handler.closeConnection();
				} else {
					interfaceServer.getStats().getOutByteCount().addAndGet(data.length);
					handler.sendClientBinary(data);
					
					if(logText) {
						logger.log(Level.FINE, "S:Text: {0}", new String(data));
					}
					if(logHex) {
						logger.log(Level.FINE, "S:Hex : {0}", hexencode(data));
					}
				}
			} catch(Exception e) {
				if(interfaceServer!=null) {
					interfaceServer.getStats().getConErrorCount().incrementAndGet();
				}
				init = false;
				if(closed==false) {
					logger.log(Level.WARNING, "Error in data thread : "+e, e);
				} else {
					//logger.log(Level.FINEST, "Error after connection was closed in data thread : {0}", e);
				}
				//e.printStackTrace();
			}
		}//end of while
	}

	public void sendData(byte data[]) throws IOException {
		if(init==false)
			throw new IOException("Data is not yet init!");
		if(logText) {
			logger.log(Level.FINE, "C:Text: {0}", new String(data));
		}
		if(logHex) {
			logger.log(Level.FINE, "C:Hex : {0}", hexencode(data));
		}

		try	{
			interfaceServer.getStats().getInByteCount().addAndGet(data.length);
			bout.write(data, 0, data.length);
			bout.flush();
		} catch(Exception e) {
			interfaceServer.getStats().getConErrorCount().incrementAndGet();
			if(closed==false) {
				logger.log(Level.WARNING, "Error sending data: "+e, e);
				throw new IOException(e.getMessage());
			} else {
				logger.log(Level.FINE, "Error after connection was closed : sending data : "+e, e);
			}
		}		
	}

	public void clean() {
		if(socket!=null && socket.isConnected()) {
			preclean();
		}
		
		socket = null;
		init = false;
		handler = null;
		bin = null;
		bout = null;
		remoteHost = "127.0.0.1";
		remotePort = 8080;
		
		setInterfaceServer(null);
	}
	
	public boolean isPoolable() {
		return true;
	}

	public PoolableObjectFactory getPoolableObjectFactory() {
		return  new BasePoolableObjectFactory() {
			public Object makeObject() { 
				return new Data();
			} 
			public void passivateObject(Object obj) {
				Data ed = (Data)obj;
				ed.clean();
			} 
			public void destroyObject(Object obj) {
				if(obj==null) return;
				
				Data data = (Data) obj;
				data.stopThead = true;
				
				synchronized(data.lock) {
					data.lock.notify();
				}
				
				passivateObject(obj);
				
				obj = null;
			}
			public boolean validateObject(Object obj) {
				if(obj==null) 
					return false;
				else {
					Data data = (Data) obj;
					if(data.isAlive()) {
						logger.log(Level.FINEST, "{0} is alive", data.getName());
						return true;
					} else {
						logger.log(Level.FINEST, "{0} is not alive", data.getName());
						return false;
					}
				}
			}
		};
	}

	//-- helper methods --
	
	public static String hexencode(byte[] rawData) {
		StringBuilder hexText = new StringBuilder();
		String initialHex;
		int initHexLength;

		for (int i = 0; i < rawData.length; i++) {
			int positiveValue = rawData[i] & 0x000000FF;
			initialHex = Integer.toHexString(positiveValue);
			initHexLength = initialHex.length();
			while (initHexLength++ < 2) {
				hexText.append("0");
			}
			hexText.append(initialHex);
		}
		return hexText.toString();
	}

	/**
	 * @return the interfaceServer
	 */
	public InterfaceServer getInterfaceServer() {
		return interfaceServer;
	}

	/**
	 * @param interfaceServer the interfaceServer to set
	 */
	public void setInterfaceServer(InterfaceServer interfaceServer) {
		this.interfaceServer = interfaceServer;
	}
}
