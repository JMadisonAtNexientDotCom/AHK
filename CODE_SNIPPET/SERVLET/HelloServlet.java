package com.myPak.hello;
import javax.servlet.*;
import java.io.*;
import javax.servlet.http.HttpServletResponse; //-----tomcat/lib/servlet-api.jar
import javax.servlet.http.HttpServlet; //-------------tomcat/lib/servlet-api.jar
import javax.servlet.http.HttpServletRequest; //------tomcat/lib/servlet-api.jar
/**
 * Cool news! The 3 javax.servlet imports were done with my auto-hotkey script!
 * AKA: My autohotkey stuff is paying off. As I did this in Netbeans.
 * I can make IDE agnostic imports. Very cool.
 *
 * SUMMARY:
 * Super Basic HelloServlet example that doesn't use anything fancy. 
 * We want to get something like this working before we try to do hibernate
 * SOURCE: http://www.wellho.net/resources/ex.php4?item=j906/HelloServlet.java
 * 
 * @author jmadison **/
public class HelloServlet extends HttpServlet {

public void doGet(HttpServletRequest incoming,
	HttpServletResponse outgoing)
	throws ServletException, IOException {

	outgoing.setContentType("text/html");

	PrintWriter out = outgoing.getWriter();
	out.println("<html><head><title>Hello!</title></head>");
	out.println("<body bgcolor=\"white\"><h1>Hello Servlet World</h1>");
	out.println("</body></html>");
	out.close();
	}
}