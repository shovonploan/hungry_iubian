const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');
const cors = require('cors');

const corsOptions = {
  origin: 'http://192.168.10.242:8080',
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  credentials: true,
  optionsSuccessStatus: 200,
};


const app = express();
const port = 3000;

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));
app.use(cors(corsOptions));

const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'hungry_iubian',
};

const connection = mysql.createConnection(dbConfig);

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to MySQL:', err);
  } else {
    console.log('Connected to MySQL');
  }
});

app.post('/login', (req, res) => {
  const { userName, password } = req.body;
  if (userName && password) {
    const query = 'SELECT * FROM USERS WHERE userName = ? AND password = ?';
    connection.query(query, [userName, password], (err, results) => {
      if (err) {
        console.error('MySQL error:', err);
        res.status(500).send('Internal Server Error');
      } else if (results.length > 0) {
        res.send(results);
      } else {
        res.status(200).send([]);
      }
    });
  } else {
    res.status(400).send('Invalid request. Please provide both username and password.');
  }
});

app.post('/createUser', (req, res) => {
  const { userName, dateOfBirth, password, userType, credit, phone, email, passportNo, fatherName, motherName } = req.body;
  const query = `INSERT INTO USERS (userName, dateOfBirth, accountCreated, password, userType, credit, phone, email, passportNo, fatherName, motherName) VALUES (?, ?, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?, ?, ?, ?)`;
  const values = [userName, dateOfBirth, password, userType, credit, phone, email, passportNo, fatherName, motherName,];
  connection.query(query, values, (err, results) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.status(201).send('User created successfully');
    }
  });
});

app.delete('/deleteUser', (req, res) => {
  const { userId } = req.query;

  const updateQuery = 'DELETE FROM USERS WHERE userId = ?';
  connection.query(updateQuery, [userId], (err, _) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.status(200).send('Credit updated successfully');
    }
  });
});

app.delete('/deleteDiscount', (req, res) => {
  const discountId = req.query;

  const deleteQuery = 'DELETE FROM discount WHERE discountId = ?';

  connection.query(deleteQuery, [discountId], (err, _) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      console.log('Discount deleted successfully');
      res.status(200).send('Discount deleted successfully');
    }
  });
});

app.get('/users', (req, res) => {
  const query = 'SELECT * FROM USERS ORDER BY userId';
  connection.query(query, (err, results) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.status(200).json(results || []);
    }
  });
});


app.get('/discounts', (req, res) => {
  const query = 'SELECT * FROM discount';
  connection.query(query, (err, results) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.status(200).json(results || []);
    }
  });
});

app.get('/user', (req, res) => {
  const { id } = req.body;

  if (id) {
    const query = 'SELECT * FROM USERS WHERE userId = ? ';
    connection.query(query, [id], (err, results) => {
      if (err) {
        console.error('MySQL error:', err);
        res.status(500).send('Internal Server Error');
      } else if (results.length > 0) {
        res.send(results);
      } else {
        res.status(200).send([]);
      }
    });
  } else {
    res.status(400).send('Invalid request. Please provide both username and password.');
  }
});


app.get('/getDiscount', (req, res) => {
  const { code } = req.body;

  const query = 'SELECT * FROM DISCOUNT WHERE code = ? AND isActive = 1';
  connection.query(query, [code], (err, results) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else if (results.length > 0) {
      res.send(results);
    } else {
      res.status(200).send([]);
    }
  });
});

app.put('/credit', (req, res) => {
  const { id, amount } = req.query;
  const updateQuery = 'UPDATE USERS SET credit = ? WHERE userId = ?';
  connection.query(updateQuery, [amount, id], (err, _) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.status(200).send('Credit updated successfully');
    }
  });
});

app.get('/dishes', (req, res) => {
  const query = 'SELECT * FROM dish ORDER BY dishType';
  connection.query(query, (err, results) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.send(results);
    }
  });
});

app.get('/userDishes', (req, res) => {
  const query = 'SELECT * FROM dish WHERE quantityLeft > 0 ORDER BY dishType';
  connection.query(query, (err, results) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.send(results);
    }
  });
});

app.put('/updateDishV1', (req, res) => {
  const { request, quantity, price, dishId } = req.query;
  const updateQuery = 'UPDATE dish SET quantityLeft = ?, price = ?, requestedQuantity = ? WHERE dishId = ?';
  connection.query(updateQuery, [quantity, price, request, dishId], (err, _) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.status(200).send('Dish updated successfully');
    }
  });
});

