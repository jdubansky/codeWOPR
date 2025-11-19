FROM python:3.11-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    POETRY_VIRTUALENVS_CREATE=false

WORKDIR /app

RUN apt-get update && \
    apt-get install -y --no-install-recommends git build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY pyproject.toml README.md ./
COPY manager ./manager
COPY scanner ./scanner

RUN pip install --upgrade pip && pip install .

# Default runtime env vars (can be overridden)
ENV HOST=0.0.0.0 \
    PORT=3000 \
    DATABASE_URL=sqlite:////data/sassycode.db \
    DATA_DIR=/data

RUN mkdir -p /data
VOLUME ["/data"]

EXPOSE 3000

CMD ["sassycode-manager", "--host", "0.0.0.0"]

