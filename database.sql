--
-- Database: `hungry_iubian`
--

CREATE TABLE IF NOT EXISTS USERS (
    userId INTEGER PRIMARY KEY AUTO_INCREMENT,
    userName TEXT NOT NULL,
    dateOfBirth DATE,
    accountCreated DATETIME DEFAULT CURRENT_TIMESTAMP,
    password TEXT NOT NULL,
    userType TEXT,
    credit REAL,
    phone TEXT,
    email TEXT,
    passportNo TEXT,
    fatherName TEXT,
    motherName TEXT
);

CREATE TABLE IF NOT EXISTS PAYMENT (
    paymentId INTEGER PRIMARY KEY AUTO_INCREMENT,
    userId INTEGER,
    createdDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    memo TEXT,
    amount REAL,
    paymentMedia TEXT,
    FOREIGN KEY (userId) REFERENCES USERS(userId)
);

CREATE TABLE IF NOT EXISTS DISCOUNT (
    discountId INTEGER PRIMARY KEY AUTO_INCREMENT,
    discountType ENUM ('Flat','Percentage'),
    amount REAL,
    name TEXT,
    code TEXT,
    startDate DATE,
    endDate DATE,
    isActive BOOLEAN,
    quantity INTEGER,
    minimumTotal REAL,
    createdOn DATETIME DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS DISH (
    dishId INTEGER PRIMARY KEY AUTO_INCREMENT,
    createdDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedDate DATETIME,
    name TEXT,
    description TEXT,
    images BLOB,
    urlSlug TEXT,
    price REAL,
    rating REAL,
    tags TEXT,
    quantityLeft INTEGER,
    requestedQuantity INTEGER,
    dishType ENUM ('Breakfast','Lunch', 'Snack','Beverage')
);
CREATE TABLE IF NOT EXISTS ORDERS (
    orderId INTEGER PRIMARY KEY AUTO_INCREMENT,
    userId INTEGER,
    createdDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    deliveryTime DATETIME,
    isPreOrder BOOLEAN,
    isReviewed BOOLEAN,
    isReadyToServe BOOLEAN,
    receivedTime DATETIME,
    tokenId INTEGER,
    isReadyToCollect BOOLEAN,
    total INTEGER,
    FOREIGN KEY (userId) REFERENCES USERS(userId)
);
CREATE TABLE IF NOT EXISTS USER_DISH (
    userDishId INTEGER PRIMARY KEY AUTO_INCREMENT,
    orderId INTEGER,
    dishId INTEGER,
    quantity INTEGER,
    pickUpTime DATETIME,
    discountId INTEGER,
    FOREIGN KEY (orderId) REFERENCES ORDERS(orderId),
    FOREIGN KEY (dishId) REFERENCES DISH(dishId),
    FOREIGN KEY (discountId) REFERENCES DISCOUNT(discountId)
);
CREATE TABLE IF NOT EXISTS REVIEW (
    reviewId INTEGER PRIMARY KEY AUTO_INCREMENT,
    orderId INTEGER,
    dishId INTEGER,
    createdDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    comment TEXT,
    rate INTEGER,
    FOREIGN KEY (orderId) REFERENCES ORDERS(orderId),
    FOREIGN KEY (dishId) REFERENCES DISH(dishId)
);
INSERT IGNORE INTO USERS (userName, dateOfBirth, password, userType, credit, phone, email, passportNo, fatherName, motherName)
VALUES ('adminCu', '1990-01-01', 'adminCu', 'customer', 1000.00, '123456789', 'customer@example.com', 'AB123456', 'John Doe', 'Jane Doe');

INSERT IGNORE INTO USERS (userName, dateOfBirth, password, userType, credit, phone, email, passportNo, fatherName, motherName)
VALUES ('admin', '1985-01-01', 'admin', 'admin', 0.00, '987654321', 'admin@example.com', 'CD789012', 'Admin Father', 'Admin Mother');

INSERT IGNORE INTO DISH ( name,  description,  images,  urlSlug,  price,  rating,  tags,  quantityLeft,  requestedQuantity,  dishType) VALUES
    ('Pancakes', 'Fluffy pancakes with syrup', NULL, 'pancakes', 5.99, 4.5, 'breakfast, sweet', 50, 0, 'Breakfast'),
    ('Spaghetti Bolognese', 'Classic Italian pasta with meat sauce', NULL, 'spaghetti-bolognese', 8.99, 4.8, 'pasta, Italian', 40, 0, 'Lunch'),
    ('Chicken Caesar Salad', 'Fresh salad with grilled chicken', NULL, 'chicken-caesar-salad', 7.99, 4.3, 'salad, chicken', 30, 0, 'Lunch'),
    ('Cheeseburger', 'Juicy beef patty with cheese and vegetables', NULL, 'cheeseburger', 6.99, 4.6, 'burger, American', 60, 0, 'Snack'),
    ('Green Smoothie', 'Healthy smoothie with spinach and fruits', NULL, 'green-smoothie', 4.99, 4.7, 'smoothie, healthy', 20, 0, 'Beverage'),
    ('Margherita Pizza', 'Classic pizza with tomato, mozzarella, and basil', NULL, 'margherita-pizza', 10.99, 4.9, 'pizza, Italian', 25, 0, 'Lunch'),
    ('Caesar Wrap', 'Chicken Caesar salad wrapped in a tortilla', NULL, 'caesar-wrap', 6.49, 4.2, 'wrap, chicken', 35, 0, 'Lunch'),
    ('Fruit Salad', 'Fresh fruit salad with a variety of fruits', NULL, 'fruit-salad', 5.49, 4.6, 'salad, fruit', 15, 0, 'Snack'),
    ('Iced Coffee', 'Chilled coffee served with ice', NULL, 'iced-coffee', 3.99, 4.4, 'coffee, beverage', 40, 0, 'Beverage'),
    ('Caprese Sandwich', 'Sandwich with tomatoes, mozzarella, and basil', NULL, 'caprese-sandwich', 7.29, 4.7, 'sandwich, Italian', 30, 0, 'Lunch'),
    ('Sushi Roll', 'Assorted sushi rolls with fresh fish and rice', NULL, 'sushi-roll', 12.99, 4.8, 'sushi, Japanese', 20, 0, 'Lunch'),
    ('Chicken Quesadilla', 'Grilled chicken and cheese in a tortilla', NULL, 'chicken-quesadilla', 8.49, 4.5, 'quesadilla, chicken', 25, 0, 'Snack'),
    ('Mango Smoothie', 'Refreshing smoothie with mango and yogurt', NULL, 'mango-smoothie', 4.99, 4.6, 'smoothie, fruit', 18, 0, 'Beverage'),
    ('Vegetarian Stir-Fry', 'Assorted vegetables stir-fried in a savory sauce', NULL, 'vegetarian-stir-fry', 9.99, 4.2, 'stir-fry, vegetarian', 28, 0, 'Lunch'),
    ('Cheesecake', 'Classic New York-style cheesecake', NULL, 'cheesecake', 7.99, 4.9, 'dessert, cheesecake', 15, 0, 'Snack'),
    ('Mushroom Risotto', 'Creamy risotto with mushrooms and Parmesan', NULL, 'mushroom-risotto', 11.49, 4.4, 'risotto, Italian', 22, 0, 'Lunch'),
    ('Avocado Toast', 'Sliced avocado on toasted bread', NULL, 'avocado-toast', 5.99, 4.7, 'breakfast, avocado', 33, 0, 'Breakfast'),
    ('Cobb Salad', 'Classic Cobb salad with bacon, eggs, and avocado', NULL, 'cobb-salad', 8.99, 4.5, 'salad, bacon', 27, 0, 'Lunch'),
    ('Chocolate Brownie', 'Rich and gooey chocolate brownie', NULL, 'chocolate-brownie', 3.99, 4.8, 'dessert, chocolate', 20, 0, 'Snack'),
    ('Vegetable Pizza', 'Pizza topped with a variety of fresh vegetables', NULL, 'vegetable-pizza', 10.49, 4.3, 'pizza, vegetarian', 24, 0, 'Lunch');


CREATE VIEW IF NOT EXISTS order_Info AS
SELECT 
o.userId, o.orderId, d.dishId, di.discountId, o.isPreOrder, o.isReviewed, o.isReadyToServe, o.receivedTime, o.tokenId, o.isReadyToCollect, 
o.deliveryTime, o.total, ud.quantity, ud.pickUpTime, d.name dishName, d.description, d.images, d.urlSlug, d.price, d.rating, 
d.tags, d.dishType, u.username, u.userType, u.phone, u.email, di.discountType, di.name discountName, di.amount
FROM
  orders o
LEFT JOIN
  user_dish ud ON o.orderId = ud.orderId
LEFT JOIN
  Dish d ON d.dishId = ud.dishId
LEFT JOIN
	users u ON u.userId = o.userId
LEFT JOIN 
	discount di ON di.discountId = ud.discountId;

INSERT IGNORE INTO DISCOUNT ( discountType, amount, name, code, startDate, endDate, isActive, quantity, minimumTotal) VALUES
  ('Flat', 10.0, 'Flat Discount 1', 'FLAT10', '2023-01-01', '2023-02-01', 1, 100, 50.0),
  ('Percentage', 15.0, 'Percentage Discount 1', 'PERC15', '2023-01-15', '2023-03-01', 1, 50, 100.0),
  ('Flat', 5.0, 'Flat Discount 2', 'FLAT5', '2023-02-01', '2023-02-28', 0, 200, 75.0);
