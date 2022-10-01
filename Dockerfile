FROM maven:3-openjdk-11-slim AS build

ARG BRANCH=master
RUN apt-get update && apt-get install -y --no-install-recommends git
RUN git clone https://github.com/WaterdogPE/WaterdogPE.git -b ${BRANCH} /build
RUN cd /build && mvn package

FROM openjdk:11-jre-slim-buster

COPY --from=build /build/target/Waterdog.jar /
EXPOSE 19132/udp
CMD [ "java", "-jar", "/Waterdog.jar" ]
