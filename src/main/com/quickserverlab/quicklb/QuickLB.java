package com.quickserverlab.quicklb;

import com.quickserverlab.quicklb.file.FileUtil;
import com.quickserverlab.quicklb.server.InterfaceServer;
import java.io.File;
import java.util.Date;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.webapp.WebAppContext;
import org.quickserver.net.server.QuickServer;
import org.quickserver.util.FileChangeListener;
import org.quickserver.util.FileChangeMonitor;

/**
 *
 * @author Akshathkumar Shetty
 */
public class QuickLB {
	public static final String VERSION = "0.1.0";
	
	private static final String CONFIG_FILE = "./conf/conf.ini";
	private static final String INTERFACE_RELOAD_FILE = "./interfaces/reload.txt";
	private static boolean waitFlag = true;
	
	private static final Logger logger = Logger.getLogger(QuickLB.class.getName());
	private static Properties config;
	
	private static Date startTime = null;
	
	public static void main(String args[]) {
		setStartTime(new Date());
		SetupLogging.setupJavaLogging();
		QuickServer.getVersion();
		
		System.out.println();
		
		System.out.println("Starting QuickLB v "+QuickLB.VERSION);
		
		monitorImportantFiles();
		
		loadConfiguration();
		
		InterfaceServer.initInterfaces();		
		
		try {
			synchronized(Thread.currentThread()){
				while (waitFlag){
					Thread.currentThread().wait();
					logger.warning("after wait");
				}
			}
		} catch (InterruptedException ex) {
			waitFlag = false;
			logger.fine("Monitor interrupted. Exiting..");
			System.exit(1);
		}
	}
	
	
	
	private static void loadConfiguration() {
		Properties _config = FileUtil.loadPropertiesFromFile(CONFIG_FILE);
		if (null == _config){
			logger.warning("conf.ini file not present or empty...");
			return;
		}
		config = _config;
		logger.log(Level.FINE, "config:{0}", config);
		
		//start or stop jetty - TODO"
		String flag = config.getProperty("enable_web_admin");
		if("true".equals(flag)) {
			
			System.setProperty("org.apache.jasper.compiler.disablejsr199", "true");
				
			String port = config.getProperty("web_admin_port");
			
			Server server = new Server(Integer.parseInt(port));
 
			WebAppContext context = new WebAppContext();
			context.setDescriptor("./src/web/admin"+"/WEB-INF/web.xml");
			context.setResourceBase("./src/web/admin");
			context.setContextPath("/");
			context.setParentLoaderPriority(true);

			server.setHandler(context);
			try {
				server.start();
			} catch (Exception ex) {
				logger.log(Level.SEVERE, "Error: "+ex, ex);
			}
			
			//System.out.println("\nAdmin Url "+server.getURI());
			System.out.println("\nAdmin Url http://127.0.0.1:"+port+"/");
		}
	}
	
	private static void monitorImportantFiles() {
		FileChangeListener fcl = new FileChangeListener() {
			@Override
			public void changed() {
				logger.info("Interface reload.txt file has changed.. re-init interfaces..");
				InterfaceServer.initInterfaces();
			}
		};
		FileChangeMonitor.addListener(INTERFACE_RELOAD_FILE, fcl);
		
		FileChangeListener fc2 = new FileChangeListener() {
			@Override
			public void changed() {
				logger.info("conf.ini has changed.. reload conf parms..");
				QuickLB.loadConfiguration();
			}
		};
		FileChangeMonitor.addListener(CONFIG_FILE, fc2);
	}

	/**
	 * @return the startTime
	 */
	public static Date getStartTime() {
		return startTime;
	}

	/**
	 * @param aStartTime the startTime to set
	 */
	public static void setStartTime(Date aStartTime) {
		startTime = aStartTime;
	}
}
