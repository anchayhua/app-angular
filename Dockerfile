# Use an official Node.js runtime as a parent image
FROM node:18 as builder

# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the entire application directory to the container
COPY . .

# Build the Angular app for production
RUN npm run build

# Use a smaller, lightweight base image for serving the application
FROM nginx:alpine

# Copy the build output from the builder stage to the nginx directory
COPY --from=builder /app/dist/ /usr/share/nginx/html

# Expose port 80 to the outside world
EXPOSE 80

# Start the nginx web server when the container starts
CMD ["nginx", "-g", "daemon off;"]
