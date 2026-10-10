FROM mcr.microsoft.com/devcontainers/base:resolute

# install mise
RUN apt-get update && \
    apt-get install -y extrepo python3 python3-yaml fonts-noto-cjk fonts-ipafont-gothic fonts-ipafont-mincho && \
    extrepo enable mise && \
    apt-get update && \
    apt-get install -y mise
