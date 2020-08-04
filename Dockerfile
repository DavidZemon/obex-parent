FROM node:lts-slim as client-builder

COPY client /opt/client

RUN cd /opt/client && \
  npm install && \
  npm run build

FROM maven:3-openjdk-11 as server-builder

COPY server /opt/server

RUN cd /opt/server && \
  mvn clean package

FROM openjdk:11.0.8-slim

COPY --from=client-builder /opt/client/dist/obex /opt/client
COPY --from=server-builder /opt/server/target/obex-server*.jar /opt/server/app.jar

CMD ["java", "-D spring.resources.static-locations=file:/opt/client", "-jar", "/opt/server/app.jar"]
