FROM rocker/verse

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends locales && \
    sed -i 's/# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen && \
    rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        man-db manpages manpages-dev less groff-base coreutils && \
    rm -rf /var/lib/apt/lists/*

RUN if command -v unminimize >/dev/null 2>&1; then yes | unminimize; fi

RUN mandb -cq || true
