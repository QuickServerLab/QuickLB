package com.quickserverlab.quicklb.server;

//import java.net.*;
import com.quickserverlab.quicklb.file.FileUtil;
import java.io.*;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.concurrent.ConcurrentHashMap;
import java.util.logging.*;
import org.quickserver.net.*;
import org.quickserver.net.server.*;

import org.quickserver.util.TextFile;

/**
 * A simple redirect server.
 * @author Akshathkumar Shetty
 */
public class InterfaceServer {
	private static final Logger logger = Logger.getLogger(InterfaceServer.class.getName());
	
	private static Map<String,InterfaceServer> interfaces = 
		new ConcurrentHashMap<String, InterfaceServer>();
	
	private String name;
	private QuickServer quickserver;
	private InterfaceHosts interfaceHosts;
	private boolean autoStart;
	private Properties config;
	private int monitoringIntervalInSec = 10;
	private String distribution = "roundrobin";
	private File parentDir;
	
	private InterfaceStats stats = new InterfaceStats();
	
	public static void initInterfaces() {
		File[] list = FileUtil.getFilesList("./interfaces");
		
		
		Iterator<String> iterator = interfaces.keySet().iterator();
		if(iterator.hasNext()) {
			System.out.println();
			logger.fine("Unloading interfaces\t[Start]");
			System.out.println("Unloading interfaces\t[Start]");		
			String key = null;
			InterfaceServer is = null;
			while (iterator.hasNext()) {
				key = iterator.next();
				is = (InterfaceServer) interfaces.get(key);
				try {
					if(is.isUp()) {
						is.stop();
					}
				} catch(Exception e) {
					logger.log(Level.WARNING, "Error stopping server: "+e, e);
				}
			}		
			System.out.println("Unloading interfaces\t[Done]");
			logger.fine("Unloading interfaces\t[Done]");
			interfaces.clear();
		}
		
		System.out.println();
		logger.fine("Loading interfaces\t[Start]");
		System.out.println("Loading interfaces\t[Start]");
		for (int i = 0; i < list.length; i++) {
			if (list[i].isFile()) {
				continue;
			}			
			
			InterfaceServer.loadInterface(list[i]);			
		}		
		System.out.println("Loading interfaces\t[Done]");
		logger.fine("Loading interfaces\t[Done]");
	}
	
	
	public static void loadInterface(File path)	{
		InterfaceServer is = getInterfaces().get(path.getName());
		
		try {
			logger.log(Level.INFO, "loadInterface is: {0} : {1}", new Object[]{path, is});
			if(is!=null) {
				logger.log(Level.INFO, "is.isUp: {0}", is.isUp());
				if(is.isUp()) {
					System.out.print("  "+path.getName()+" : ");
					is.stop();
					System.out.print(" Stopped "+
							is.getQuickserver().getBindAddr().getHostAddress()+":"+
							is.getQuickserver().getPort());
					System.out.println();
				}
			} 

			is = create(path);
			getInterfaces().put(path.getName(), is);

			if(is!=null) {
				logger.log(Level.INFO, "is AutoStart: {0}", is.isAutoStart());
				
				if(is.isAutoStart()) {
					logger.log(Level.INFO, "Starting Interface {0} : {1}:{2}", 
							new Object[]{path.getName(), 
								is.getQuickserver().getBindAddr().getHostAddress(), 
								is.getQuickserver().getPort()});
					is.start();
					System.out.print("  "+path.getName()+" : ");
					System.out.print(" Started "+
							is.getQuickserver().getBindAddr().getHostAddress()+":"+
							is.getQuickserver().getPort());
					System.out.println();
				}
				logger.log(Level.INFO, "is.isUp: {0}", is.isUp());
			}
		} catch(Throwable e) {
			logger.log(Level.WARNING, "Error: "+e, e);
			System.out.print("  "+path.getName()+" : ");	
			if(is!=null) {
				System.out.print(" Error "+
							is.getQuickserver().getBindAddr().getHostAddress()+":"+
							is.getQuickserver().getPort()+
							e.getMessage());
			} else {
				System.out.print(" Error "+	e.getMessage());
			}
			System.out.println();
		}
		
	}
	
