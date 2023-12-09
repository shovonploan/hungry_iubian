const express = require('express');
const bodyParser = require('body-parser');
const mysql = require('mysql');

const app = express();
const port = 3000;

// Middleware to parse JSON in the request body
app.use(bodyParser.json());

// MySQL connection configuration
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
    // Perform MySQL query for authentication
    const query = 'SELECT * FROM user WHERE userName = ? AND password = ?';
    connection.query(query, [userName, password], (err, results) => {
      if (err) {
        console.error('MySQL error:', err);
        res.status(500).send('Internal Server Error');
      } else if (results.length > 0) {
        res.send(results);
      } else {
        res.status(401).send('Invalid credentials');
      }
    });
  } else {
    res.status(400).send('Invalid request. Please provide both username and password.');
  }
});

app.get('/dishes', (req, res) => {
  const query = 'SELECT * FROM dish ';
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
  const query = 'SELECT * FROM dish WHERE quantityLeft > 0';
  connection.query(query, (err, results) => {
    if (err) {
      console.error('MySQL error:', err);
      res.status(500).send('Internal Server Error');
    } else {
      res.send(results);
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

app.post('/createOrder', (req, res) => {
  const { userId, isPreOrder, dishQuantities } = req.body;

  connection.beginTransaction((err) => {
    if (err) {
      console.error('MySQL error:', err);
      return res.status(500).send('Internal Server Error');
    }

    const insertOrderQuery = 'INSERT INTO ORDERS (userId, isPreOrder) VALUES (?, ?)';
    connection.query(insertOrderQuery, [userId, isPreOrder], (err, result) => {
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
  const {
    userId,
    userName,
    email,
    phone,
    passportNo,
    fatherName,
    motherName,
    dateOfBirth,
  } = req.body;

  if (
    userId &&
    userName &&
    email &&
    phone &&
    passportNo &&
    fatherName &&
    motherName &&
    dateOfBirth
  ) {
    const userIdInt = parseInt(userId);

    const updateQuery =
      'UPDATE user SET userName=?, email=?, phone=?, passportNo=?, fatherName=?, motherName=?, dateOfBirth=? WHERE userId=?';
    const updateValues = [
      userName,
      email,
      phone,
      passportNo,
      fatherName,
      motherName,
      dateOfBirth,
      userIdInt,
    ];

    connection.query(updateQuery, updateValues, (updateErr, updateResults) => {
      if (updateErr) {
        console.error('MySQL error during update:', updateErr);
        res.status(500).send('Internal Server Error');
      } else if (updateResults.affectedRows > 0) {
        const fetchQuery = 'SELECT * FROM user WHERE userId = ?';
        connection.query(fetchQuery, [userIdInt], (fetchErr, fetchResults) => {
          if (fetchErr) {
            console.error('MySQL error during fetch:', fetchErr);
            res.status(500).send('Internal Server Error');
          } else if (fetchResults.length > 0) {
            const updatedUser = fetchResults[0];
            res.status(200).json(updatedUser);
          } else {
            res.status(404).send('User not found');
          }
        });
      } else {
        res.status(404).send('User not found');
      }
    });
  } else {
    res
      .status(400)
      .send('Invalid request. Please provide all required user information.');
  }
});

app.listen(port, () => {
  console.log(`Server listening at http://localhost:${port}`);
});
