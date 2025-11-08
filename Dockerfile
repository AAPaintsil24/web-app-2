FROM maven:3.9.0-eclipse-temurin-17

# Set working directory inside the container
WORKDIR /usr/src/my-web-app-2

# Copy the project files into the container
COPY . .

# Build the project using Maven
RUN mvn clean package

# Run the app using Cargo plugin and Tomcat profile
CMD ["mvn", "cargo:run", "-P", "tomcat90"]
