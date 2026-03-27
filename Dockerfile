FROM ghcr.io/gitroomhq/postiz-app:v2.11.3

# Install nginx -- try apt-get (Debian) first, fall back to apk (Alpine)
RUN if command -v apt-get >/dev/null 2>&1; then \
      apt-get update && apt-get install -y --no-install-recommends nginx && rm -rf /var/lib/apt/lists/*; \
    elif command -v apk >/dev/null 2>&1; then \
      apk add --no-cache nginx; \
    fi

# Create www user/group for nginx (if not exists)
RUN addgroup www 2>/dev/null || addgroup --system www 2>/dev/null || true
RUN adduser -S -G www -h /www -s /sbin/nologin www 2>/dev/null || \
    adduser --system --ingroup www --home /www --shell /usr/sbin/nologin www 2>/dev/null || true
RUN mkdir -p /www /var/lib/nginx /var/log/nginx /run/nginx \
    && chown -R www:www /www /var/lib/nginx /var/log/nginx /run/nginx 2>/dev/null || true

# Copy our nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Start nginx then PM2
CMD ["sh", "-c", "nginx && pnpm run pm2"]
