FROM maven:3.8.5-openjdk-11-slim AS build

ARG BRANCH=master
WORKDIR /build
RUN apt-get update && apt-get install -y --no-install-recommends git && \
    git clone https://github.com/WaterdogPE/WaterdogPE.git -b ${BRANCH} . && mvn package

FROM openjdk:11.0.14.1-jre-slim-buster

RUN groupadd -g 1000 worker && useradd -u 1000 -g 1000 -d /waterdogpe -m worker && mkdir /data && chown 1000:1000 /waterdogpe /data -R

COPY --from=build /build/target/Waterdog.jar /waterdogpe

EXPOSE 19132/udp
USER worker
WORKDIR /data
CMD [ "java", "-jar", "/waterdogpe/Waterdog.jar" ]
