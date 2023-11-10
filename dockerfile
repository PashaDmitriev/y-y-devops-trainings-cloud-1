# Используйте базовый образ для сборки
FROM golang:1.21 AS builder

# Установите рабочую директорию внутри контейнера
WORKDIR /app

# Копируйте исходный код из директории /test
COPY . .

# Соберите приложение
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o myapp .

# Используйте минимальный образ для запуска
FROM gcr.io/distroless/static-debian12:latest-amd64

# Установите рабочую директорию внутри контейнера
WORKDIR /app

# Скопируйте исполняемый файл из предыдущего образа
COPY --from=builder /app/myapp .

# Укажите порт, который будет использоваться приложением
EXPOSE 8080

# Задайте команду для запуска приложения
CMD ["./myapp"]
