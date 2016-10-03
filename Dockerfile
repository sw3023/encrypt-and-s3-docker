FROM anigeo/awscli

RUN apk update && apk --update add openssl

COPY docker-entrypoint.sh /docker-entrypoint.sh

VOLUME ['/backup']

ENTRYPOINT '/docker-entrypoint.sh'