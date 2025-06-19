FROM ghcr.io/umami-software/umami:postgresql-latest

USER root
RUN apk update && apk add --no-cache bash openssl ca-certificates postgresql-client libc6-compat

WORKDIR /app

# Ensure Prisma engines directory has correct permissions
RUN mkdir -p /app/node_modules/.pnpm/@prisma+engines@6.7.0/node_modules/@prisma/engines && \
    chmod -R 777 /app/node_modules/.pnpm/@prisma+engines@6.7.0/node_modules/@prisma/engines

# Copy the run.sh script and set permissions
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

EXPOSE 3000

# Run the run.sh script as root
CMD ["/app/run.sh"]