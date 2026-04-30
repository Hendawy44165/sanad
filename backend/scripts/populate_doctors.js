import mongoose from 'mongoose';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import { Doctor } from '../src/models/Doctor.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load env
dotenv.config({ path: path.join(__dirname, '../.env') });

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/sanad';

const firstNames = ['Ahmed', 'Mohamed', 'Omar', 'Ali', 'Hassan', 'Mahmoud', 'Fatima', 'Aisha', 'Nada', 'Mona', 'Sara', 'Amira'];
const lastNames = ['Nabil', 'Hassan', 'Ibrahim', 'Khalil', 'Mostafa', 'Osman', 'Saad', 'Salem', 'Tariq', 'Youssef'];
const specialties = ['Neurology', 'Physical Therapy', 'Occupational Therapy', 'Speech Therapy', 'Psychiatry', 'Orthopedics'];
const cities = ['Cairo', 'Alexandria', 'Giza', 'Mansoura'];
const addresses = ['123 Main St, Clinic A', '456 Health Ave, Building 2', '789 Recovery Rd, Suite 3', '321 Care St, Floor 4'];

async function populate() {
  try {
    console.log('Connecting to MongoDB...');
    await mongoose.connect(MONGODB_URI);
    console.log('Connected.');

    console.log('Clearing existing doctors...');
    await Doctor.deleteMany({});

    const doctors = [];
    for (let i = 1; i <= 30; i++) {
      const fnIndex = (i - 1) % firstNames.length;
      const lnIndex = (i - 1) % lastNames.length;
      const specIndex = (i - 1) % specialties.length;
      const cityIndex = (i - 1) % cities.length;

      doctors.push({
        name: `Dr. ${firstNames[fnIndex]} ${lastNames[lnIndex]}`,
        specialty: specialties[specIndex],
        description: `Highly experienced ${specialties[specIndex]} specialist with a focus on accessible healthcare and rehabilitation. Dedicated to providing top-tier care in ${cities[cityIndex]}.`,
        rating: Number((Math.random() * (5 - 3) + 3).toFixed(1)), // random between 3.0 and 5.0
        rating_count: Math.floor(Math.random() * 200) + 10,
        location: {
          city: cities[cityIndex],
          address: addresses[i % addresses.length],
        },
        contact_phone: `+201${Math.floor(Math.random() * 900000000) + 100000000}`,
        contact_email: `dr.${firstNames[fnIndex].toLowerCase()}${i}@example.clinic`,
        image_url: `https://i.pravatar.cc/150?u=dr_${i}`,
        is_active: true,
      });
    }

    console.log(`Inserting 30 doctors...`);
    await Doctor.insertMany(doctors);
    console.log('Successfully populated 30 fake doctors.');

  } catch (error) {
    console.error('Error populating doctors:', error);
  } finally {
    await mongoose.disconnect();
    console.log('Disconnected from MongoDB.');
  }
}

populate();
