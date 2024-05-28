# First stage: Build the application
FROM maven:3.8.1-openjdk-11 AS build
WORKDIR /build

# Copy the pom.xml and the source code
COPY pom.xml .
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Second stage: Create the runtime image
FROM adoptopenjdk/openjdk11
WORKDIR /usr/src/app
EXPOSE 8080

# Copy the built JAR from the first stage
COPY --from=build /build/target/*.jar app.jar

# Run the application
CMD ["java", "-jar", "app.jar"]
