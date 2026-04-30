import mongoose from 'mongoose';
import dotenv from 'dotenv';
import path from 'path';
import { fileURLToPath } from 'url';
import { Job } from '../src/models/Job.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load env
dotenv.config({ path: path.join(__dirname, '../.env') });

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/sanad';
const SOURCE_URL = 'https://www.linkedin.com/jobs/search-results/?currentJobId=4339096967&keywords=jobs&origin=BLENDED_SEARCH_RESULT_NAVIGATION_JOB_CARD&originToLandingJobPostings=4339096967%2C4383813905%2C4404008909';

const jobTitles = ['Software Engineer', 'Product Manager', 'UX Designer', 'Data Scientist', 'Mobile Developer', 'Frontend Engineer', 'Backend Developer', 'DevOps Engineer', 'QA Specialist', 'System Architect', 'Project Coordinator', 'Business Analyst', 'Technical Writer', 'Cloud Specialist', 'AI Researcher', 'Security Expert', 'Database Admin', 'Network Engineer', 'Fullstack Developer', 'UI Specialist'];
const companies = ['TechNova', 'InnovateSoft', 'GlobalSystems', 'FutureWorks', 'SanadTech', 'CloudNine', 'DataCore', 'SmartLogic', 'NexGen', 'EliteCoders', 'DevPioneers', 'DigitalHorizon', 'WebMasters', 'CodeCraft', 'ByteStream', 'LogicGate', 'AlphaSystems', 'ZetaSoft', 'OmniTech', 'PrimeSolutions'];
const locations = ['Cairo, Egypt', 'Alexandria, Egypt', 'Giza, Egypt', 'Mansoura, Egypt', 'Remote'];
const types = ['full_time', 'part_time', 'contract', 'internship', 'temporary'];
const matchLevels = ['yes', 'no', 'unknown'];

async function populate() {
  try {
    console.log('Connecting to MongoDB...');
    await mongoose.connect(MONGODB_URI);
    console.log('Connected.');

    console.log('Clearing existing jobs from linkedin source...');
    await Job.deleteMany({ source: 'linkedin' });

    const jobs = [];
    for (let i = 1; i <= 50; i++) {
      const titleIndex = (i - 1) % jobTitles.length;
      const companyIndex = (i - 1) % companies.length;
      const locationIndex = (i - 1) % locations.length;
      const typeIndex = (i - 1) % types.length;
      const matchIndex = (i - 1) % matchLevels.length;

      jobs.push({
        source: 'linkedin',
        external_id: `fake_job_${i}`,
        source_url: SOURCE_URL,
        title: `${jobTitles[titleIndex]} #${i}`,
        company: `${companies[companyIndex]} Group`,
        location: locations[locationIndex],
        description: `This is a comprehensive description for the ${jobTitles[titleIndex]} position at ${companies[companyIndex]}. We are looking for someone with ${i} years of experience in the field of technology and innovation. Join our growing team to build the future of Sanad.`,
        employment_type: types[typeIndex],
        is_remote: locations[locationIndex] === 'Remote',
        accessibility_match: matchLevels[matchIndex],
        moderation_status: 'approved',
        publication_status: 'published',
        published_at: new Date(Date.now() - i * 3600000),
      });
    }

    console.log(`Inserting 50 jobs...`);
    await Job.insertMany(jobs);
    console.log('Successfully populated 50 fake jobs.');

  } catch (error) {
    console.error('Error populating jobs:', error);
  } finally {
    await mongoose.disconnect();
    console.log('Disconnected from MongoDB.');
  }
}

populate();
