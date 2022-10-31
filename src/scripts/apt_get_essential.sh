#!/bin/bash
apt-get update && apt-get install -y --no-install-recommends \
    libatlas-base-dev=3.10.3-8ubuntu7 \
    libgslcblas0=2.5+dfsg-6build1 \
    pandoc=2.5-3build2 \
    pandoc-citeproc=0.15.0.1-1build4 \
    zlib1g-dev=1:1.2.11.dfsg-2ubuntu1.5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# update-alternatives --install /usr/bin/python python /usr/bin/python3 10
