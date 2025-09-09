ARG MLFLOW_VERSION=3.1.4
FROM bitnami/mlflow:${MLFLOW_VERSION}

# Switch to root user to install packages
USER root

# Copy only necessary files to minimize attack surface
COPY plugin/ /app/plugin/
COPY setup.py requirements.txt README.md LICENSE /app/
WORKDIR /app

# Install dependencies with security improvements
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir . && \
    pip install --no-cache-dir artifactory && \
    rm -rf /root/.cache/pip

# Create non-root user if not exists and set permissions
RUN groupadd -r mlflow || true && \
    chown -R 1001:1001 /app

# Switch back to the non-root user
USER 1001

