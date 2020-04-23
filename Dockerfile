FROM oracle/graalvm-ce:19.3.1-java8

EXPOSE 8080
EXPOSE 5005

RUN useradd -ms /bin/bash kogito

RUN gu install native-image

USER kogito

COPY kogito-dev-base /home/kogito

RUN cd /home/kogito && ./mvnw package quarkus:build

WORKDIR /home/kogito

ENTRYPOINT [ "./mvnw" ]

CMD [ "compile", "quarkus:dev" ]