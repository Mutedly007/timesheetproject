# Use a modern, supported Java 11 image
FROM eclipse-temurin:11-jre

# Set working directory
WORKDIR /app

# Copy the compiled Jar file
COPY target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
