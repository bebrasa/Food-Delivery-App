# Сетевой слой FitoNyash iOS

## 📁 Структура

```
Network/
├── APIConfig.swift         # Конфигурация API и endpoints
├── APIModels.swift         # DTO модели для API
├── NetworkManager.swift    # HTTP клиент
├── TokenStorage.swift      # Хранение токенов в Keychain
├── AuthService.swift       # Сервис аутентификации
├── FoodService.swift       # Сервис для работы с меню
├── CartService.swift       # Сервис корзины
├── FavoriteService.swift   # Сервис избранного
├── OrderService.swift      # Сервис заказов
└── UserProfileService.swift # Сервис профиля
```

## 🚀 Настройка

### 1. Изменение URL сервера

В файле `APIConfig.swift`:

```swift
#if DEBUG
static let baseURL = "http://localhost:8080/api"  // Для разработки
#else
static let baseURL = "https://api.fitonyash.ru/api"  // Для продакшена
#endif
```

### 2. Для работы с localhost

В `Info.plist` уже добавлены настройки App Transport Security для localhost.

## 📱 Использование

### Аутентификация

```swift
// Вход
Task {
    do {
        let response = try await AuthService.shared.login(
            email: "user@example.com",
            password: "password123"
        )
        print("Logged in as: \(response.user.email)")
    } catch {
        print("Login error: \(error)")
    }
}

// Регистрация
Task {
    do {
        let response = try await AuthService.shared.register(
            email: "newuser@example.com",
            password: "password123",
            fullName: "Иван Иванов",
            phoneNumber: "+79001234567"
        )
    } catch {
        print("Register error: \(error)")
    }
}

// Выход
Task {
    try await AuthService.shared.logout()
}

// Проверка авторизации
if AuthService.shared.isLoggedIn {
    // Пользователь авторизован
}
```

### Работа с меню

```swift
// Получить все категории
let categories = try await FoodService.shared.getAllCategories()

// Получить все блюда
let items = try await FoodService.shared.getAllFoodItems()

// Получить блюда по категории
let categoryItems = try await FoodService.shared.getFoodItemsByCategory(1)

// Получить популярные блюда
let popular = try await FoodService.shared.getPopularItems()

// Поиск
let searchResults = try await FoodService.shared.searchItems(query: "салат")
```

### Корзина

```swift
// Получить корзину
let cart = try await CartService.shared.getCart()

// Добавить товар
let updatedCart = try await CartService.shared.addToCart(foodItemId: 1, quantity: 2)

// Обновить количество
let cart = try await CartService.shared.updateQuantity(foodItemId: 1, quantity: 3)

// Удалить товар
let cart = try await CartService.shared.removeFromCart(foodItemId: 1)

// Очистить корзину
try await CartService.shared.clearCart()
```

### Избранное

```swift
// Получить избранное
let favorites = try await FavoriteService.shared.getFavorites()

// Переключить статус
let item = try await FavoriteService.shared.toggleFavorite(foodItemId: 1)

// Проверить
let isFav = try await FavoriteService.shared.isFavorite(foodItemId: 1)
```

### Заказы

```swift
// Создать заказ
let order = try await OrderService.shared.createOrder(
    deliveryAddress: "ул. Пушкина, д. 1",
    deliveryNotes: "Позвонить за 5 минут",
    phoneNumber: "+79001234567",
    paymentMethod: .cash
)

// Получить историю заказов
let orders = try await OrderService.shared.getOrders()

// Отменить заказ
let cancelled = try await OrderService.shared.cancelOrder(id: 1)
```

## 🔔 Уведомления

Сервисы отправляют уведомления при изменении данных:

```swift
// Подписка на изменения
NotificationCenter.default.addObserver(
    self,
    selector: #selector(cartDidChange),
    name: .cartDidChange,
    object: nil
)

// Доступные уведомления:
Notification.Name.userDidLogin       // Пользователь вошел
Notification.Name.userDidLogout      // Пользователь вышел
Notification.Name.cartDidChange      // Изменилась корзина
Notification.Name.favoritesDidChange // Изменилось избранное
Notification.Name.orderCreated       // Создан заказ
Notification.Name.orderCancelled     // Отменен заказ
Notification.Name.profileDidUpdate   // Обновлен профиль
```

## ⚠️ Обработка ошибок

```swift
do {
    let result = try await someService.someMethod()
} catch NetworkError.unauthorized {
    // Требуется авторизация
} catch NetworkError.serverError(let code, let message) {
    // Ошибка сервера
    print("Server error \(code): \(message ?? "")")
} catch NetworkError.networkError(let error) {
    // Нет сети
    print("Network error: \(error)")
} catch {
    // Другая ошибка
    print("Error: \(error)")
}
```

## 🔐 Хранение токенов

Токены хранятся в Keychain через `TokenStorage`:
- Access Token - короткоживущий (15 минут)
- Refresh Token - долгоживущий (7 дней)

При истечении Access Token автоматически происходит его обновление через Refresh Token.

