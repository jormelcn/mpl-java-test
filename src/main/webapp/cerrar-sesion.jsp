<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.baeldung.soap.ws.client.generated.SakaiLogin"%>
<%@page import="com.baeldung.soap.ws.client.generated.SakaiLoginService"%>
<%@page import="com.sun.xml.ws.fault.ServerSOAPFaultException"%>
<%@page import="java.net.URLDecoder" %>

<%
final String SESSION_COOKIE_NAME = "session_cookie";
final String SUCCESS_LOGOUT_STATUS = "succes_logout";
final String ERROR_LOGOUT_STATUS = "error_logout";
final String NOT_SESSION_STATUS = "not_session";

Cookie cookie = null;
Cookie session_cookie = null;
Cookie[] cookies = null;
String status = NOT_SESSION_STATUS;

cookies = request.getCookies();
if(cookies != null ){
   for (int i = 0; i < cookies.length; i++){
      cookie = cookies[i];
      if (cookie.getName().equals(SESSION_COOKIE_NAME)){
    	  String id_session = URLDecoder.decode(cookie.getValue(), "utf-8"); 
    	  //Load login service
    	  SakaiLoginService loginService = new SakaiLoginService();
    	  SakaiLogin login = loginService.getSakaiLoginPort();
    	  try{
    	  	// Call logout service
    	  	login.logout(id_session);
    	  	status = SUCCESS_LOGOUT_STATUS;
    	  }catch(ServerSOAPFaultException e){
    	  	status = ERROR_LOGOUT_STATUS;
    	  }	
    	  cookie.setMaxAge(0);  
    	  response.addCookie(cookie);
      }
   }
}
%>

<%
	String message = null;
	if(status == NOT_SESSION_STATUS){
		message = "No existe una sesión activa";
	}
	else if(status == ERROR_LOGOUT_STATUS){
		message = "Error al intentar cerrar sesión, se cerró localmente";
	}
	else if(status == SUCCESS_LOGOUT_STATUS){
		message = "Sesión cerrada con éxito!";
	}
%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="generic-head.jsp"/>
<title>Cerrar Sesión</title>
</head>
<body>
<div class="main-container">
	<div class="logout-form-container">
		<div class="form-title"><%=message%></div>
		<a href="iniciar-sesion.jsp"><Button class="login-button">Iniciar sesión</Button> </a>
	</div>
</div>
</body>
</html>