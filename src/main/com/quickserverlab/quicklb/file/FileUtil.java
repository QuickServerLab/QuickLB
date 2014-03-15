package com.quickserverlab.quicklb.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Akshathkumar Shetty
 */
public class FileUtil {
	private static final Logger logger = Logger.getLogger(FileUtil.class.getName());
	
	public static Properties loadPropertiesFromFile(String fileS) {
		File file = new File(fileS);
		return loadPropertiesFromFile(file);
	}
	
	public static Properties loadPropertiesFromFile(File file) {
		if(file.canRead()==false) return null;
		
		FileInputStream myInputStream = null;
		Properties config = null;
		try {
			logger.log(Level.FINE, "loading properties for host:{0}", file.getName());
			config = new Properties();
			myInputStream = new FileInputStream(file);
			config.load(myInputStream);
		} catch (Exception e) {
			logger.log(Level.SEVERE, "Could not load[{0}] {1}", new Object[]{file.getAbsolutePath(), e});
		} finally {
			if (myInputStream != null) {
				try {
					myInputStream.close();
				} catch (IOException ex) {
					logger.log(Level.SEVERE, "Error", ex);
				}
			}
		}
		return config;
	}
	
	public static File[] getFilesList(String filePath) throws RuntimeException {
		File domainDir = new File(filePath);
		if (domainDir.canRead() == false) {
			logger.log(Level.SEVERE, "can''t read path: {0}", domainDir);
			throw new RuntimeException("can't read path: " + domainDir);
		}
		File list[] = domainDir.listFiles();
		if (list == null) {
			logger.log(Level.SEVERE, "Can''t read path.. got null list: {0}", domainDir);
			throw new RuntimeException("Can't read path.. got null list: "
				+ domainDir);
		}
		return list;
	}
}
