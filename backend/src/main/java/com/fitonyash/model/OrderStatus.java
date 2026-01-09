package com.fitonyash.model;

public enum OrderStatus {
    PENDING,        // Ожидает подтверждения
    CONFIRMED,      // Подтвержден
    PREPARING,      // Готовится
    READY,          // Готов к доставке
    DELIVERING,     // Доставляется
    DELIVERED,      // Доставлен
    CANCELLED       // Отменен
}

