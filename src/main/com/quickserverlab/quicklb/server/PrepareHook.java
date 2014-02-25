package com.quickserverlab.quicklb.server;


import java.io.File;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.quickserver.net.ServerHook;
import org.quickserver.net.server.QuickServer;

/**
 *
 * @author Akshathkumar Shetty
 */
public class PrepareHook implements ServerHook {
	private static final Logger logger = Logger.getLogger(PrepareHook.class.getName());
	
	private QuickServer quickserver;

	public String info() {
		return "Init Server Hook to setup cache.";
	}

	public void initHook(QuickServer quickserver) {
		this.quickserver = quickserver;
	}

	public boolean handleEvent(int event) {
		if(event==ServerHook.PRE_STARTUP) {
			Map config = quickserver.getConfig().getApplicationConfiguration();
			
			//path, is
			Object[] storeObj = quickserver.getStoreObjects();
			
			InterfaceServer interfaceServer = (InterfaceServer) storeObj[1];
			
			try {
				//String maxSizeForKey = (String) config.get("MAX_SIZE_FOR_KEY");
				//init host monitor
				
				InterfaceHosts iHosts = new InterfaceHosts();
				iHosts.init((File) storeObj[0], interfaceServer);
				
				if(interfaceServer.getInterfaceHosts()!=null) {
					interfaceServer.getInterfaceHosts().shutdown();
				}
				interfaceServer.setInterfaceHosts(iHosts);
				
			} catch(Exception e) {
				logger.log(Level.WARNING, "Error: "+e, e);
			}
			return true;
		}
		
		if(event==ServerHook.POST_SHUTDOWN) {
			//path, is
			Object[] storeObj = quickserver.getStoreObjects();
			
			InterfaceServer interfaceServer = (InterfaceServer) storeObj[1];
			if(interfaceServer.getInterfaceHosts()!=null) {
				interfaceServer.getInterfaceHosts().shutdown();
				interfaceServer.setInterfaceHosts(null);
			}
		}
		
		return false;
	}
}