	public boolean saveQSXmlToDisk(File location) {
		logger.log(Level.INFO, "File loc: {0}", location);
		try {
			
			TextFile.write(location, getQuickserver().getConfig().toXML(null));	
			return true;
		} catch(Exception e) {
			logger.log(Level.WARNING, "Error writing full xml configuration: "+e, e);
			return false;
		}
	}
	public boolean saveConfigToDisk(File location) {
		OutputStream output = null;
		logger.log(Level.INFO, "File loc: {0}", location);
		try {
			File commentsFile = new File(
				"./conf/node_template/interface_comment.ini");
			String comments = TextFile.read(commentsFile);
			
			output = new FileOutputStream(location);

			// save properties to project root folder
			getConfig().store(output, comments);

			return true;
		} catch (IOException io) {
			logger.log(Level.WARNING, "Error: "+io, io);
			return false;
		} finally {
			if (output != null) {
				try {
					output.close();
				} catch (IOException e) {
					logger.log(Level.WARNING, "Error closing: "+e, e);
				}
			}
		}
	}
	
	public boolean isUp() throws AppException {
		if(getQuickserver()==null) return false;
		
		return getQuickserver().isClosed()==false;
	}
	
	public boolean start() throws AppException {
		if(getQuickserver()==null) return false;
		
		refreshConfig();
		getQuickserver().startServer();
		
		return true;
	}
	
	public boolean stop() throws AppException {
		if(getQuickserver()==null) return false;
		
		getQuickserver().stopServer();
		
		return true;
	}
	
	public boolean deleteInterface() throws AppException {
		logger.log(Level.WARNING, "Deleting interface {0}", getName());
		if(isUp()) throw new AppException("Interface is still running!");
		
		logger.log(Level.INFO, "Dir: {0}", getParentDir());
		boolean flag = getParentDir().delete();
		logger.log(Level.WARNING, "Deleting interface {0}", flag);
		if(flag) {
			interfaces.remove(getName());
			return true;
		}
		
		return false;
	}
	
	public static InterfaceServer createDefaultInterface(String name) throws Exception {
		File folder = new File("./interfaces/"+name);
		if(folder.canRead()) {
			throw new IOException("interface with this name already exists!");
		}
		
		folder.mkdir();
		
		File interfaceConfigTemplate = new File("./conf/node_template/interface.ini");
		String temp = TextFile.read(interfaceConfigTemplate);
		File interfaceConfig = new File("./interfaces/"+name+"/interface.ini");
		TextFile.write(interfaceConfig, temp);
		
		File interfaceQsXmlTemplate = new File("./conf/node_template/interface.xml");
		temp = TextFile.read(interfaceQsXmlTemplate);
		File interfaceQsXml = new File("./interfaces/"+name+"/interface.xml");
		TextFile.write(interfaceQsXml, temp);
		
		InterfaceServer is = create(folder);
		return is;
	}
	
	public static InterfaceServer create(File path)	throws AppException {
		InterfaceServer is = new InterfaceServer();
		is.setParentDir(path);
		is.refreshConfig();
		return is;
	}
	
	private void refreshConfig() throws AppException {		
		try {
			logger.log(Level.FINE, "path: {0}", getParentDir());
			setName(getParentDir().getName());
			
			QuickServer myServer = new QuickServer();
			setQuickserver(myServer);

			String confFile = getParentDir().getCanonicalPath() + File.separator + "interface.xml";
			logger.log(Level.FINE, "confFile: {0}", confFile);

			Object config[] = new Object[] {confFile};
			myServer.initService(config);
			
			Properties _config = FileUtil.loadPropertiesFromFile(
				getParentDir().getCanonicalPath() + File.separator + "interface.ini");
			logger.log(Level.FINE, "config: {0}", _config);
			setConfig(_config);
			
			Object[] store = new Object[]{getParentDir(), this};
			myServer.setStoreObjects(store);
						
			myServer.setServerBanner("");
		} catch(IOException e) {
			logger.log(Level.WARNING, "IOError: "+e, e);
			throw new AppException(e.getMessage());
		}
	}

	/**
	 * @return the quickserver
	 */
	public QuickServer getQuickserver() {
		return quickserver;
	}

