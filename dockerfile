FROM alpine:latest
LABEL maintainer "sumler.sean@gmail.com"

# ENV myName John Doe

RUN addgroup -S icecast && \
    adduser -S icecast
    
RUN apk update
RUN apk add icecast
RUN apk add vim nano

COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8000 8443
VOLUME ["/var/log/icecast"]
ENTRYPOINT ["/entrypoint.sh"]
CMD icecast -c /etc/icecast.xml