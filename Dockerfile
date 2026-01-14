# Используем Python
FROM python:3.10-slim

WORKDIR /app

# Копируем файлы проекта (они появятся после git clone)
COPY . .

# Устанавливаем зависимости
# В репозитории MT есть requirements.txt? 
# Если нет, ставим вручную то, что обычно нужно ботам
RUN pip install --no-cache-dir pyTelegramBotAPI python-dotenv requests

# Запускаем бота. 
# В репозитории главный файл называется bot.py или main.py?
# Обычно это bot.py
CMD ["python", "bot.py"]
