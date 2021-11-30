# ------------------------------------------------------
# Download Bedrock Server
# ------------------------------------------------------
FROM ubuntu:bionic AS build

RUN apt-get update
RUN apt-get install -y unzip wget

# Download the latest version and unzip it.
RUN wget -U "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)" -O - https://minecraft.net/en-us/download/server/bedrock/ | \
    grep -o 'https://minecraft.azureedge.net/bin-linux/[^"]*' | \
    wget -i - -O bedrock-server.zip

RUN unzip bedrock-server.zip -d bedrock-server

# ------------------------------------------------------
# Run Environment
# ------------------------------------------------------
FROM ubuntu:bionic AS environment

RUN apt-get update
RUN apt-get install -y openssl

RUN useradd -m -d /bedrock bedrock

WORKDIR /bedrock
USER bedrock

COPY --chown=bedrock:bedrock scripts /bedrock/scripts
COPY --chown=bedrock:bedrock --from=build \
    /bedrock-server \
    /bedrock

RUN chmod +x scripts/*

EXPOSE 19132/udp 19133/udp
CMD ["/bedrock/scripts/entrypoint.sh"]