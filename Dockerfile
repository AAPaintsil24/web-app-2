FROM openjdk:17.0.2
COPY . /usr/src/my-web-app-2
WORKDIR /usr/src/my-web-app-2
RUN ./mvnw clean package
CMD ./mvnw cargo:run -P tomcat90

