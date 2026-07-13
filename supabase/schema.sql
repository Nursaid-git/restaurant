-- ==========================================
-- 1. ТАБЛИЦЫ ДЛЯ МЕНЮ
-- ==========================================

-- Таблица заведений
CREATE TABLE IF NOT EXISTS restaurants (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    type TEXT NOT NULL, -- 'restaurant', 'cafe', 'fastfood'
    image_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица блюд
CREATE TABLE IF NOT EXISTS dishes (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    description TEXT,
    category TEXT,
    price DECIMAL(10, 2) NOT NULL,
    image_url TEXT,
    weight TEXT,
    calories INTEGER,
    rating DECIMAL(3, 1),
    prep_minutes INTEGER,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица опций кастомизации
CREATE TABLE IF NOT EXISTS dish_customizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    dish_id UUID REFERENCES dishes(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    extra_price DECIMAL(10, 2) DEFAULT 0.0
);

-- ==========================================
-- 2. ТАБЛИЦЫ ДЛЯ ЗАКАЗОВ
-- ==========================================

-- Таблица заказов
CREATE TABLE IF NOT EXISTS orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    restaurant_id UUID REFERENCES restaurants(id),
    table_name TEXT NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    comment TEXT,
    status TEXT DEFAULT 'новый', -- 'новый', 'готовится', 'завершен'
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Таблица позиций в заказе
CREATE TABLE IF NOT EXISTS order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    dish_id UUID REFERENCES dishes(id),
    dish_name TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    price_at_order DECIMAL(10, 2) NOT NULL,
    options TEXT -- Список выбранных опций строкой
);
