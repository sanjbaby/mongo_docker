FROM debian:jessie-slim
RUN apt-get update && \
apt-get install -y ca-certificates && \
rm -rf /var/lib/apt/lists/*
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0C49F3730359A14518585931BC711F9BA15703C6 && \
gpg --export $GPG_KEYS > /etc/apt/trusted.gpg.d/mongodb.gpg
ARG MONGO_PACKAGE=mongodb-org
ARG MONGO_REPO=repo.mongodb.org
ENV MONGO_PACKAGE=${MONGO_PACKAGE} MONGO_REPO=${MONGO_REPO}
ENV MONGO_MAJOR 3.4
ENV MONGO_VERSION 3.4.18
RUN echo "deb http://$MONGO_REPO/apt/debian jessie/${MONGO_PACKAGE%-unstable}/$MONGO_MAJOR main" | tee "/etc/apt/sources.list.d/${MONGO_PACKAGE%-unstable}.list"
RUN echo "/etc/apt/sources.list.d/${MONGO_PACKAGE%-unstable}.list"
RUN apt-get update
RUN apt-get install -y ${MONGO_PACKAGE}=$MONGO_VERSION
VOLUME ["/data/db"]
WORKDIR /data
EXPOSE 27018
ENV MONGO_INITDB_ROOT_USERNAME admin
ENV MONGO_INITDB_ROOT_PASSWORD password
CMD ["mongod", "--smallfiles"]
