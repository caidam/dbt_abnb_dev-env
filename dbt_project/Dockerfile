# Use a specific version of the Python image as the base
FROM python:3.10.7-slim-bullseye as base

# System setup
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y --no-install-recommends \
    git \
    ssh-client \
    software-properties-common \
    make \
    build-essential \
    ca-certificates \
    libpq-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Env vars
ENV PYTHONIOENCODING=utf-8
ENV LANG=C.UTF-8

# Update python
RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir

# Install dbt-core
RUN python -m pip install --no-cache-dir dbt-core dbt-duckdb duckdb==0.9.2

# Set docker basics
WORKDIR /usr/app

EXPOSE 8080

# CMD ["python", "app.py"]
# ENTRYPOINT ["dbt"]