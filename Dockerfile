# Step 1: Use the official Node.js 16 image as the base
FROM node:21-bookworm

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Install pnpm
RUN npm install -g pnpm

# Step 4: Copy the package.json and pnpm-lock.yaml (or package-lock.json if you have it) files
COPY package.json pnpm-lock.yaml ./

# Optional: If your project uses environment variables, you can add them here
# ENV NEXT_PUBLIC_API_URL=https://api.example.com

# Step 5: Install dependencies
RUN pnpm install --frozen-lockfile

# Step 6: Copy the rest of your application code
COPY . .

RUN npx prisma generate

# Step 7: Build your Next.js application
RUN pnpm run build

# Step 8: Expose the port your app runs on
EXPOSE 3000

# Step 9: Define the command to run your app
CMD ["pnpm", "start"]
