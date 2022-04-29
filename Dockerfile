FROM maven:3.8.5-openjdk-11-slim AS build

ARG BRANCH=master
RUN apt-get update && apt-get install -y --no-install-recommends git
RUN git clone https://github.com/WaterdogPE/WaterdogPE.git -b ${BRANCH} /build
RUN cd /build && mvn package

FROM openjdk:11.0.14.1-jre-slim-buster

RUN groupadd -g 1000 docker && useradd -u 1000 -g 1000 -M docker && mkdir /data && chown 1000:1000 /data -R

COPY --from=build --chown 1000:1000 /build/target/Waterdog.jar /

EXPOSE 19132/udp
USER docker
WORKDIR /data
CMD [ "java", "-jar", "/Waterdog.jar" ]
