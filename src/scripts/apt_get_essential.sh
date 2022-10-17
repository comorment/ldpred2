#!/bin/bash
apt-get update && apt-get install -y --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# update-alternatives --install /usr/bin/python python /usr/bin/python3 10
