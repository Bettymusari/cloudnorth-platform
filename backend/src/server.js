const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    service: 'cloudnorth-backend',
    environment: process.env.NODE_ENV || 'development'
  });
});

// API routes
app.get('/api/products', (req, res) => {
  res.json({
    products: [
      { id: 1, name: 'CloudNorth T-Shirt', price: 29.99, category: 'clothing' },
      { id: 2, name: 'CloudNorth Hoodie', price: 59.99, category: 'clothing' },
      { id: 3, name: 'AWS Certified Sticker Pack', price: 9.99, category: 'accessories' }
    ]
  });
});

app.get('/api/products/:id', (req, res) => {
  const productId = parseInt(req.params.id);
  const products = [
    { id: 1, name: 'CloudNorth T-Shirt', price: 29.99, description: 'Premium cotton t-shirt' },
    { id: 2, name: 'CloudNorth Hoodie', price: 59.99, description: 'Warm and comfortable hoodie' },
    { id: 3, name: 'AWS Certified Sticker Pack', price: 9.99, description: 'Collection of AWS certification stickers' }
  ];
  
  const product = products.find(p => p.id === productId);
  if (!product) {
    return res.status(404).json({ error: 'Product not found' });
  }
  
  res.json(product);
});

// Error handling
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ error: 'Something went wrong!' });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`CloudNorth Backend running on port ${PORT}`);
  console.log(`Environment: ${process.env.NODE_ENV}`);
});
