FROM python:3.9-slim

WORKDIR /app

# Install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY Monthly_Cost_Usage.py .

# Create directory for AWS credentials
RUN mkdir -p /root/.aws

# Create entrypoint script
RUN echo '#!/bin/bash\n\
# Check if AWS credentials are provided as environment variables\n\
if [ -n "$AWS_ACCESS_KEY_ID" ] && [ -n "$AWS_SECRET_ACCESS_KEY" ]; then\n\
  mkdir -p /root/.aws\n\
  echo "[default]" > /root/.aws/credentials\n\
  echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> /root/.aws/credentials\n\
  echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> /root/.aws/credentials\n\
  if [ -n "$AWS_SESSION_TOKEN" ]; then\n\
    echo "aws_session_token = $AWS_SESSION_TOKEN" >> /root/.aws/credentials\n\
  fi\n\
  if [ -n "$AWS_REGION" ]; then\n\
    echo "[default]" > /root/.aws/config\n\
    echo "region = $AWS_REGION" >> /root/.aws/config\n\
  fi\n\
fi\n\
\n\
# Execute the script with any provided arguments\n\
python monthly_aws_cost_reporter.py "$@"\n\
\n\
# Change ownership of output files to the host user if HOST_UID is provided\n\
if [ -n "$HOST_UID" ] && [ -n "$HOST_GID" ]; then\n\
  chown $HOST_UID:$HOST_GID *.xlsx 2>/dev/null || true\n\
fi\n' > /app/entrypoint.sh

RUN chmod +x /app/entrypoint.sh

# Create a volume to store the output
VOLUME ["/app/output"]

ENTRYPOINT ["/app/entrypoint.sh"]
