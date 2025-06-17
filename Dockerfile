FROM ghcr.io/umami-software/umami:postgresql-latest

ENV TMPDIR=/tmp

USER root
RUN apk update && apk add --no-cache bash openssl ca-certificates postgresql-client libc6-compat

WORKDIR /app

# Set writable directory for Prisma engines
ENV PRISMA_TMP_ENGINE_DIR=/tmp/prisma-engines
RUN mkdir -p $PRISMA_TMP_ENGINE_DIR && chmod -R 777 $PRISMA_TMP_ENGINE_DIR

# Run Prisma generate during build
ENV PRISMA_ENGINE_CACHE=$PRISMA_TMP_ENGINE_DIR
RUN npx prisma generate

# Copy the run.sh script and set permissions
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

EXPOSE 3000

# Run the run.sh script as root
CMD ["/app/run.sh"]
