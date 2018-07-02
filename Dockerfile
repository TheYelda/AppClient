FROM daocloud.io/library/nginx:1.13.0-alpine
LABEL maintainer="Jarvis-Wong"

COPY dist/ /static/