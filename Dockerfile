FROM golang:1.10

USER 0

# make image
WORKDIR /go/src/github.com/firmom/tojestmysl.pl
COPY . .
RUN rm -rf config/*
RUN rm -rf data/*
RUN rm main.db ||:
RUN chmod +x /go/src/github.com/firmom/tojestmysl.pl/docker/secrets.sh
RUN sh ./docker/secrets.sh

RUN go get -u github.com/goatcms/goatcli
RUN goatcli build

RUN go build -o bphome ./main.go
RUN chmod +x docker/entrypoint.sh
RUN mv /go/src/github.com/firmom/tojestmysl.pl /app

WORKDIR /app
RUN rm -rf .goat && \
  rm -rf bphapp && \
  rm -rf slotsapp && \
  rm -rf vendor && \
  rm -rf modules && \
  rm -rf /app/data

RUN ln -s /data /app/data

ENTRYPOINT ["/app/docker/entrypoint.sh"]
CMD []
