# FitoNyash 🥗

Мобильное приложение для доставки правильного питания, разработанное на Swift с использованием архитектуры MVP и паттерна Coordinator.

## 📱 Описание

FitoNyash — это iOS-приложение, которое позволяет пользователям заказывать здоровую пищу с доставкой. Приложение предоставляет удобный интерфейс для просмотра меню, добавления блюд в корзину, управления избранными товарами и оформления заказов.

## 📸 Демонстрация

### 🎥 Демо-видео
<p align="center">
  <img src="Resources/workGIF.gif" alt="Демонстрация" width="300"/>
</p>

### 📱 Скриншоты

#### Загрузочный экран
<p align="center">
  <img src="Resources/launch.png" alt="LaunchScreen" width="200"/>
</p>

#### Онбординг
<p align="center">
  <img src="Resources/onboardnig1.png" width="200"/>
  <img src="Resources/onboarding2.png" width="200"/>
  <img src="Resources/onboarding3.png" width="200"/>
  <img src="Resources/onboarding4.png" width="200"/>
</p>

#### Аутентификация
<p align="center">
  <img src="Resources/auth.png" width="200"/>
  <img src="Resources/signIn1.png" width="200"/>
  <img src="Resources/signIn2.png" width="200"/>
  <img src="Resources/register1.png" width="200"/>
  <img src="Resources/register2.png" width="200"/>
</p>

#### Главный экран
<p align="center">
  <img src="Resources/home1.png" width="200"/>
  <img src="Resources/home2.png" width="200"/>
</p>

#### Корзина
<p align="center">
  <img src="Resources/cartEmpty.png" width="200"/>
  <img src="Resources/cartNotEmpty.png" width="200"/>
  <img src="Resources/correct.png" width="200"/>
  <img src="Resources/cancel.png" width="200"/>
</p>

#### Избранное
<p align="center">
  <img src="Resources/favorite.png" width="200"/>
</p>

#### Профиль
<p align="center">
  <img src="Resources/profile.png" width="200"/>
</p>

---

## 🛠 Технологии и архитектура

### Язык программирования и фреймворки
- Swift 5.0
- UIKit
- Foundation

### Архитектурные паттерны
- MVP (Model-View-Presenter)
  - Разделение бизнес-логики и представления
  - Четкая структура презентеров для каждого экрана
  - Протоколы для взаимодействия между слоями

### Паттерны проектирования
- Coordinator Pattern
  - Управление навигацией
  - Изоляция логики переходов
  - Иерархия координаторов
- Factory Pattern (SceneFactory)
  - Создание экранов и их компонентов
  - Инкапсуляция логики инициализации
- Singleton Pattern (UserStorage)
  - Централизованное хранение данных
  - Управление состоянием приложения
- Observer Pattern (NotificationCenter)
  - Коммуникация между компонентами
  - Реактивное обновление UI

### Хранение данных
- UserDefaults
  - Локальное хранение пользовательских данных
  - Кэширование настроек
  - Сохранение состояния приложения

### UI/UX компоненты
- Auto Layout
  - Программная верстка интерфейса
  - Адаптивный дизайн
- Collection Views
  - Гибкая настройка отображения данных
  - Кастомные ячейки
- Table Views
  - Отображение списков
  - Динамическое обновление данных

### Тестирование
- XCTest Framework
  - Модульные тесты
  - Тестирование UI компонентов
  - Моки и стабы для изоляции тестов

### Дополнительные технологии
- Кастомные шрифты (Roboto)
- Анимации и переходы

---

## 🎯 Основные функции

- 🔐 Авторизация и регистрация пользователей
- 🏠 Главный экран с категориями и популярными блюдами
- ❤️ Добавление товаров в избранное
- 🛒 Корзина с возможностью изменения количества товаров
- 👤 Профиль пользователя
- 📱 Онбординг для новых пользователей

## 🚀 Установка

1. Клонируйте репозиторий:
```bash
git clone https://github.com/yourusername/FitoNyash.git
```

2. Откройте проект в Xcode:
```bash
cd FitoNyash
open FitoNyash.xcodeproj
```

## 📱 Требования

- iOS 13.0+
- Xcode 12.0+
- Swift 5.0+

## 🎨 UI/UX Особенности

- Современный минималистичный дизайн
- Адаптивный интерфейс
- Анимации для улучшения пользовательского опыта
- Поддержка темной темы
- Кастомные шрифты (Roboto)

## 🧪 Тестирование

Проект включает модульные тесты для основных компонентов:
- Тесты контроллеров
- Тесты презентеров
- Тесты моделей

## 👨‍💻 Автор

Никита Кочанов (tg: @rickinicki)

## 📝 Лицензия
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
