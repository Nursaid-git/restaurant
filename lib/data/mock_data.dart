import '../models/dish.dart';

const List<String> kCategories = ['Все', 'Закуски', 'Горячее', 'Десерт'];

final List<Dish> kDishes = [
  Dish(
    id: 'scallops',
    name: 'Обжаренные гребешки',
    description:
        'Идеально обжаренные морские гребешки с нежной текстурой, '
        'подаются на облаке из воздушной шафрановой пены. Украшены '
        'свежей микрозеленью и дополнены лёгким соусом из белого вина.',
    category: 'Закуски',
    price: 24.00,
    weight: '180г',
    calories: 320,
    rating: 4.8,
    imageUrl:
        'https://images.unsplash.com/photo-1625944230945-1b7dd3b949ab?w=800&q=80',
    customizations: const [
      CustomizationOption(id: 'no_onion', title: 'Без лука'),
      CustomizationOption(
        id: 'extra_sauce',
        title: 'Дополнительный соус',
        subtitle: '+ \$2.00',
        extraPrice: 2.00,
      ),
    ],
  ),
  Dish(
    id: 'risotto',
    name: 'Ризотто с грибами',
    description:
        'Рис арборио, томлённый на белом вине, с ароматными лесными '
        'грибами, пудрой из белых грибов и стружкой чёрного трюфеля. '
        'Кремовая текстура и глубокий грибной вкус.',
    category: 'Горячее',
    price: 28.00,
    weight: '260г',
    calories: 410,
    rating: 4.7,
    imageUrl:
        'https://images.unsplash.com/photo-1633964913295-ceb43956c33b?w=800&q=80',
    customizations: const [
      CustomizationOption(id: 'no_truffle', title: 'Без трюфеля'),
      CustomizationOption(
        id: 'extra_parmesan',
        title: 'Дополнительный пармезан',
        subtitle: '+ \$3.00',
        extraPrice: 3.00,
      ),
    ],
  ),
  Dish(
    id: 'steak',
    name: 'Вырезка Блэк Ангус',
    description:
        'Сочная вырезка говядины Блэк Ангус на выбор прожарки, '
        'подаётся с картофельным пюре, шпинатом и насыщенным соусом '
        'из красного вина.',
    category: 'Горячее',
    price: 45.00,
    weight: '300г',
    calories: 560,
    rating: 4.9,
    imageUrl:
        'https://images.unsplash.com/photo-1600891964599-f61ba0e24092?w=800&q=80',
    customizations: const [
      CustomizationOption(id: 'medium', title: 'Прожарка: Medium'),
      CustomizationOption(
        id: 'extra_sauce_wine',
        title: 'Дополнительный соус',
        subtitle: '+ \$2.50',
        extraPrice: 2.50,
      ),
    ],
  ),
  Dish(
    id: 'lemon_tart',
    name: 'Лимонный торт',
    description:
        'Освежающая меренга, масляный крамбл и нежный лимонный курд '
        'на хрустящей песочной основе. Лёгкий десерт с яркой кислинкой.',
    category: 'Десерт',
    price: 14.00,
    weight: '140г',
    calories: 310,
    rating: 4.6,
    imageUrl:
        'https://images.unsplash.com/photo-1519340333755-56e9c1d04579?w=800&q=80',
    customizations: const [
      CustomizationOption(
        id: 'extra_berries',
        title: 'Добавить ягоды',
        subtitle: '+ \$1.50',
        extraPrice: 1.50,
      ),
    ],
  ),
  Dish(
    id: 'tuna_tartare',
    name: 'Тартар из тунца',
    description:
    'Свежайший тунец, нарезанный кубиками, с авокадо, кунжутным '
        'маслом и лёгкой цитрусовой заправкой. Подаётся с хрустящими '
        'тостами из чиабатты.',
    category: 'Закуски',
    price: 22.00,
    weight: '160г',
    calories: 280,
    rating: 4.7,
    imageUrl:
    'https://images.unsplash.com/photo-1553621042-f6e147245754?w=800&q=80',
    customizations: const [
      CustomizationOption(id: 'no_avocado', title: 'Без авокадо'),
      CustomizationOption(
        id: 'extra_toast',
        title: 'Дополнительные тосты',
        subtitle: '+ \$1.50',
        extraPrice: 1.50,
      ),
    ],
  ),
  Dish(
    id: 'duck_breast',
    name: 'Утиная грудка',
    description:
    'Утиная грудка с хрустящей корочкой, апельсиновым соусом и '
        'карамелизированными овощами. Насыщенный вкус с лёгкой сладостью.',
    category: 'Горячее',
    price: 32.00,
    weight: '280г',
    calories: 470,
    rating: 4.8,
    imageUrl:
    'https://images.unsplash.com/photo-1544025162-d76694265947?w=800&q=80',
    customizations: const [
      CustomizationOption(id: 'no_orange_sauce', title: 'Без апельсинового соуса'),
      CustomizationOption(
        id: 'extra_vegetables',
        title: 'Дополнительные овощи',
        subtitle: '+ \$2.00',
        extraPrice: 2.00,
      ),
    ],
  ),
  Dish(
    id: 'creme_brulee',
    name: 'Крем-брюле',
    description:
    'Классический французский десерт: нежный ванильный крем с '
        'хрустящей карамельной корочкой. Подаётся со свежими ягодами.',
    category: 'Десерт',
    price: 12.00,
    weight: '130г',
    calories: 290,
    rating: 4.9,
    imageUrl:
    'https://images.unsplash.com/photo-1470124182917-cc6e71b22ecc?w=800&q=80',
    customizations: const [
      CustomizationOption(
        id: 'extra_berries_brulee',
        title: 'Добавить ягоды',
        subtitle: '+ \$1.50',
        extraPrice: 1.50,
      ),
    ],
  ),
  Dish(
    id: 'beef_carpaccio',
    name: 'Карпаччо из говядины',
    description:
    'Тонко нарезанная сырая говяжья вырезка с рукколой, каперсами, '
        'пармезаном и заправкой из оливкового масла и лимона.',
    category: 'Закуски',
    price: 19.00,
    weight: '150г',
    calories: 240,
    rating: 4.6,
    imageUrl:
    'https://images.unsplash.com/photo-1626200419199-391ae4be7a41?w=800&q=80',
    customizations: const [
      CustomizationOption(id: 'no_capers', title: 'Без каперсов'),
      CustomizationOption(
        id: 'extra_parmesan_carpaccio',
        title: 'Дополнительный пармезан',
        subtitle: '+ \$2.00',
        extraPrice: 2.00,
      ),
    ],
  ),
];
