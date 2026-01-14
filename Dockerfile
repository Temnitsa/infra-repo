FROM python:3.10-slim

# Ставим системные пакеты (ffmpeg нужен для музыки)
RUN apt-get update && \
    apt-get install -y ffmpeg git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY . .

# ВМЕСТО requirements.txt ставим библиотеки вручную
RUN pip install --no-cache-dir pyTelegramBotAPI python-dotenv requests

# Запускаем
CMD ["python", "main.py"]
