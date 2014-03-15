package com.quickserverlab.quicklb.servlet;

import com.quickserverlab.quicklb.server.UserValidator;
import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author akshath
 */
public class UserValidatorServlet extends HttpServlet {
	private static final Logger logger = Logger.getLogger(UserValidatorServlet.class.getName());
 
    public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
       res.sendRedirect("/index.jsp");
    }
 
    public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        
		try {
			String action = req.getParameter("action");
			String username = req.getParameter("username");
			String oldpassword = req.getParameter("oldpassword");
			String password = req.getParameter("password");
			
			if("Set Password".equals(action)) {
				UserValidator.setPassword(username, password);
				res.sendRedirect("/index.jsp?msg=New Password saved");
				return;
			} else if("Change Password".equals(action)) {
				try {
					UserValidator.changePassword(username, oldpassword, password);
					res.sendRedirect("/u/interface/index.jsp?msg=Password changed");
					return;
				} catch (IOException ex) {
					logger.log(Level.WARNING, "Error: {0}", ex);
					res.sendRedirect("/u/interface/changePassword.jsp?user="+username+"&error="+ex.getMessage());
					return;
				}
			} else {
				boolean flag = UserValidator.validateLogin(username, password);

				if (flag == false){
					res.sendRedirect("/index.jsp?error=Bad Username or Password!");
				} else{
					HttpSession session = req.getSession();
					session.setAttribute("username", username);

					res.sendRedirect("/u/interface");
				}
			}
			
		} catch (IOException ex) {
			logger.log(Level.WARNING, "Error: {0}", ex);
			res.sendRedirect("/index.jsp?error="+ex.getMessage());
		} catch (NoSuchAlgorithmException ex) {
			logger.log(Level.WARNING, "Error: {0}", ex);
			res.sendRedirect("/index.jsp?error="+ex.getMessage());
		}
    }    
}
