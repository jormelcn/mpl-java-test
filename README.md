# mpl-java-test

Este proyecto simula una página web de inicio de sesión

#### Puede ver este proyecto desplegado en un servidor Tomcat en el siguiente link:

[http://35.227.25.188:8080/mpl-java-test/iniciar-sesion.jsp](http://35.227.25.188:8080/mpl-java-test/iniciar-sesion.jsp)

#### Puede acceder al archivo JSON generado en la siguiente direccion:

[http://35.227.25.188:8080/mpl-java-test/datos-json.jsp](http://35.227.25.188:8080/mpl-java-test/datos-json.jsp)

## Abir el proyecto
1. Clone este repositorio
1. Abra el proyecto utilizando un IDE JAVA (Utilice preferiblemente "Eclipse IDE For Enterprice Java Developers")
1. Configure la ruta donde se guardará el archivo JSON generado (Edite el parámetro "json-file-path" en "usr/main/webapp/WEB-INF/web.xml")
1. Instale las dependencia utilizando Maven `mvn clean install -U` (Normalmente eclipse lo hace automaticamente al abrir el proyecto por primera vez)

## Correr el proyecto
* Si abríó el proyecto utilizando eclipse, presione run en el archivo "usr/main/webapp/iniciar-sesion.jsp" y seleccione o configure el servidor tomcat.
* De forma general, puede exportar un archivo .war a partir del proyecto y desplegarlo en un servidor utilizando el Gestor de Aplicaciones Web de Tomcat
 
  




