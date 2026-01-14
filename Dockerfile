FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Копируем любой jar файл из папки target
COPY target/*.jar app.jar

# PetClinic работает на порту 8080
EXPOSE 8080

# Запускаем
ENTRYPOINT ["java", "-jar", "app.jar"]
