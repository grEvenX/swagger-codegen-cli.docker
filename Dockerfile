FROM jimschubert/8-jdk-alpine-mvn:latest

MAINTAINER Jim Schubert <james.schubert@gmail.com>

RUN set -x \
    && mkdir -p /swagger-api/out \
    && apk add --no-cache bash \
    && apk add --no-cache --virtual .temporary wget \
    && wget -qO- https://github.com/swagger-api/swagger-codegen/archive/v2.2.3.tar.gz | tar zxv -C /swagger-api \
    && mv /swagger-api/swagger-codegen-2.2.3* /swagger-api/swagger-codegen/ \
    && ln -s /swagger-api/swagger-codegen/modules/swagger-codegen/src/test/resources/2_0/ /swagger-api/yaml \
    && apk del .temporary

VOLUME /swagger-api/out

COPY docker-entrypoint.sh /

RUN cd /swagger-api/swagger-codegen && \
    mvn -am -pl "modules/swagger-codegen-cli" package -Dmaven.test.skip=true -DskipTests && \
    rm -rf ${MAVEN_HOME}/.m2/repository

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["help"]
