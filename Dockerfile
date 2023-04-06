FROM debian:latest

WORKDIR /root/

# Any custom installation can be
# set from setup.sh. This file is
# not intended for edit.
COPY setup.sh

RUN chmod +x setup.sh

RUN ./setup.sh
