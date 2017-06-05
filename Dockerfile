FROM golang:1.8

# Install glide
RUN go get github.com/Masterminds/glide

# Install tools
RUN apt-get update \
    && apt-get install -y \
        python-pip \
        python-virtualenv \
    && apt-get clean

ENV ACTIVEMQBEAT_PATH "$GOPATH/src/github.com/codingame/activemqbeat"

COPY . $ACTIVEMQBEAT_PATH

WORKDIR $ACTIVEMQBEAT_PATH

# Install dependencies
RUN glide install

# Create activemqbeat binary
RUN make update && make

RUN mkdir -p /etc/activemqbeat/ \
    && cp $ACTIVEMQBEAT_PATH/activemqbeat.yml /etc/activemqbeat/activemqbeat.yml \
    && cp $ACTIVEMQBEAT_PATH/activemqbeat /usr/local/bin/activemqbeat

ENTRYPOINT [ "activemqbeat" ]

CMD [ "-c", "/etc/activemqbeat/activemqbeat.yml", "-e" ]
