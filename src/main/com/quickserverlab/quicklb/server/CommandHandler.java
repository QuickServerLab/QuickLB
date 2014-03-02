package com.quickserverlab.quicklb.server;

import java.net.*;
import java.io.*;
import org.quickserver.net.server.ClientEventHandler;
import org.quickserver.net.server.ClientBinaryHandler;
import org.quickserver.net.server.ClientHandler;
import java.util.logging.*;
import org.quickserver.net.client.ClientInfo;
import org.quickserver.net.client.SocketBasedHost;
import org.quickserver.net.server.QuickServer;

/**
 *
 * @author Akshathkumar Shetty
 */
public class CommandHandler implements ClientEventHandler, ClientBinaryHandler {
	private static final Logger logger = Logger.getLogger(CommandHandler.class.getName());
	
	private InterfaceServer interfaceServer;
	
	@Override
	public void gotConnected(ClientHandler handler)
			throws SocketTimeoutException, IOException {
		logger.log(Level.FINE, "Connection opened: {0}", handler.getHostAddress());
		
		if(interfaceServer==null) {
			QuickServer server = handler.getServer();
			//path, is
			Object[] storeObj = server.getStoreObjects();
			interfaceServer = (InterfaceServer) storeObj[1];
		}
		
		ClientInfo ci = new ClientInfo();
		ci.setInetAddress(handler.getSocket().getInetAddress());
		ci.setClientKey(handler.getHostAddress());
		
		SocketBasedHost host = (SocketBasedHost) 
			interfaceServer.getInterfaceHosts().getLoadDistributor().getHost(ci);
		if(host==null) {
			logger.warning("We do not have any host to send traffic to.. so closing it down");
			handler.closeConnection();
			return;
		}
		
		logger.log(Level.FINEST, "SocketBasedHost: {0}", host);
		
		Data data = (Data) handler.getClientData();
		data.setRemoteHost(host.getInetSocketAddress().getHostString());
		data.setRemotePort(host.getInetSocketAddress().getPort());
		
		data.init(new Socket(data.getRemoteHost(), 
			data.getRemotePort()), handler);
	}

	@Override
	public void lostConnection(ClientHandler handler) 
			throws IOException {
		Data data=(Data)handler.getClientData();
		data.setClosed(true);
		data.preclean();
		logger.log(Level.FINE, "Connection lost: {0}", handler.getHostAddress());
	}
	@Override
	public void closingConnection(ClientHandler handler) 
			throws IOException {
		Data data=(Data)handler.getClientData();
		data.setClosed(true);
		data.preclean();
		logger.log(Level.FINE, "Connection closed: {0}", handler.getHostAddress());
	}

	
	@Override
	public void handleBinary(ClientHandler handler, byte command[])
			throws SocketTimeoutException, IOException {
		Data data=(Data)handler.getClientData();
		data.sendData(command);
	}
}
