<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.io.File" %>
<%@page import="java.io.FileWriter" %>
<%@page import="java.util.Scanner" %>
<%@page import="java.io.FileNotFoundException" %>

<%
// get json-file-path
	ServletContext context = pageContext.getServletContext();
	String jsonFilePath = context.getInitParameter("json-file-path");
%>

<%
	String json="";
	try {
	    File jsonFile = new File(jsonFilePath);
	    Scanner myReader = new Scanner(jsonFile);
	    while (myReader.hasNextLine()) {
	    	json = json + myReader.nextLine();
	    }
	    myReader.close();
	    json = json.trim();
  } catch (FileNotFoundException e) {
    json = "[]";
  }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Datos JSON</title>
</head>
<body>
<%=json%>
</body>
</html>
