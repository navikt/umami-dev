FROM ghcr.io/umami-software/umami:postgresql-latest

ENV TMPDIR=/tmp

USER root
RUN apk update && apk add --no-cache bash openssl ca-certificates postgresql-client libc6-compat

WORKDIR /app

# Set writable directory for Prisma engines
ENV PRISMA_TMP_ENGINE_DIR=/tmp/prisma-engines
RUN mkdir -p $PRISMA_TMP_ENGINE_DIR && chmod -R 777 $PRISMA_TMP_ENGINE_DIR

# Set writable directory for Next.js routes manifest
ENV NEXT_TMP_DIR=/tmp/next
RUN mkdir -p $NEXT_TMP_DIR && chmod -R 777 $NEXT_TMP_DIR

# Ensure the /app/.next directory is writable
RUN mkdir -p /app/.next && chmod -R 777 /app/.next

# Copy the run.sh script and set permissions
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

EXPOSE 3000

# Run the run.sh script as root
CMD ["/app/run.sh"]