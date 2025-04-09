FROM alpine:3.21 AS builder

# get required tools
RUN apk add -y --no-cache git npm just

# clone src
RUN git clone https://github.com/wmartinmimi/wmartinmimi.github.io --depth 1 --branch main /home/src --recursive --shallow-submodules

WORKDIR /home/src

RUN npm install
RUN npx astro telemetry disable

RUN just build

# output directory for --output
FROM scratch AS output

COPY --from=builder /home/src/build /

