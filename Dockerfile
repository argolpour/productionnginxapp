# Use an official Node.js runtime as a parent image
FROM node:14.16.0-alpine3.13 as build

# Set the working directory to /app
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Build the React app for production
RUN npm run build

# Use an official nginx runtime as a parent image
FROM nginx:1.21.3-alpine

# Remove the default nginx welcome page
RUN rm /usr/share/nginx/html/*

# Copy the built React app to the nginx web server's public directory
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start the nginx server in the foreground
CMD ["nginx", "-g", "daemon off;"]

