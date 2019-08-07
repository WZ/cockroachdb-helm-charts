FROM cockroachdb/cockroach:v19.1.0

SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y --no-install-recommends curl python python-pip && \
    curl -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py --user && \
    export PATH=~/.local/bin:$PATH && \
    . ~/.bashrc && \
    pip install awscli --upgrade --user && \
    apt-get remove -y python-pip && \
    apt-get clean

ENV COCKROACH_PORT=26257 \
    AWS_DEFAULT_REGION=us-west-2 \
    S3_PATH=backup \
    BACKUP_FILE_NAME='latest'

ADD restore.sh restore.sh
RUN chmod +x restore.sh

ENTRYPOINT ["/bin/bash", "-c", "/cockroach/restore.sh"]