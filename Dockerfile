# Start with a Java base image
FROM openjdk:11-jre-slim

# Set working directory inside the container
WORKDIR /app

# Copy the compiled Jar file from the target folder
COPY target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
