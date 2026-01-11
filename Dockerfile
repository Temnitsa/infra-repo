FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/my-app-1.0-SNAPSHOT.jar app.jar
# ENTRYPOINT ["java", "-jar", "app.jar"]
ENTRYPOINT ["sh", "-c", "java -jar app.jar && sleep infinity"]
