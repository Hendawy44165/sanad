import bcrypt from "bcryptjs";

import { connectDatabase } from "../src/config/db.js";
import { env } from "../src/config/env.js";
import { AdminAccount } from "../src/models/AdminAccount.js";

const MAX_ADMINS = 5;

async function seedAdminUser() {
  const usernameArg = process.argv[2] || "admin";
  const passwordArg = process.argv[3] || "admin123";

  const username = String(usernameArg).trim().toLowerCase();
  const password = String(passwordArg).trim();

  if (!username || !password) {
    throw new Error("username and password are required");
  }

  await connectDatabase(env.MONGODB_URI);

  const existing = await AdminAccount.findOne({ username });
  if (!existing) {
    const adminCount = await AdminAccount.countDocuments({ is_active: true });
    if (adminCount >= MAX_ADMINS) {
      throw new Error("Cannot create admin user: max 5 admin accounts reached");
    }
  }

  const passwordHash = await bcrypt.hash(password, 10);
  const account = await AdminAccount.findOneAndUpdate(
    { username },
    {
      $set: {
        password_hash: passwordHash,
        is_active: true,
      },
    },
    { upsert: true, new: true },
  );

  const total = await AdminAccount.countDocuments({ is_active: true });
  console.log(`Admin user ready: ${account.username}`);
  console.log(`Active admin accounts: ${total}/${MAX_ADMINS}`);
  process.exit(0);
}

seedAdminUser().catch((error) => {
  console.error("Failed to seed admin user:", error.message);
  process.exit(1);
});
