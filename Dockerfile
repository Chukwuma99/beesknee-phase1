# official Nginx runtime
FROM nginx:alpine

# remove the default Nginx index.html
RUN rm -v /usr/share/nginx/html/*

# adding current directory contents into the Nginx HTML directory
ADD . /usr/share/nginx/html

# here we make port 80 available to the world outside this container
EXPOSE 80

# running Nginx when the container launches
CMD ["nginx", "-g", "daemon off;"]

