FROM alpine:latest

# Terraform artifact details
ARG tf_version
ARG tf_arch

RUN apk update && \
        apk add \
            bash \
            bind-tools \
            curl \
            jq \
            unzip \
            wget

RUN mkdir -p /terraform_install && \
        cd /terraform_install && \
        wget https://releases.hashicorp.com/terraform/0.13.4/terraform_${tf_version}_linux_${tf_arch}.zip && \
        unzip ./terraform_${tf_version}_linux_${tf_arch}.zip && \
        cp ./terraform /bin/terraform && \
        cd / && \
        rm -rf /terraform_install

# Default qazx command.
ENV QAZX_CMD="update_record"

VOLUME /dns
WORKDIR /dns

ENTRYPOINT /dns/qazx.sh
