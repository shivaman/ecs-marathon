FROM mesosphere/marathon:v0.15.3

ENV ECS_SCHEDULER_DRIVER_JAR="https://s3-ap-southeast-2.amazonaws.com/shiva-publicdocs/amazon-ecs-scheduler-driver-1.0.jar"

ADD $ECS_SCHEDULER_DRIVER_JAR .

COPY logback_debug.xml .

ENV JAVA_OPTS="-javaagent:/marathon/amazon-ecs-scheduler-driver-1.0.jar -Dlogback.configurationFile=/marathon/logback_debug.xml"

COPY entrypoint.sh ./bin

EXPOSE 8080

ENTRYPOINT ["./bin/entrypoint.sh"]
