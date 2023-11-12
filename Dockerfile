# Stage 1: Build Stage
FROM maven:3.8.4-openjdk-8-slim AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
ARG PROJECT_VERSION
RUN mvn versions:set -DnewVersion=${PROJECT_VERSION} && mvn clean package

# Stage 2: Run Stage
FROM openjdk:8-jre-alpine

# Create a non-root user
RUN adduser -D myuser

# Set the working directory to /app
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/myapp-${PROJECT_VERSION}.jar /app/myapp.jar

# Give ownership of the /app directory to the non-root user
RUN chown -R myuser /app

# Switch to the non-root user
USER myuser

# Specify the command to run on container start
CMD ["java", "-jar", "myapp.jar"]