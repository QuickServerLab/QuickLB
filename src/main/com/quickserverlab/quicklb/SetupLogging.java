package com.quickserverlab.quicklb;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.logging.LogManager;

/**
 *
 * @author Akshathkumar Shetty
 */
public class SetupLogging {

	private static boolean init;
	private static boolean makeLogFile = true;

	public static boolean setupJavaLogging() {
		if (init == false) {
			init = true;
		} else {
			return false;
		}

		File logFile = new File("./log/");
		if (logFile.canRead() == false) {
			logFile.mkdirs();
		}

		
		FileInputStream configFile = null;
		try {
			configFile = new FileInputStream("./conf/jdk_logging.properties");			
			LogManager.getLogManager().readConfiguration(configFile);
		} catch (IOException ex) {
			System.out.println("WARNING: Could not open jdk logging configuration file"+ex);
			System.out.println("WARNING: Logging not configured (console output only)");
		} finally {
			if(configFile!=null) {
				try {
					configFile.close();
				} catch (IOException ex) {
					System.out.println("WARNING: closing jdk_logging.properties file: "+ ex);
				}
			}
		}

		return true;
	}
}
