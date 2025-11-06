# Use the official Tomcat 9 image as the base
FROM tomcat:9.0-jdk17-temurin

# Maintainer information
LABEL maintainer="albertarko3@gmail.com"
LABEL project="Java Web App CI/CD"

# Remove default ROOT webapp (optional)
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the Jenkins build context to Tomcat's webapps directory
COPY target/web-app.war /usr/local/tomcat/webapps/web-app.war

# Expose Tomcat's default port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

