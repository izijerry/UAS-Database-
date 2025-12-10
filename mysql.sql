CREATE TABLE IF NOT EXISTS users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    no_hp VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    nama_restoran VARCHAR(100) NOT NULL,
    alamat TEXT,
    no_hp VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS restaurant_admins (
    admin_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    nama_admin VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS menus (
    menu_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    nama_menu VARCHAR(100) NOT NULL,
    deskripsi TEXT,
    harga DECIMAL(10,2) NOT NULL,
    gambar_menu VARCHAR(255),
    stock INT DEFAULT 0,               
    available BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    total_harga DECIMAL(10,2) NOT NULL,
    metode_pembayaran ENUM('E-Wallet','Transfer Bank') NOT NULL,
    status_pesanan ENUM(
        'Pembayaran Belum Lunas',
        'Pembayaran Lunas',
        'Pesanan Telah Diambil'
    ) DEFAULT 'Pembayaran Belum Lunas',
    qr_code VARCHAR(255),
    pickup_code VARCHAR(16),
    tanggal_diambil TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    nama_menu VARCHAR(100) NOT NULL, -- denormalisasi untuk kemudahan history
    harga DECIMAL(10,2) NOT NULL,
    jumlah INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menus(menu_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    metode ENUM('E-Wallet','Transfer Bank') NOT NULL,
    jumlah DECIMAL(10,2) NOT NULL,
    status ENUM('Belum Lunas','Lunas') DEFAULT 'Belum Lunas',
    transaksi_id VARCHAR(100),
    bukti_transfer VARCHAR(255),
    tanggal_pembayaran TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;


-- Indeks tambahan untuk performa
CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_restaurant ON orders(restaurant_id);
CREATE INDEX idx_orders_status ON orders(status_pesanan);
CREATE INDEX idx_menus_restaurant ON menus(restaurant_id);
CREATE INDEX idx_payments_order ON payments(order_id);

COMMIT;

-- INSERT DATA: RESTAURANT, RESTAURANT ADMIN, MENUS

INSERT INTO restaurants (nama_restoran, alamat, no_hp, email) VALUES
('Kopi Kenangan', 'Jakarta Selatan', '0811111111', 'kopikenangan@example.com'),
('Janji Jiwa', 'Jakarta Barat', '0822222222', 'janjijiwa@example.com'),
('Pizza Hut', 'Jakarta Timur', '0833333333', 'pizzahut@example.com'),
('Roti O', 'Jakarta Utara', '0844444444', 'rotio@example.com'),
('HokBen', 'Jakarta Pusat', '0855555555', 'hokben@example.com');

INSERT INTO restaurant_admins (restaurant_id, nama_admin, email, password) VALUES
(1, 'Admin Kopi Kenangan', 'admin.kopikenangan@example.com', 'hashed_pass'),
(2, 'Admin Janji Jiwa', 'admin.janjijiwa@example.com', 'hashed_pass'),
(3, 'Admin Pizza Hut', 'admin.pizzahut@example.com', 'hashed_pass'),
(4, 'Admin Roti O', 'admin.rotio@example.com', 'hashed_pass'),
(5, 'Admin HokBen', 'admin.hokben@example.com', 'hashed_pass');

-- KOPI KENANGAN
INSERT INTO menus (restaurant_id, nama_menu, deskripsi, harga, gambar_menu) VALUES
(1, 'Caramel Latte', 'Kopi susu caramel', 35000, 'caramel_latte.jpg'),
(1, 'Americano', 'Kopi hitam', 25000, 'americano.jpg'),
(1, 'Hazelnut Latte', 'Kopi susu hazelnut', 36000, 'hazelnut_latte.jpg'),
(1, 'Cappuccino', 'Espresso dengan foam', 33000, 'cappuccino.jpg'),
(1, 'Es Kopi Kenangan Mantan', 'Menu signature KopKen', 32000, 'kopken_mantan.jpg');

-- JANJI JIWA 
INSERT INTO menus (restaurant_id, nama_menu, deskripsi, harga, gambar_menu) VALUES
(2, 'Es Kopi Susu', 'Kopi susu klasik', 25000, 'es_kopi_susu.jpg'),
(2, 'Brown Sugar Latte', 'Kopi susu gula aren', 28000, 'brown_sugar_latte.jpg'),
(2, 'Matcha Latte', 'Matcha premium', 30000, 'matcha_latte.jpg'),
(2, 'Jiwa Toast Coklat', 'Roti panggang coklat', 20000, 'toast_coklat.jpg'),
(2, 'Jiwa Tea Lemon', 'Teh lemon segar', 18000, 'tea_lemon.jpg');

-- PIZZA HUT
INSERT INTO menus (restaurant_id, nama_menu, deskripsi, harga, gambar_menu) VALUES
(3, 'Pan Pizza Beef', 'Pizza daging sapi', 85000, 'pan_beef.jpg'),
(3, 'Pan Pizza Cheese', 'Pizza keju', 75000, 'pan_cheese.jpg'),
(3, 'Pasta Creamy', 'Pasta saus creamy', 45000, 'pasta_creamy.jpg'),
(3, 'Garlic Bread', 'Roti bawang klasik', 20000, 'garlic_bread.jpg'),
(3, 'WingStreet', 'Sayap ayam pedas', 35000, 'wingstreet.jpg');

-- ROTI O
INSERT INTO menus (restaurant_id, nama_menu, deskripsi, harga, gambar_menu) VALUES
(4, 'RotiO Original', 'Roti kopi klasik', 15000, 'rotio_original.jpg'),
(4, 'Roti Coklat', 'Roti isian coklat', 17000, 'rotio_coklat.jpg'),
(4, 'Roti Keju', 'Roti isian keju', 17000, 'rotio_keju.jpg'),
(4, 'Roti Pandan', 'Roti pandan manis', 16000, 'rotio_pandan.jpg'),
(4, 'Es Kopi Susu', 'Kopi susu roti o', 22000, 'kopi_susu_rotio.jpg');

-- HOKBEN
INSERT INTO menus (restaurant_id, nama_menu, deskripsi, harga, gambar_menu) VALUES
(5, 'Bento Special', 'Bento dengan ayam dan nasi', 55000, 'bento_special.jpg'),
(5, 'Teriyaki Chicken', 'Ayam saus teriyaki', 38000, 'teriyaki_chicken.jpg'),
(5, 'HokBen Ramen', 'Ramen khas HokBen', 42000, 'hokben_ramen.jpg'),
(5, 'Ebi Furai', 'Udang goreng tepung', 30000, 'ebi_furai.jpg'),
(5, 'Es Teh Manis', 'Teh manis dingin', 8000, 'es_teh.jpg');