# Use Maven with JDK 17 pre-installed
FROM maven:3.9.3-openjdk-17

# Set working directory inside the container
WORKDIR /usr/src/my-web-app-2

# Copy the project files into the container
COPY . .

# Build the project using Maven
RUN mvn clean package

# Run the app using Cargo plugin and Tomcat profile
CMD ["mvn", "cargo:run", "-P", "tomcat90"]
