# FitoNyash Backend API 🥗

REST API для мобильного приложения доставки ПП еды FitoNyash, разработанный на Spring Boot.

## 🛠 Технологии

- **Java 17**
- **Spring Boot 3.2**
- **Spring Security + JWT**
- **Spring Data JPA**
- **PostgreSQL 16**
- **Docker & Docker Compose**
- **Swagger/OpenAPI 3.0**
- **Lombok**
- **Maven**

## 📋 Требования

- Docker & Docker Compose
- Или: JDK 17+, Maven 3.8+, PostgreSQL 16

## 🚀 Быстрый старт с Docker

### 1. Клонируйте репозиторий и перейдите в папку backend

```bash
cd backend
```

### 2. Создайте файл .env (опционально)

```bash
cp .env.example .env
# Отредактируйте .env при необходимости
```

### 3. Запустите приложение

```bash
docker-compose up -d
```

Приложение будет доступно по адресу: http://localhost:8080

### 4. Откройте Swagger UI

http://localhost:8080/swagger-ui.html

## 🔧 Локальный запуск без Docker

### 1. Настройте PostgreSQL

Создайте базу данных:
```sql
CREATE DATABASE fitonyash;
CREATE USER fitonyash WITH PASSWORD 'fitonyash123';
GRANT ALL PRIVILEGES ON DATABASE fitonyash TO fitonyash;
```

### 2. Соберите и запустите проект

```bash
mvn clean install
mvn spring-boot:run
```

## 📚 API Endpoints

### Аутентификация `/api/auth`
| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | `/register` | Регистрация |
| POST | `/login` | Вход |
| POST | `/refresh` | Обновление токена |
| POST | `/logout` | Выход |

### Категории `/api/categories`
| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/` | Все категории |
| GET | `/{id}` | Категория по ID |
| POST | `/` | Создать (ADMIN) |
| PUT | `/{id}` | Обновить (ADMIN) |
| DELETE | `/{id}` | Удалить (ADMIN) |

### Блюда `/api/food`
| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/` | Все блюда |
| GET | `/paginated` | С пагинацией |
| GET | `/{id}` | Блюдо по ID |
| GET | `/category/{id}` | По категории |
| GET | `/menu/{type}` | По типу меню |
| GET | `/popular` | Популярные |
| GET | `/new` | Новинки |
| GET | `/search?query=` | Поиск |
| POST | `/` | Создать (ADMIN) |
| PUT | `/{id}` | Обновить (ADMIN) |
| DELETE | `/{id}` | Удалить (ADMIN) |

### Корзина `/api/cart` (требуется авторизация)
| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/` | Получить корзину |
| POST | `/add/{foodItemId}` | Добавить товар |
| PUT | `/update/{foodItemId}` | Обновить количество |
| DELETE | `/remove/{foodItemId}` | Удалить товар |
| DELETE | `/clear` | Очистить корзину |

### Избранное `/api/favorites` (требуется авторизация)
| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/` | Список избранного |
| POST | `/{foodItemId}` | Добавить |
| DELETE | `/{foodItemId}` | Удалить |
| POST | `/toggle/{foodItemId}` | Переключить |
| GET | `/check/{foodItemId}` | Проверить |

### Заказы `/api/orders` (требуется авторизация)
| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | `/` | Создать заказ |
| GET | `/` | История заказов |
| GET | `/{id}` | Заказ по ID |
| GET | `/number/{orderNumber}` | По номеру |
| POST | `/{id}/cancel` | Отменить |
| GET | `/admin/active` | Активные (ADMIN) |
| PUT | `/admin/{id}/status` | Статус (ADMIN) |

### Профиль `/api/user` (требуется авторизация)
| Метод | Endpoint | Описание |
|-------|----------|----------|
| GET | `/profile` | Получить профиль |
| PUT | `/profile` | Обновить профиль |
| POST | `/change-password` | Сменить пароль |

## 🔐 Аутентификация

API использует JWT токены. Для доступа к защищенным endpoints добавьте заголовок:

```
Authorization: Bearer <access_token>
```

### Пример регистрации

```bash
curl -X POST http://localhost:8080/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "fullName": "Иван Иванов"
  }'
```

### Пример входа

```bash
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

## 👤 Тестовые аккаунты

При первом запуске создаётся администратор:
- **Email:** admin@fitonyash.ru
- **Пароль:** admin123

## 📁 Структура проекта

```
backend/
├── src/main/java/com/fitonyash/
│   ├── config/          # Конфигурация (Security, OpenAPI)
│   ├── controller/      # REST контроллеры
│   ├── dto/             # Data Transfer Objects
│   ├── exception/       # Обработка ошибок
│   ├── model/           # JPA Entity
│   ├── repository/      # JPA репозитории
│   ├── security/        # JWT, фильтры
│   └── service/         # Бизнес-логика
├── src/main/resources/
│   └── application.yml  # Конфигурация приложения
├── init-scripts/        # SQL скрипты инициализации
├── Dockerfile
├── docker-compose.yml
└── pom.xml
```

## 🐳 Docker команды

```bash
# Запуск
docker-compose up -d

# Остановка
docker-compose down

# Просмотр логов
docker-compose logs -f app

# Пересборка
docker-compose up -d --build

# Полная очистка (включая БД)
docker-compose down -v
```

## 🔧 Переменные окружения

| Переменная | Описание | По умолчанию |
|------------|----------|--------------|
| DB_HOST | Хост PostgreSQL | localhost |
| DB_PORT | Порт PostgreSQL | 5432 |
| DB_NAME | Имя базы данных | fitonyash |
| DB_USERNAME | Пользователь БД | fitonyash |
| DB_PASSWORD | Пароль БД | fitonyash123 |
| JWT_SECRET | Секрет для JWT (base64) | (встроенный) |
| JWT_ACCESS_EXPIRATION | Время жизни access токена (мс) | 900000 (15 мин) |
| JWT_REFRESH_EXPIRATION | Время жизни refresh токена (мс) | 604800000 (7 дней) |
| SERVER_PORT | Порт сервера | 8080 |

## 📄 Лицензия

MIT License - см. [LICENSE](../LICENSE)

## 👨‍💻 Автор

Никита Кочанов (tg: @rickinicki)

