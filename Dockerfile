ARG JAVA_VER

FROM maven:3-openjdk-${JAVA_VER}-slim AS build

ARG BRANCH=master
RUN apt-get update && apt-get install -y --no-install-recommends git
RUN git clone https://github.com/WaterdogPE/WaterdogPE.git -b ${BRANCH} /build
RUN cd /build && mvn package

FROM amazoncorretto:${JAVA_VER}

COPY --from=build /build/target/Waterdog.jar /
EXPOSE 19132/udp
CMD [ "java", "-jar", "/Waterdog.jar" ]
