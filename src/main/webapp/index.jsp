<%@page import="com.baeldung.soap.ws.client.generated.SakaiLogin"%>
<%@page import="com.baeldung.soap.ws.client.generated.SakaiLoginService"%>
<html>
<body>
<h2>Hello World!</h2>
<%
	SakaiLoginService loginService = new SakaiLoginService();
	SakaiLogin login = loginService.getSakaiLoginPort();
	String token = login.login("admin", "admin");
%>
Token: <%=token%>
</body>
</html>
