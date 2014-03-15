package com.quickserverlab.quicklb.server;

import com.quickserverlab.quicklb.file.FileUtil;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 *
 * @author akshath
 */
public class UserValidator {
	private static final Logger logger = Logger.getLogger(UserValidator.class.getName());
	private static final String SALT_FILE = "./conf/salt.ini";
	private static final String USERS_FILE = "./conf/users.ini";
	
	public static boolean validateLogin(String name, String password) throws IOException, NoSuchAlgorithmException {
		String pwdOnRecord = getPasswordHash(name);
		if(pwdOnRecord==null) {
			logger.log(Level.FINE, "pwdOnRecord not found for {0}", name);
			return false;
		}
		
		if(pwdOnRecord.equals(makePasswordHash(password))) {
			return true;
		}
		
		return false;
	}
	
	public static String makePasswordHash(String password) throws IOException, NoSuchAlgorithmException {
		password = getSalt() + "|" + password;
		
		MessageDigest md = MessageDigest.getInstance("SHA-1");
		byte[] passbyte = password.getBytes("UTF-8");
		passbyte = md.digest(passbyte);
		
		password = bytesToHex(passbyte);
		
		return password;
	}
	
	final protected static char[] hexArray = "0123456789ABCDEF".toCharArray();
	public static String bytesToHex(byte[] bytes) {
		char[] hexChars = new char[bytes.length * 2];
		for ( int j = 0; j < bytes.length; j++ ) {
			int v = bytes[j] & 0xFF;
			hexChars[j * 2] = hexArray[v >>> 4];
			hexChars[j * 2 + 1] = hexArray[v & 0x0F];
		}
		return new String(hexChars);
	}
	
	public static String getSalt() throws IOException {
		File saltFile = new File(SALT_FILE);
		Properties saltConfig = FileUtil.loadPropertiesFromFile(saltFile);
		if(saltConfig==null) {
			logger.log(Level.FINE, "pcreating new salt");
			//create new salt
			SecureRandom random = new SecureRandom();
			byte bytes[] = new byte[25];
			random.nextBytes(bytes);
			
			String salt = bytesToHex(bytes);
			saltConfig = new Properties();
			saltConfig.put("salt", salt);
		
			OutputStream output = null;
			try {
				output = new FileOutputStream(saltFile);

				// save properties to project root folder
				saltConfig.store(output, null);
				
				return salt;
			} catch (IOException io) {
				logger.log(Level.WARNING, "Error: "+io, io);
				throw io;
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
		
		return saltConfig.getProperty("salt");
	}
	
	public static String getPasswordHash(String username) {
		File usersFile = new File(USERS_FILE);
		Properties usersConfig = FileUtil.loadPropertiesFromFile(usersFile);
		if(usersConfig==null) {
			return null;
		}
		
		return (String) usersConfig.get(username);
	}
	
	public static void setPassword(String username, String password) throws IOException, NoSuchAlgorithmException {
		logger.log(Level.FINE, "setting username & password: {0}", username);
		
		File usersFile = new File(USERS_FILE);
		Properties usersConfig = FileUtil.loadPropertiesFromFile(usersFile);
		if(usersConfig==null) {
			//create new
			usersConfig = new Properties();
		}
		
		if(usersConfig.get(username)!=null) {
			throw new IOException("User already exists!");
		}
		
		usersConfig.put(username, makePasswordHash(password));

		OutputStream output = null;
		try {
			output = new FileOutputStream(usersFile);

			usersConfig.store(output, null);
		} catch (IOException io) {
			logger.log(Level.WARNING, "Error: "+io, io);
			throw io;
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
	
	public static void changePassword(String username, String oldPassword, String password) throws IOException, NoSuchAlgorithmException {
		logger.log(Level.FINE, "changing username & password: {0}", username);
		
		if(validateLogin(username, oldPassword)==false) {
			throw new IOException("Old password does not match");
		}
		
		File usersFile = new File(USERS_FILE);
		Properties usersConfig = FileUtil.loadPropertiesFromFile(usersFile);
		if(usersConfig==null) {
			//create new
			usersConfig = new Properties();
		}
		
		usersConfig.put(username, makePasswordHash(password));

		OutputStream output = null;
		try {
			output = new FileOutputStream(usersFile);

			usersConfig.store(output, null);
		} catch (IOException io) {
			logger.log(Level.WARNING, "Error: "+io, io);
			throw io;
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
