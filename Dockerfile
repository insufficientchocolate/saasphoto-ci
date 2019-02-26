FROM amazonlinux:latest

MAINTAINER tony84727@gmail.com

RUN yum install -y awscli
# install c/c++ development environment
RUN yum group install -y 'Development Tools'
# polly dependency
RUN yum install -y python3 which
RUN pip3 install requests

# install go
ENV GO_VERSION 1.12
ENV GO111MODULE on
ADD https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz /tmp/go.tar.gz
RUN tar -xf /tmp/go.tar.gz -C /usr/local
RUN mkdir /go
ENV GOPATH /go

# install polly
ENV POLLY_VERSION 0.10.4
ENV POLLY_CHECKSUM d26d1f89ba2c698fc3acdcd575401e9a69b47303

ADD https://github.com/ruslo/polly/archive/v${POLLY_VERSION}.tar.gz /polly-${POLLY_VERSION}.tar.gz

# checksum test & extract files to polly-v${POLLY_VERSION}
RUN [ "${POLLY_CHECKSUM}  /polly-${POLLY_VERSION}.tar.gz" = "$(sha1sum /polly-${POLLY_VERSION}.tar.gz)" ] && \
tar -xf "/polly-${POLLY_VERSION}.tar.gz" && mv /polly-${POLLY_VERSION} /polly &&  rm -rf "/polly-${POLLY_VERSION}.tar.gz"

# install cmake and remove downloaded archive
RUN /polly/bin/install-ci-dependencies.py && rm -rf /_ci/cmake-*
ENV PATH /_ci/cmake/bin:/polly/bin:/usr/local/go/bin:$GOPATH/bin:$PATH
RUN yum clean all && rm -rf /var/cache/yum
