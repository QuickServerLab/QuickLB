package com.quickserverlab.quicklb.server;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.quickserver.net.client.Host;
import org.quickserver.net.client.HostList;
import org.quickserver.net.client.SocketBasedHost;
import org.quickserver.net.client.loaddistribution.LoadDistributor;
import org.quickserver.net.client.loaddistribution.impl.FirstActiveLoadPattern;
import org.quickserver.net.client.loaddistribution.impl.HashedLoadPattern;
import org.quickserver.net.client.loaddistribution.impl.RandomLoadPattern;
import org.quickserver.net.client.loaddistribution.impl.RoundRobinLoadPattern;
import org.quickserver.net.client.monitoring.HostMonitoringService;
import org.quickserver.net.client.monitoring.HostStateListener;
import org.quickserver.net.client.monitoring.impl.SocketMonitor;

/**
 *
 * @author Akshathkumar Shetty
 */
public class InterfaceHosts {
	private static final Logger logger = Logger.getLogger(InterfaceHosts.class.getName());
	
	private HostList hostList;
	private HostMonitoringService hostMonitoringService;
	private LoadDistributor loadDistributor;
	
	public void shutdown() {
		if(hostMonitoringService!=null) {
			HostMonitoringService.remove(hostMonitoringService);
			hostMonitoringService = null;
		}
		loadDistributor = null;
		hostList = null;
	}
	
	public void init(File path, InterfaceServer interfaceServer) {
		File interfaceDir = path;
		if(interfaceDir.canRead()==false) {
			logger.log(Level.SEVERE, "can''t read interface dir: {0}", interfaceDir);
			throw new RuntimeException("can''t read interface dir: "+interfaceDir);
		}
		
		File list[] = interfaceDir.listFiles();
		if(list==null) {
			logger.log(Level.SEVERE, "Can''t read domains config dir.. got null list: {0}", interfaceDir);
			throw new RuntimeException("Can't read domains config dir.. got null list: "+
					interfaceDir);
		}
		
		String interfaceName = path.getName();
		
		HostList _hostList = new HostList(interfaceName);
		
		FileInputStream myInputStream = null;
		Properties config = null;
		
		for(int i=0;i<list.length;i++) {
			if(list[i].isDirectory()) continue;
			
			String fname = list[i].getName().toLowerCase();
			
			if(fname.startsWith(".")) {
				continue;
			}
			
			if(fname.endsWith(".txt")==false) {
				if(fname.equals("interface.ini")==false && 
					fname.equals("interface.xml")==false)
				logger.log(Level.FINE, "unknown file.. will skip:{0}", list[i].getName());
				continue;
			}
			
			try {
				config = new Properties();
				myInputStream = new FileInputStream(list[i]);
				config.load(myInputStream);
			} catch (Exception e) {
				logger.log(Level.SEVERE, "Could not load[{0}] {1}", 
					new Object[]{list[i].getAbsolutePath(), e});
				continue;
			} finally {
				if(myInputStream!=null) {
					try {
						myInputStream.close();
					} catch (IOException ex) {
						logger.log(Level.SEVERE, "Error", ex);
					}
				}
				myInputStream = null;
			}
			
			if(list[i].getName().endsWith(".txt")) {
				String hostName = list[i].getName();
				int extIndex = hostName.lastIndexOf(".");
				if(extIndex!=-1) {
					hostName = hostName.substring(0, extIndex);
				}
						
				logger.log(Level.FINE, "hostName: {0}", interfaceName + "_" + hostName);
				
				try {
					String type = config.getProperty("type");
					String host = config.getProperty("host");
					int port = Integer.parseInt(config.getProperty("port"));
				
					if(host==null) {
						logger.log(Level.WARNING, "No host configured! for {0}", 
							interfaceName + "_" + hostName);
						continue;
					}
					
					if(port==0) {
						logger.log(Level.WARNING, "No port configured! for {0}", 
							interfaceName + "_" + hostName);
						continue;
					}
					
					SocketBasedHost sbhost = new SocketBasedHost(host, port);
					sbhost.setName(interfaceName + "_" + hostName);
					
					if(type.equals("sslsocket")) {
						sbhost.setSecure(true);
					}
					
					String temp = config.getProperty("maintainance");
					if("true".equals(temp)) {
						sbhost.setStatus(Host.MAINTENANCE);
					}
					
					temp = config.getProperty("TextToExpect");
					if(temp!=null && temp.trim().length()!=0) {
						sbhost.setTextToExpect(temp);
					} else {
						sbhost.setTextToExpect(null);
					}
					
					temp = config.getProperty("RequestText");
					if(temp!=null && temp.trim().length()!=0) {
						sbhost.setRequestText(temp);
					} else {
						sbhost.setRequestText(null);
					}
					
					temp = config.getProperty("ResponseTextToExpect");
					if(temp!=null && temp.trim().length()!=0) {
						sbhost.setResponseTextToExpect(temp);
					} else {
						sbhost.setResponseTextToExpect(null);
					}
					
					temp = config.getProperty("timeout");
					sbhost.setTimeout(Integer.parseInt(temp));
					
					temp = config.getProperty("default");
					if("1".equals(temp)) {
						_hostList.addDefault(sbhost);
					} else {
						_hostList.add(sbhost);
					}
				} catch (Exception ex) {
					logger.log(Level.SEVERE, "Error: "+ex, ex);
				}				
			}
		}//for

		setHostList(_hostList);
		
		hostMonitoringService = new HostMonitoringService();
		hostMonitoringService.setHostList(_hostList);
		hostMonitoringService.setHostMonitor(new SocketMonitor());
		hostMonitoringService.setIntervalInSec(
			interfaceServer.getMonitoringIntervalInSec());

		HostStateListener hsl = new HostStateListener() {
			@Override
			public void stateChanged(Host host, char oldstatus, char newstatus) {
				if(oldstatus!=Host.UNKNOWN) {
					logger.log(Level.SEVERE, "State changed: {0}; old state: {1};new state: {2}", 
						new Object[]{host, oldstatus, newstatus});
				} else {
					logger.log(Level.INFO, "State changed: {0}; old state: {1};new state: {2}", 
						new Object[]{host, oldstatus, newstatus});
				}
			}
		};
		hostMonitoringService.addHostStateListner(hsl);

		HostMonitoringService.add(hostMonitoringService);
		
		setLoadDistributor(new LoadDistributor(getHostList()));
		setLoadDistributor(getLoadDistributor());
		if("roundrobin".equals(interfaceServer.getDistribution())) {
			getLoadDistributor().setLoadPattern(new RoundRobinLoadPattern());
		} else if("failover".equals(interfaceServer.getDistribution())) {
			getLoadDistributor().setLoadPattern(new FirstActiveLoadPattern());
		} else if("ip_based".equals(interfaceServer.getDistribution())) {
			getLoadDistributor().setLoadPattern(new HashedLoadPattern());
		} else {
			getLoadDistributor().setLoadPattern(new RandomLoadPattern());
		}
	}

	/**
	 * @return the hostList
	 */
	public HostList getHostList() {
		return hostList;
	}

	/**
	 * @param hostList the hostList to set
	 */
	public void setHostList(HostList hostList) {
		this.hostList = hostList;
	}

	/**
	 * @return the loadDistributor
	 */
	public LoadDistributor getLoadDistributor() {
		return loadDistributor;
	}

	/**
	 * @param loadDistributor the loadDistributor to set
	 */
	public void setLoadDistributor(LoadDistributor loadDistributor) {
		this.loadDistributor = loadDistributor;
	}
}
