FROM alpine:3.21 AS builder

# get required tools
RUN apk add -y --no-cache git

# clone src
RUN git clone https://github.com/wmartinmimi/wmartinmimi.github.io --depth 1 --branch v1 /home/src --recursive --shallow-submodules

WORKDIR /home/src

# clean up
RUN rm -rf `find . -name '.git'`;
RUN find . -name '.gitmodules' -exec rm -rf {} \;

# output directory for --output
FROM scratch AS output

COPY --from=builder /home/src /

