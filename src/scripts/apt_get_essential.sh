#!/bin/bash
apt-get update && apt-get install -y --no-install-recommends && \
    pandoc=2.5-3build2 \
    pandoc-citeproc=0.15.0.1-1build4 \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# update-alternatives --install /usr/bin/python python /usr/bin/python3 10
