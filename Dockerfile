# 只装依赖，不打包代码；代码通过 docker-compose 的卷挂载进来。
# Install dependencies only; the app code is bind-mounted via docker-compose,
# so `git pull` on the host updates the app without rebuilding the image.
FROM python:3.11-slim

WORKDIR /app

# 系统依赖：pillow 等可能需要；slim 镜像默认很精简
RUN apt-get update && apt-get install -y --no-install-recommends \
        libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 先单独拷贝 requirements，利用 Docker 层缓存
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 3000

# 代码由卷挂载提供（见 docker-compose.yml）
CMD ["python", "main.py"]
