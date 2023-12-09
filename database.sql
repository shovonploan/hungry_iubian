CREATE TABLE IF NOT EXISTS USER (
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
    FOREIGN KEY (userId) REFERENCES USER(userId)
);
CREATE TABLE IF NOT EXISTS DISCOUNT_TYPE (
    discountTypeId INTEGER PRIMARY KEY AUTO_INCREMENT,
    name TEXT NOT NULL
);
CREATE TABLE IF NOT EXISTS DISCOUNT (
    discountId INTEGER PRIMARY KEY AUTO_INCREMENT,
    discountTypeId INTEGER,
    amount REAL,
    name TEXT,
    code TEXT,
    startDate DATE,
    endDate DATE,
    isActive BOOLEAN,
    quantity INTEGER,
    minimumTotal REAL,
    createdOn DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (discountTypeId) REFERENCES DISCOUNT_TYPE(discountTypeId)
);
CREATE TABLE IF NOT EXISTS DISH (
    dishId INTEGER PRIMARY KEY AUTO_INCREMENT,
    createdDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    updatedDate DATETIME,
    name TEXT,
    description TEXT,
    images TEXT,
    urlSlug TEXT,
    price REAL,
    rating REAL,
    tags TEXT,
    quantityLeft INTEGER,
    requestedQuantity INTEGER,
    dishTypeId INTEGER
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
    FOREIGN KEY (userId) REFERENCES USER(userId)
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
-- Insert a random customer user if not exists
INSERT IGNORE INTO USER (userName, dateOfBirth, password, userType, credit, phone, email, passportNo, fatherName, motherName)
VALUES ('adminCu', '1990-01-01', 'adminCu', 'customer', 1000.00, '123456789', 'customer@example.com', 'AB123456', 'John Doe', 'Jane Doe');

-- Insert a random admin user if not exists
INSERT IGNORE INTO USER (userName, dateOfBirth, password, userType, credit, phone, email, passportNo, fatherName, motherName)
VALUES ('admin', '1985-01-01', 'admin', 'admin', 0.00, '987654321', 'admin@example.com', 'CD789012', 'Admin Father', 'Admin Mother');

-- Insert 10 random dishes if they do not exist
INSERT IGNORE INTO DISH (name, description, price, quantityLeft)
VALUES 
  ('Dish1', 'Description for Dish1', 9.99, 50),
  ('Dish2', 'Description for Dish2', 12.99, 30),
  ('Dish3', 'Description for Dish3', 8.99, 40),
  ('Dish4', 'Description for Dish4', 14.99, 25),
  ('Dish5', 'Description for Dish5', 10.99, 35),
  ('Dish6', 'Description for Dish6', 11.99, 20),
  ('Dish7', 'Description for Dish7', 13.99, 45),
  ('Dish8', 'Description for Dish8', 7.99, 55),
  ('Dish9', 'Description for Dish9', 15.99, 15),
  ('Dish10', 'Description for Dish10', 9.49, 60);

CREATE VIEW IF NOT EXISTS order_Info AS
SELECT
  o.userId,
  o.orderId,
  d.dishId,
  o.isPreOrder,
  o.isReviewed,
  o.isReadyToServe,
  o.receivedTime,
  o.tokenId,
  o.isReadyToCollect,
  ud.quantity,
  ud.pickUpTime,
  ud.discountId,
  d.name,
  d.description,
  d.images,
  d.urlSlug,
  d.price,
  d.rating,
  d.tags,
  d.dishTypeId
FROM
  orders o
JOIN
  user_dish ud ON o.orderId = ud.orderId
JOIN
  Dish d ON d.dishId = ud.dishId;

