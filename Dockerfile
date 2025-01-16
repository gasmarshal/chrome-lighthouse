# Use an official Node.js image as the base
FROM node:23

# Install required packages and Google Chrome
RUN apt-get update && apt-get install -y \
    dbus \
    libnss3 \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libxrandr2 \
    libasound2 \
    libpangocairo-1.0-0 \
    libatk1.0-0 \
    libcups2 \
    libxss1 \
    libxshmfence1 \
    fonts-liberation \
    wget \
    x11-xserver-utils \
    dbus-x11 \
    libgtk-3-0 \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Add the Google Chrome repository and install Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update && apt-get install -y \
    google-chrome-stable \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Install Lighthouse (chrome-launcher) globally
RUN npm install -g lighthouse

# Set up a working directory
WORKDIR /usr/src/app

# Copy your application files (if any) into the container
COPY . .

# Add a script to run Lighthouse and copy the report to the shared directory
RUN echo '#!/bin/bash\n\
    lighthouse $1 --chrome-flags="--no-sandbox --disable-dev-shm-usage" --output html --output-path /usr/src/app/audit-report.html\n\
    cp /usr/src/app/audit-report.html /shared/audit-report.html' > /usr/src/app/run-lighthouse.sh && \
    chmod +x /usr/src/app/run-lighthouse.sh

# Expose a port (if necessary for your application)
EXPOSE 8080

# Default command to run the script
CMD ["/usr/src/app/run-lighthouse.sh"]
