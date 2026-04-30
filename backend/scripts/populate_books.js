import mongoose from 'mongoose';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import { Product } from '../src/models/Product.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load env
dotenv.config({ path: path.join(__dirname, '../.env') });

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/sanad';

const bookTitles = [
  'The Silent Patient', 'Dune', 'Atomic Habits', 'The Alchemist', 'Sapiens',
  '1984', 'To Kill a Mockingbird', 'The Great Gatsby', 'Thinking, Fast and Slow',
  'A Brief History of Time', 'The Catcher in the Rye', 'Brave New World',
  'The Hobbit', 'Fahrenheit 451', 'The Power of Habit'
];

const categories = ['Audio', 'Braille', 'E-Book', 'Large Print'];
const tagsOptions = [['Audio Aids'], ['Visual Impairment'], ['Dyslexia Friendly'], ['Screen Reader Optimized']];

async function populate() {
  try {
    console.log('Connecting to MongoDB...');
    await mongoose.connect(MONGODB_URI);
    console.log('Connected.');

    console.log('Clearing existing books (products)...');
    await Product.deleteMany({});

    const products = [];
    for (let i = 1; i <= 30; i++) {
      const titleIndex = (i - 1) % bookTitles.length;
      const catIndex = (i - 1) % categories.length;
      const tagIndex = (i - 1) % tagsOptions.length;

      products.push({
        name: `${bookTitles[titleIndex]} - ${categories[catIndex]} Edition`,
        description: `A comprehensive ${categories[catIndex]} edition of the classic book "${bookTitles[titleIndex]}", specifically formatted for enhanced accessibility.`,
        category: categories[catIndex],
        price: Math.floor(Math.random() * 300) + 100, // between 100 and 400 EGP
        currency: 'EGP',
        in_stock: i % 5 !== 0, // 80% in stock
        stock_quantity: i % 5 !== 0 ? Math.floor(Math.random() * 50) + 5 : 0,
        accessibility_tags: tagsOptions[tagIndex],
        brand: 'Sanad Books',
        sku: `BOK-${1000 + i}`,
      });
    }

    console.log(`Inserting 30 books...`);
    await Product.insertMany(products);
    console.log('Successfully populated 30 fake books.');

  } catch (error) {
    console.error('Error populating books:', error);
  } finally {
    await mongoose.disconnect();
    console.log('Disconnected from MongoDB.');
  }
}

populate();
