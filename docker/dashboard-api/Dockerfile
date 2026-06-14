FROM golang:1.25-alpine AS build
WORKDIR /src
COPY go.mod ./
COPY main.go ./
RUN go build -o /out/knowns-dashboard .

FROM alpine:3.20
WORKDIR /app
COPY --from=build /out/knowns-dashboard /app/knowns-dashboard
EXPOSE 3737
CMD ["/app/knowns-dashboard"]
