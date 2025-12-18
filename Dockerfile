# Étape de construction
FROM maven:3.9-eclipse-temurin-17 AS build

WORKDIR /app

# Copier les fichiers de dépendances
COPY pom.xml .
# Télécharger les dépendances (mis en cache dans le layer Docker)
RUN mvn dependency:go-offline -B

# Copier le code source
COPY src ./src

# Compiler l'application
RUN mvn clean package -DskipTests

# Étape d'exécution
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copier le JAR construit depuis l'étape de build
COPY --from=build /app/target/*.jar app.jar

# Installer wget pour les health checks
RUN apk --no-cache add wget

# Exposer le port 8080 (modifié depuis 8089 pour correspondre à application.properties)
EXPOSE 8080

# Configuration des health checks
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:8080/actuator/health || exit 1

# Commande de démarrage
ENTRYPOINT ["java", "-jar", "app.jar"]

# Métadonnées
LABEL maintainer="sirine.hamzaoui@example.com"
LABEL version="1.0.0"
LABEL description="Application Spring Boot avec monitoring Prometheus et Grafana"
