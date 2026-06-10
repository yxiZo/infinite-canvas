# Python 应用镜像：支持 docker-compose 本地开发和 Render 等平台部署
# 本地开发时 docker-compose 卷挂载覆盖 /app，git pull 即可更新无需重建
# 生产部署时镜像自带全部代码，无需外部挂载
FROM python:3.11-slim

WORKDIR /app

# 系统依赖：pillow 等可能需要；slim 镜像默认很精简
RUN apt-get update && apt-get install -y --no-install-recommends \
        libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# 先单独拷贝 requirements，利用 Docker 层缓存
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# 拷贝源代码（docker-compose 卷挂载会覆盖此目录，不影响本地开发）
COPY . .

EXPOSE 3000

CMD ["python", "main.py"]
