FROM ghcr.io/umami-software/umami:postgresql-latest

ENV TMPDIR=/tmp

USER root
RUN apk update && apk add --no-cache bash openssl ca-certificates postgresql-client libc6-compat

WORKDIR /app

# Set permissions for the entire /app directory and subdirectories
RUN chmod -R 777 /app

# Set writable directory for Prisma engines
ENV PRISMA_TMP_ENGINE_DIR=/tmp/prisma-engines
RUN mkdir -p $PRISMA_TMP_ENGINE_DIR && chmod -R 777 $PRISMA_TMP_ENGINE_DIR

# Set writable directory for Next.js routes manifest
ENV NEXT_TMP_DIR=/tmp/next
RUN mkdir -p $NEXT_TMP_DIR && chmod -R 777 $NEXT_TMP_DIR

# Specifically ensure Prisma engines directory has correct permissions
RUN mkdir -p /app/node_modules/.pnpm/@prisma+engines@6.7.0/node_modules/@prisma/engines && \
    chmod -R 777 /app/node_modules/.pnpm/@prisma+engines@6.7.0/node_modules/@prisma/engines

# Copy the run.sh script and set permissions
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

EXPOSE 3000

# Run the run.sh script as root
CMD ["/app/run.sh"]