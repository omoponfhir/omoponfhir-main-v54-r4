#Build the Maven project
FROM maven:3.9.6-amazoncorretto-21-al2023 as builder
#FROM maven:3.9.8-sapmachine-21 as builder
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN mvn clean install

#Build the Tomcat container
FROM tomcat:jre21
#set environment variables below and uncomment the line. Or, you can manually set your environment on your server.
#ENV JDBC_URL=jdbc:postgresql://<host>:<port>/<database> JDBC_USERNAME=<username> JDBC_PASSWORD=<password>

# Copies updated server.xml to increase HTTP Header Length allowed
COPY server.xml $CATALINA_HOME/conf/

# Copy GT-FHIR war file to webapps.
COPY --from=builder /usr/src/app/omoponfhir-r4-server/target/omoponfhir-r4-server.war $CATALINA_HOME/webapps/ROOT.war

EXPOSE 8080
