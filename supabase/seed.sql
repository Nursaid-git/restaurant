-- ==========================================
-- 1. ДОБАВЛЕНИЕ РЕСТОРАНОВ
-- ==========================================

INSERT INTO restaurants (name, type) VALUES 
('L''Art Culinaire', 'restaurant'),
('Urban Brew', 'cafe'),
('Quick Bites', 'fastfood');

-- ==========================================
-- 2. ДОБАВЛЕНИЕ БЛЮД И ОПЦИЙ
-- ==========================================

DO $$ 
DECLARE 
    res_id UUID;
    d_id UUID;
BEGIN
    -- РЕСТОРАН: L'Art Culinaire
    res_id := (SELECT id FROM restaurants WHERE name = 'L''Art Culinaire' LIMIT 1);
    
    INSERT INTO dishes (restaurant_id, name, description, category, price, image_url, weight, calories, rating, prep_minutes)
    VALUES (res_id, 'Обжаренные гребешки', 'Морские гребешки с шафрановой пеной.', 'Закуски', 24.00, 'https://images.unsplash.com/photo-1625944230945-1b7dd3b949ab', '180г', 320, 4.8, 15)
    RETURNING id INTO d_id;
    INSERT INTO dish_customizations (dish_id, title, extra_price) VALUES (d_id, 'Без лука', 0.00), (d_id, 'Доп. соус', 2.00);

    INSERT INTO dishes (restaurant_id, name, description, category, price, image_url, weight, calories, rating, prep_minutes)
    VALUES (res_id, 'Ризотто с грибами', 'Рис арборио с лесными грибами и трюфелем.', 'Горячее', 28.00, 'https://images.unsplash.com/photo-1633964913295-ceb43956c33b', '260г', 410, 4.7, 20)
    RETURNING id INTO d_id;

    -- КОФЕЙНЯ: Urban Brew
    res_id := (SELECT id FROM restaurants WHERE name = 'Urban Brew' LIMIT 1);
    
    INSERT INTO dishes (restaurant_id, name, description, category, price, image_url, weight, calories, rating, prep_minutes)
    VALUES (res_id, 'Капучино Классик', 'Кремовая пенка и два шота эспрессо.', 'Напитки', 4.50, 'https://images.unsplash.com/photo-1534778101976-62847782c213', '300мл', 120, 4.9, 5)
    RETURNING id INTO d_id;
    INSERT INTO dish_customizations (dish_id, title, extra_price) VALUES (d_id, 'Миндальное молоко', 1.00);

    -- ФАСТФУД: Quick Bites
    res_id := (SELECT id FROM restaurants WHERE name = 'Quick Bites' LIMIT 1);
    
    INSERT INTO dishes (restaurant_id, name, description, category, price, image_url, weight, calories, rating, prep_minutes)
    VALUES (res_id, 'Дабл Чизбургер', 'Две котлеты, много сыра и соус.', 'Бургеры', 8.90, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd', '350г', 850, 4.6, 10)
    RETURNING id INTO d_id;
END $$;
