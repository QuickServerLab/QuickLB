package com.quickserverlab.quicklb.server;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
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
import org.quickserver.util.TextFile;

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
		logger.log(Level.INFO, "Init hosts for {0}", interfaceServer.getName());
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
				if(fname.endsWith(".req_data") || fname.endsWith(".res_data") 
						|| fname.endsWith(".welcome_data")) {
					continue;					
				}
				
				if(fname.equals("interface.ini") || fname.equals("interface.xml")) {
					continue;
				}
				
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
						
				logger.log(Level.FINE, "hostName: {0}", interfaceName + "|" + hostName);
				
				try {
					String type = config.getProperty("type");
					String host = config.getProperty("host");
					int port = Integer.parseInt(config.getProperty("port"));
				
					if(host==null) {
						logger.log(Level.WARNING, "No host configured! for {0}", 
							interfaceName + "|" + hostName);
						continue;
					}
					
					if(port==0) {
						logger.log(Level.WARNING, "No port configured! for {0}", 
							interfaceName + "|" + hostName);
						continue;
					}
					
					SocketBasedHost sbhost = new SocketBasedHost(host, port);
					sbhost.setName(interfaceName + "|" + hostName);
					
					if(type.equals("sslsocket")) {
						sbhost.setSecure(true);
					}
					
					String temp = config.getProperty("maintenance");
					if("true".equals(temp)) {
						sbhost.setStatus(Host.MAINTENANCE);
					}
					
					temp = null;
					
					File file = new File(list[i].getParent()+
							File.separator+hostName+".welcome_data");
					if(file.canRead()) {
						temp = TextFile.read(file); //config.getProperty("TextToExpect");
					}
					if(temp!=null && temp.trim().length()!=0) {
						sbhost.setTextToExpect(temp);
					} else {
						sbhost.setTextToExpect(null);
					}
					temp = null;
					
					file = new File(list[i].getParent()+
							File.separator +hostName+".req_data");
					if(file.canRead()) {
						temp = TextFile.read(file); //config.getProperty("RequestText");
					}
					if(temp!=null && temp.trim().length()!=0) {
						sbhost.setRequestText(temp);
					} else {
						sbhost.setRequestText(null);
					}
					temp = null;
					
					file = new File(list[i].getParent()+
							File.separator + hostName+".res_data");
					if(file.canRead()) {
						temp = TextFile.read(file); //config.getProperty("ResponseTextToExpect");
					}
					if(temp!=null && temp.trim().length()!=0) {
						sbhost.setResponseTextToExpect(temp);
					} else {
						sbhost.setResponseTextToExpect(null);
					}
					temp = null;
					
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
		
		logger.log(Level.INFO, "MonitoringIntervalInSec: {0}", interfaceServer.getMonitoringIntervalInSec());
		
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
	
		
		if("roundrobin".equals(interfaceServer.getDistribution())) {
			getLoadDistributor().setLoadPattern(new RoundRobinLoadPattern());
		} else if("failover".equals(interfaceServer.getDistribution())) {
			getLoadDistributor().setLoadPattern(new FirstActiveLoadPattern());
		} else if("ip_based".equals(interfaceServer.getDistribution())) {
			getLoadDistributor().setLoadPattern(new HashedLoadPattern());
		} else {
			getLoadDistributor().setLoadPattern(new RandomLoadPattern());
		}
		
		logger.log(Level.INFO, "LoadDistributor: {0}", getLoadDistributor().getLoadPattern().toString());
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
	
	public static String getRealNodeName(Host host) {
		String name = host.getName();
		int i = name.indexOf("|");
		return name.substring(i+1);
	}
	
	public boolean deleteSocketBasedHostFromDisk(InterfaceServer is, SocketBasedHost host) {
		logger.log(Level.INFO, "is: {0}host: {1}", new Object[]{is.getName(), host.getName()});
		try {
			File location = new File(
				is.getParentDir().getAbsolutePath() +
						File.separator + getRealNodeName(host) + ".txt");
			logger.log(Level.INFO, "location: {0}", location);
			if(location.canRead()) {
				boolean flag = location.delete();
				logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
			}
			
			location = new File(
				is.getParentDir().getAbsolutePath() +
						File.separator + getRealNodeName(host) + ".welcome_data");
			logger.log(Level.INFO, "location: {0}", location);
			if(location.canRead()) {
				boolean flag = location.delete();
				logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
			}
			
			location = new File(
				is.getParentDir().getAbsolutePath() +
						File.separator+ getRealNodeName(host) + ".req_data");
			logger.log(Level.INFO, "location: {0}", location);
			if(location.canRead()) {
				boolean flag = location.delete();
				logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
			}
			
			location = new File(
				is.getParentDir().getAbsolutePath() +
						File.separator+ getRealNodeName(host) + ".res_data");
			logger.log(Level.INFO, "location: {0}", location);
			if(location.canRead()) {
				boolean flag = location.delete();
				logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
			}
			
			return true;
		} catch (Exception io) {
			logger.log(Level.WARNING, "Error: "+io, io);
			return false;
		}
	}
	
	public boolean saveSocketBasedHostToDisk(InterfaceServer is, SocketBasedHost host, String newName, boolean defaultFalg) {
		OutputStream output = null;
		logger.log(Level.INFO, "is: {0}host: {1}-{2}", new Object[]{is.getName(), host.getName(), newName});
		try {
			String oldName = getRealNodeName(host);
			boolean rename = false;
			if(newName!=null && oldName.equals(newName)==false) {
				//rename req.
				rename = true;
			}
			
			if(newName==null) {
				newName = oldName;
			}
			
			Properties hostConfig = new Properties();
			
			if(host.isSecure()) {
				hostConfig.setProperty("type", "sslsocket");
			} else {
				hostConfig.setProperty("type", "socket");
			}
			
			if(host.getStatus()==Host.MAINTENANCE) {
				hostConfig.setProperty("maintenance", "true");
			} else {
				hostConfig.setProperty("maintenance", "false");
			}
			
			hostConfig.setProperty("host", 
				host.getInetAddress().getHostAddress());
			hostConfig.setProperty("port", ""+host.getInetSocketAddress().getPort());
			
			hostConfig.setProperty("timeout", ""+host.getTimeout());
			
			if(defaultFalg) {
				hostConfig.setProperty("default", "1");
			} else {
				hostConfig.setProperty("default", "0");
			}
			
			File location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator+ newName + ".txt");
			
			File commentsFile = new File(
					"./conf/node_template/node_comment.ini");
			String comments = TextFile.read(commentsFile);
			
			output = new FileOutputStream(location);

			// save properties to project root folder
			hostConfig.store(output, comments);
			
			if(host.getTextToExpect()!=null && host.getTextToExpect().length()!=0) {
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + newName + ".welcome_data");
				logger.log(Level.INFO, "location: {0}", location);
				TextFile.write(location, host.getTextToExpect());
			} else {
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + newName + ".welcome_data");
				if(location.canRead()) {
					boolean flag = location.delete();
					logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
				}
			}
			
			if(host.getRequestText()!=null && host.getRequestText().length()!=0) {
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + newName + ".req_data");
				logger.log(Level.INFO, "location: {0}", location);
				TextFile.write(location, host.getRequestText());
			} else {
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + newName + ".req_data");
				if(location.canRead()) {
					boolean flag = location.delete();
					logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
				}
			}
			
			if(host.getResponseTextToExpect()!=null && host.getResponseTextToExpect().length()!=0) {
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + newName + ".res_data");
				logger.log(Level.INFO, "location: {0}", location);
				TextFile.write(location, host.getResponseTextToExpect());
			} else {
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + newName + ".res_data");
				if(location.canRead()) {
					boolean flag = location.delete();
					logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
				}
			}
			
			if(rename) {
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + oldName + ".txt");
				
				if(location.canRead()) {
					boolean flag = location.delete();
					logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
				}
				
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + oldName + ".welcome_data");
				if(location.canRead()) {
					boolean flag = location.delete();
					logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
				}
				
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + oldName + ".req_data");
				if(location.canRead()) {
					boolean flag = location.delete();
					logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
				}
				
				location = new File(
					is.getParentDir().getAbsolutePath() +
							File.separator + oldName + ".res_data");
				if(location.canRead()) {
					boolean flag = location.delete();
					logger.log(Level.INFO, "file {0}; deleted: {1}", new Object[]{location, flag});
				}
			}

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
}