	/**
	 * @param quickserver the quickserver to set
	 */
	public void setQuickserver(QuickServer quickserver) {
		this.quickserver = quickserver;
	}

	/**
	 * @return the autoStart
	 */
	public boolean isAutoStart() {
		return autoStart;
	}

	/**
	 * @param autoStart the autoStart to set
	 */
	public void setAutoStart(boolean autoStart) {
		this.autoStart = autoStart;
	}

	/**
	 * @return the config
	 */
	public Properties getConfig() {
		return config;
	}

	/**
	 * @param config the config to set
	 */
	public void setConfig(Properties config) {
		this.config = config;
		
		String _autoStart = config.getProperty("auto_start");
		if("true".equals(_autoStart)) {
			setAutoStart(true);
		} else {
			setAutoStart(false);
		}
		
		String _monitoringIntervalInSec = config.getProperty("monitoringIntervalInSec");
		setMonitoringIntervalInSec(Integer.parseInt(_monitoringIntervalInSec));
		
		String _distribution = config.getProperty("distribution");
		if(_distribution!=null) {
			setDistribution(_distribution);
		}
	}

	/**
	 * @return the interfaceHosts
	 */
	public InterfaceHosts getInterfaceHosts() {
		return interfaceHosts;
	}

	/**
	 * @param interfaceHosts the interfaceHosts to set
	 */
	public void setInterfaceHosts(InterfaceHosts interfaceHosts) {
		this.interfaceHosts = interfaceHosts;
	}

	/**
	 * @return the monitoringIntervalInSec
	 */
	public int getMonitoringIntervalInSec() {
		return monitoringIntervalInSec;
	}

	/**
	 * @param monitoringIntervalInSec the monitoringIntervalInSec to set
	 */
	public void setMonitoringIntervalInSec(int monitoringIntervalInSec) {
		this.monitoringIntervalInSec = monitoringIntervalInSec;
	}

	/**
	 * @return the distribution
	 */
	public String getDistribution() {
		return distribution;
	}

	/**
	 * @param distribution the distribution to set
	 */
	public void setDistribution(String distribution) {
		this.distribution = distribution;
	}

	/**
	 * @return the interfaces
	 */
	public static Map<String,InterfaceServer> getInterfaces() {
		return interfaces;
	}

	/**
	 * @param aInterfaces the interfaces to set
	 */
	public static void setInterfaces(Map<String,InterfaceServer> aInterfaces) {
		interfaces = aInterfaces;
	}

	/**
	 * @return the parentDir
	 */
	public File getParentDir() {
		return parentDir;
	}

	/**
	 * @param parentDir the parentDir to set
	 */
	public void setParentDir(File parentDir) {
		this.parentDir = parentDir;
	}

	/**
	 * @return the name
	 */
	public String getName() {
		return name;
	}

	/**
	 * @param name the name to set
	 */
	public void setName(String name) {
		this.name = name;
	}
	
	/**
	 * @return the stats
	 */
	public InterfaceStats getStats() {
		return stats;
	}

	/**
	 * @param stats the stats to set
	 */
	public void setStats(InterfaceStats stats) {
		this.stats = stats;
	}
	
	/*
	Test Code
	static {
		Iterator<String> iterator = interfaces.keySet().iterator();
		String key = null;
		InterfaceServer is = null;		
		
		while(iterator.hasNext()) {
			key = iterator.next();
			is = interfaces.get(key);
			
			InterfaceHosts ih = is.getInterfaceHosts();
			HostList hostList = ih.getHostList();
			//hostList.getHostByName(null)
			List<SocketBasedHost> list = (List<SocketBasedHost>)hostList.getFullList();
			if(list.isEmpty()) {
				
			}
			for(int i=0;i<list.size();i++) {
				
				list.get(i).getInetSocketAddress().getPort();
				
				list.get(i).getResponseTextToExpect()
			}
			
			SocketBasedHost sbh = new SocketBasedHost();
			sbh.setName();
			sbh.setSecure();
			sbh.setStatus(Host.UNKNOWN);
			sbh.setInetSocketAddress(null, port);
			sbh.setTimeout();
			sbh.setTextToExpect();
			sbh.setRequestText();			
			sbh.setResponseTextToExpect();
		}
	}
	*/
}
