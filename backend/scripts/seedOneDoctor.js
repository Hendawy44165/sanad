import { connectDatabase } from "../src/config/db.js";
import { env } from "../src/config/env.js";
import { Doctor } from "../src/models/Doctor.js";

async function seedOneDoctor() {
  await connectDatabase(env.MONGODB_URI);

  const payload = {
    name: "Dr. Ahmed Nabil",
    specialty: "Physical Medicine and Rehabilitation",
    description:
      "Supports mobility and rehabilitation plans for patients with accessibility needs.",
    rating: 4.8,
    rating_count: 124,
    location: {
      address: "Nasr City Medical Center, Building B",
      city: "Cairo",
      lat: 30.0609,
      lng: 31.3305,
    },
    work_schedule: [
      {
        day: "sunday",
        start_time: "10:00",
        end_time: "16:00",
        is_available: true,
      },
      {
        day: "tuesday",
        start_time: "10:00",
        end_time: "16:00",
        is_available: true,
      },
      {
        day: "thursday",
        start_time: "12:00",
        end_time: "18:00",
        is_available: true,
      },
    ],
    contact_phone: "+201005551234",
    contact_email: "dr.ahmed.nabil@example.com",
    image_url: "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d",
    is_active: true,
  };

  const doctor = await Doctor.findOneAndUpdate(
    { name: payload.name, specialty: payload.specialty },
    { $set: payload },
    { upsert: true, new: true },
  );

  console.log("Seeded doctor id:", String(doctor._id));
  process.exit(0);
}

seedOneDoctor().catch((error) => {
  console.error("Failed to seed doctor:", error);
  process.exit(1);
});
