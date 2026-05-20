# ================================
# Build image
# ================================
FROM swift:6.2-noble AS build

# Install OS updates and dependencies
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get install -y \
      libssl-dev \
      libsqlite3-dev \
      zlib1g-dev \
      pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set up a build area
WORKDIR /build

# Print environment info for debugging
RUN echo "=== Environment Info ===" && \
    swift --version && \
    uname -a && \
    free -h && \
    df -h

# First just resolve dependencies
COPY ./Package.* ./
RUN swift package resolve \
        $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

# Copy entire repo into container
COPY . .

# Remove Tests directory and testTarget from Package.swift to avoid overlapping sources error
RUN rm -rf Tests/ && \
    sed -i '/\.testTarget(/,/^[[:space:]]*)/d' Package.swift

# Create staging directory
RUN mkdir -p /staging

# Build with detailed error output and limited resources
SHELL ["/bin/bash", "-c"]
RUN set -e && \
    echo "=== Starting Swift build ===" && \
    echo "=== Available memory ===" && \
    free -h && \
    echo "=== Starting build with limited parallelism ===" && \
    swift build -c release \
        --product AppleAcademyChallenge6 \
        -j 1 \
        --disable-sandbox \
        -Xswiftc -diagnostic-style=llvm \
        2>&1 | tee /tmp/build.log && \
    if grep -q "error:" /tmp/build.log; then \
        echo "=== Build failed with errors ===" && \
        exit 1; \
    fi && \
    echo "=== Build completed successfully ==="

# Get the binary path and copy executable
RUN set -e && \
    BIN_PATH=$(swift build -c release --show-bin-path --product AppleAcademyChallenge6) && \
    echo "Binary path from swift: $BIN_PATH" && \
    echo "=== Checking for executable ===" && \
    ls -la "$BIN_PATH/" || true && \
    if [ -f "$BIN_PATH/AppleAcademyChallenge6" ]; then \
        echo "Found executable at: $BIN_PATH/AppleAcademyChallenge6" && \
        cp "$BIN_PATH/AppleAcademyChallenge6" /staging/ && \
        chmod +x /staging/AppleAcademyChallenge6; \
    else \
        echo "ERROR: Executable not found in expected location" && \
        echo "=== Searching entire build directory ===" && \
        find /build/.build -name "AppleAcademyChallenge6" -type f && \
        exit 1; \
    fi

# Copy resources bundled by SPM to staging area
RUN BIN_PATH=$(swift build -c release --show-bin-path) && \
    find -L "$BIN_PATH" -regex '.*\.resources$' -exec cp -Ra {} /staging \; || true

# Switch to the staging area
WORKDIR /staging

# Copy static swift backtracer binary to staging area
RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" ./ || echo "Warning: swift-backtrace-static not found"

# Copy any resources from the public directory and views directory if the directories exist
# Ensure that by default, neither the directory nor any of its contents are writable.
RUN [ -d /build/Public ] && { mv /build/Public ./Public && chmod -R a-w ./Public; } || true
RUN [ -d /build/Resources ] && { mv /build/Resources ./Resources && chmod -R a-w ./Resources; } || true

# Verify the executable exists
RUN ls -la /staging

# ================================
# Run image
# ================================
FROM swift:6.2-noble-slim

# Make sure all system packages are up to date, and install only essential packages.
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -q install -y \
      ca-certificates \
      tzdata \
      libcurl4 \
      libssl3 \
      zlib1g \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a vapor user and group with /app as its home directory
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app vapor

# Switch to the new home directory
WORKDIR /app

# Copy built executable and any staged resources from builder
COPY --from=build --chown=vapor:vapor /staging /app

# Provide configuration needed by the built-in crash reporter and some sensible default behaviors.
ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

# Ensure all further commands run as the vapor user
USER vapor:vapor

# Let Docker bind to port 8080
EXPOSE 8080

# Start the Vapor service when the image is run, default to listening on 8080 in production environment
ENTRYPOINT ["./AppleAcademyChallenge6"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