app.put('/updateDiscount', (req, res) => {
  const { discountId, discountType, amount, name, code, startDate, endDate, isActive, quantity, minimumTotal } = req.query;

  const updateQuery =
    'UPDATE discount SET discountType = ?, amount = ?, name = ?, code = ?, startDate = ?, endDate = ?, isActive = ?, quantity = ?, minimumTotal = ? WHERE discountId = ?';

  connection.query(updateQuery, [discountType, amount, name, code, startDate, endDate, isActive, quantity, minimumTotal, discountId], (err, _) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      console.log("Discount updated successfully");
      res.status(200).send('Discount updated successfully');
    }
  }
  );
});

app.post('/createDiscount', (req, res) => {
  const { discountType, amount, name, code, startDate, endDate, isActive, quantity, minimumTotal } = req.body;

  const insertQuery =
    'INSERT INTO discount (discountType, amount, name, code, startDate, endDate, isActive, quantity, minimumTotal) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)';

  connection.query(insertQuery, [discountType, amount, name, code, startDate, endDate, isActive, quantity, minimumTotal], (err, _) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      console.log('Discount created successfully');
      res.status(200).send('Discount created successfully');
    }
  }
  );
});



app.post('/updateDishV2', (req, res) => {
  const { name, description, dishType, images, dishId } = req.body;
  const updateQuery = 'UPDATE dish SET name = ?, description = ?, dishType = ?,images = ?  WHERE dishId = ?';
  const imageBuffer = Buffer.from(images, 'base64');
  connection.query(updateQuery, [name, description, dishType, imageBuffer, dishId], (err, _) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.status(200).send('Dish updated successfully');
    }
  });
});

app.get('/customerOrderInfo', (req, res) => {
  const { userId } = req.query;
  const query = 'SELECT * FROM order_info WHERE userId = ?';
  connection.query(query, [userId], (err, results) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.send(results);
    }
  });
});

app.get('/orderInfos', (req, res) => {
  const query = 'SELECT * FROM order_info';
  connection.query(query, (err, results) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.send(results);
    }
  });
});

app.post('/createOrder', (req, res) => {
  const { userId, isPreOrder, dishQuantities, deliveryTime, total } = req.body;
  connection.beginTransaction((err) => {
    if (err) {
      console.error('MySQL error:', err);
      return res.status(500).send('Internal Server Error');
    }
    const insertOrderQuery = 'INSERT INTO ORDERS (userId, isPreOrder, deliveryTime, total) VALUES (?, ?, ?, ?)';
    connection.query(insertOrderQuery, [userId, isPreOrder, deliveryTime, total], (err, result) => {
      if (err) {
        console.error('MySQL error:', err);
        return connection.rollback(() => res.status(500).send('Internal Server Error'));
      }
      const orderId = result.insertId;
      const insertUserDishQuery = 'INSERT INTO USER_DISH (orderId, dishId, quantity) VALUES (?, ?, ?)';
      const updateDishQuantityQuery = 'UPDATE DISH SET quantityLeft = quantityLeft - ? WHERE dishId = ?';
      for (const dishQuantity of dishQuantities) {
        const { dishId, quantity } = dishQuantity;
        connection.query(insertUserDishQuery, [orderId, dishId, quantity], (err) => {
          if (err) {
            console.error('MySQL error:', err);
            return connection.rollback(() => res.status(500).send('Internal Server Error'));
          }
        });
        connection.query(updateDishQuantityQuery, [quantity, dishId], (err) => {
          if (err) {
            console.error('MySQL error:', err);
            return connection.rollback(() => res.status(500).send('Internal Server Error'));
          }
        });
      }
      connection.commit((err) => {
        if (err) {
          console.error('MySQL error:', err);
          return connection.rollback(() => res.status(500).send('Internal Server Error'));
        }
        res.status(201).send('Order created successfully');
      });
    });
  });
});


app.put('/userEdit', (req, res) => {
  const { userId, userName, email, phone, passportNo, fatherName, motherName, dateOfBirth, } = req.query;
  const updateQuery =
    'UPDATE USERS SET userName=?, email=?, phone=?, passportNo=?, fatherName=?, motherName=?, dateOfBirth=? WHERE userId=?';
  const updateValues = [userName, email, phone, passportNo, fatherName, motherName, dateOfBirth, userId,];
  connection.query(updateQuery, updateValues, (updateErr, _) => {
    if (updateErr) {
      console.error('MySQL error during update:', updateErr);
      res.status(500).send('Internal Server Error');
    }
    else {
      const query = 'SELECT * FROM USERS WHERE userId = ? ';
      connection.query(query, [userId], (err, results) => {
        if (err) {
          console.error('MySQL error:', err);
          res.status(500).send('Internal Server Error');
        } else if (results.length > 0) {
          res.send(results);
        } else {
          res.status(200).send([]);
        }
      });
    }
  });
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
