FROM ghcr.io/gitroomhq/postiz-app:v2.11.3

# Install nginx (may already be present, this ensures it)
RUN apt-get update && apt-get install -y --no-install-recommends nginx \
    && rm -rf /var/lib/apt/lists/*

# Create www user/group for nginx (if not exists)
RUN addgroup --system www 2>/dev/null || true \
    && adduser --system --ingroup www --home /www --shell /usr/sbin/nologin www 2>/dev/null || true \
    && mkdir -p /www /var/lib/nginx /var/log/nginx \
    && chown -R www:www /www /var/lib/nginx

# Copy our nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Start nginx then PM2
CMD ["sh", "-c", "nginx && pnpm run pm2"]
