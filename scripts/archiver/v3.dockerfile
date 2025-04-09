FROM alpine:3.21 AS builder

# get required tools
RUN apk add -y --no-cache git npm
RUN npm install -g astro

RUN astro telemetry disable

# clone src
RUN git clone https://github.com/wmartinmimi/wmartinmimi.github.io --depth 1 --branch v3 /home/src --recursive --shallow-submodules

WORKDIR /home/src

RUN npm install

RUN astro build

# output directory for --output
FROM scratch AS output

COPY --from=builder /home/src/dist /

