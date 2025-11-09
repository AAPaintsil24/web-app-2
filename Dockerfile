# Use Tomcat base image
FROM tomcat:10.1

# Copy the WAR file built by Maven
COPY target/web-app.war /usr/local/tomcat/webapps/

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat in foreground
CMD ["catalina.sh", "run"]

