import '../models/product_model.dart';

final List<Product> sampleProducts = [
  Product(
    id: 1,
    name: 'AirPods Pro Max',
    brand: 'Apple',
    description:
        'Premium over-ear headphones with industry-leading Active Noise Cancellation, '
        'Transparency mode, Spatial Audio, and up to 20 hours of battery life. '
        'Crafted with a breathable knit mesh canopy and memory foam ear cushions '
        'for all-day comfort.',
    price: 549.00,
    originalPrice: 649.00,
    rating: 4.8,
    reviewCount: 2341,
    category: 'Audio',
    emoji: '🎧',
    tags: ['Wireless', 'Noise Cancelling', 'Premium'],
    colors: ['#1C1C1E', '#E5E5EA', '#98989D'],
    isFavorite: false,
  ),
  Product(
    id: 2,
    name: 'Galaxy Watch Ultra',
    brand: 'Samsung',
    description:
        'Advanced smartwatch with health monitoring, GPS tracking, titanium build, '
        'and a 60-hour battery life. Features sleep tracking, ECG monitoring, '
        'and is water resistant up to 100 meters.',
    price: 449.99,
    originalPrice: 499.99,
    rating: 4.6,
    reviewCount: 1856,
    category: 'Wearables',
    emoji: '⌚',
    tags: ['Smart', 'Health', 'Titanium'],
    colors: ['#1A1A2E', '#C0C0C0', '#FFD700'],
    isFavorite: true,
  ),
  Product(
    id: 3,
    name: 'MacBook Pro 16"',
    brand: 'Apple',
    description:
        'Supercharged by the M3 Max chip with an incredible 40-core GPU. '
        'Features a stunning Liquid Retina XDR display, up to 128GB unified memory, '
        'and up to 22 hours of battery life — the most powerful Mac ever.',
    price: 2499.00,
    originalPrice: 2799.00,
    rating: 4.9,
    reviewCount: 4521,
    category: 'Laptops',
    emoji: '💻',
    tags: ['M3 Max', 'Pro Display', 'Long Battery'],
    colors: ['#1C1C1E', '#E5E5EA'],
    isFavorite: false,
  ),
  Product(
    id: 4,
    name: 'Sony WH-1000XM5',
    brand: 'Sony',
    description:
        'Industry-leading noise canceling with two processors and eight microphones. '
        'Exceptional sound quality with HD Noise Canceling Processor QN2. '
        'Up to 30 hours battery and quick charge.',
    price: 279.99,
    originalPrice: 349.99,
    rating: 4.7,
    reviewCount: 3102,
    category: 'Audio',
    emoji: '🎵',
    tags: ['Noise Cancel', '30hr Battery', 'Hi-Res'],
    colors: ['#000000', '#F5F5F5'],
    isFavorite: false,
  ),
  Product(
    id: 5,
    name: 'iPad Pro 13"',
    brand: 'Apple',
    description:
        'The ultimate iPad experience with M4 chip, Ultra Retina XDR display with '
        'nano-texture glass, and Apple Pencil Pro support. Thin as ever at just 5.1mm '
        'with all-day battery life.',
    price: 1299.00,
    originalPrice: 1299.00,
    rating: 4.8,
    reviewCount: 2089,
    category: 'Tablets',
    emoji: '📱',
    tags: ['M4 Chip', 'OLED', 'Apple Pencil'],
    colors: ['#1C1C1E', '#E5E5EA'],
    isFavorite: true,
  ),
  Product(
    id: 6,
    name: 'RTX 5090 GPU',
    brand: 'NVIDIA',
    description:
        'Next-generation graphics with DLSS 4 and ray tracing. '
        '32GB GDDR7 memory for extreme gaming and AI workloads. '
        'Experience 8K gaming and real-time ray tracing at unprecedented performance.',
    price: 1999.00,
    originalPrice: 2399.00,
    rating: 4.9,
    reviewCount: 892,
    category: 'PC Components',
    emoji: '🖥️',
    tags: ['8K Gaming', 'DLSS 4', 'Ray Tracing'],
    colors: ['#1A1A2E', '#76B900'],
    isFavorite: false,
  ),
  Product(
    id: 7,
    name: 'DJI Drone Mini 4 Pro',
    brand: 'DJI',
    description:
        'Intelligent, compact, and lightweight drone with 4K/60fps video, '
        '20km transmission range, and 34-minute flight time. '
        'Omnidirectional obstacle sensing keeps your shots smooth and safe.',
    price: 759.00,
    originalPrice: 899.00,
    rating: 4.7,
    reviewCount: 1423,
    category: 'Drones',
    emoji: '🚁',
    tags: ['4K/60fps', '34min Flight', 'Foldable'],
    colors: ['#D3D3D3', '#2C2C2C'],
    isFavorite: false,
  ),
  Product(
    id: 8,
    name: 'PS5 Pro Controller',
    brand: 'Sony',
    description:
        'DualSense Edge wireless controller with haptic feedback, adaptive triggers, '
        'and fully customizable controls. Features back buttons and replaceable stick '
        'modules for competitive gaming.',
    price: 149.99,
    originalPrice: 149.99,
    rating: 4.6,
    reviewCount: 5674,
    category: 'Gaming',
    emoji: '🎮',
    tags: ['Haptic', 'Adaptive', 'Customizable'],
    colors: ['#F5F5F5', '#1C1C1E'],
    isFavorite: true,
  ),
];

final List<String> productCategories = [
  'All',
  'Audio',
  'Wearables',
  'Laptops',
  'Tablets',
  'PC Components',
  'Drones',
  'Gaming',
];
