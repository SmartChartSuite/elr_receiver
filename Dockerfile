#Build the Maven project
#FROM maven:3.8.5-jdk-11 as builder
FROM maven:3.6.3-openjdk-17 as builder
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN mvn clean install

#Build the Java container
#FROM openjdk:8-alpine
FROM openjdk:17-jdk

# Copy elr_receiver jar file to webapps.
COPY --from=builder /usr/src/app/hl7v2-to-fhir-mllp/config.properties /usr/src/myapp/config.properties
COPY --from=builder /usr/src/app/hl7v2-to-fhir-mllp/target/elr_receiver-*-jar-with-dependencies.jar /usr/src/myapp/elr-receiver.jar
WORKDIR /usr/src/myapp
CMD ["java", "-jar", "elr-receiver.jar"]

EXPOSE 8888
