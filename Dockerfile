# Самый легкий Python (Alpine)
FROM python:3.10-alpine

WORKDIR /app

# Копируем всё
COPY . .

# Ставим библиотеки.
# ffmpeg в Alpine ставится одной командой и весит меньше
RUN apk add --no-cache ffmpeg git && \
    pip install --no-cache-dir pyTelegramBotAPI python-dotenv requests

CMD ["python", "main.py"]

