#!/bin/bash

# Replace the default HTTP port in the Apache configuration
if [[ -n "$PORT" ]]; then
    sed -i -e "s|Listen 80|Listen $PORT|g" /etc/httpd/conf/httpd.conf
    echo "Apache configuration updated to listen on port $PORT."
else
    echo "PORT environment variable is not set. Using the default configuration."
fi

# Start supervisord to manage services
echo "Starting supervisord..."
exec /usr/bin/supervisord -c /etc/supervisord.conf
