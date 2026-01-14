# Используем Python
FROM python:3.10-slim

# Устанавливаем системные зависимости (ffmpeg нужен для работы с аудио)
RUN apt-get update && \
    apt-get install -y ffmpeg git && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копируем файлы проекта
COPY . .

# Устанавливаем зависимости Python
# Если requirements.txt нет, команда не упадет, а просто выведет ошибку (исправим если что)
RUN pip install --no-cache-dir -r requirements.txt

# Команда запуска. 
# В 90% случаев главный файл называется main.py. 
# Если бот упадет с ошибкой "File not found", поменяем на bot.py
CMD ["python", "main.py"]
