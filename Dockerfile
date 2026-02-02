FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Node.js 22 and git
RUN apt-get update && \
    apt-get install -y curl git ca-certificates && \
    curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install OpenClaw globally
RUN npm install -g openclaw@latest

# Expose ports
EXPOSE 18789 18791

# Set environment variables
ENV NODE_ENV=production

# Start OpenClaw gateway with allow-unconfigured for initial setup
CMD ["openclaw", "gateway", "--port", "18789", "--allow-unconfigured", "--verbose"]
