FROM ghcr.io/umami-software/umami:postgresql-v2.17

ENV TMPDIR=/tmp

USER root
RUN apk update && apk add --no-cache bash openssl ca-certificates postgresql-client libc6-compat

WORKDIR /app

# Set writable directory for Next.js routes manifest
ENV NEXT_TMP_DIR=/tmp/next
RUN mkdir -p $NEXT_TMP_DIR && chmod -R 777 $NEXT_TMP_DIR

# Ensure the /app/.next directory is writable
RUN mkdir -p /app/.next && chmod -R 777 /app/.next

# Run Prisma generate during build
ENV MIGRATION_ENGINE_LOCK_TIMEOUT=60000

# Copy the run.sh script and set permissions
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

EXPOSE 3000

# Run the run.sh script as root
CMD ["/app/run.sh"]
