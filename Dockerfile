# Use official Tomcat image
FROM tomcat:9.0

# Copy WAR built by Jenkins/Maven and serve at root
COPY target/web-app.war /usr/local/tomcat/webapps/ROOT.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat in foreground
CMD ["catalina.sh", "run"]

