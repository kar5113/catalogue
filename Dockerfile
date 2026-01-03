# FROM node:20
# WORKDIR /opt/server
# COPY package.json .
# COPY *.js .
# RUN npm install #this will have extra cache memory
# ENV MONGO_URL="mongodb://mongodb:27017/catalogue" \
#     MONGO="true"
# EXPOSE 8080
# CMD ["node","server.js"]


# FROM node:20.19.6-alpine3.23
# WORKDIR /opt/server
# COPY package.json .
# COPY *.js .
# RUN npm install
# ENV MONGO_URL="mongodb://mongodb:27017/catalogue" \
#     MONGO="true"
# EXPOSE 8080
# CMD ["node","server.js"]


FROM node:20.19.6-alpine3.23 as build
WORKDIR /opt/server
COPY package.json .
RUN npm install

FROM node:20.19.6-alpine3.23
LABEL project="roboshop" \
      component="catalogue" \
      version="2.0"   
RUN addgroup -S roboshop && adduser -S roboshop -G roboshop
WORKDIR /opt/server
COPY --from=build /opt/server .
COPY *.js .
ENV MONGO_URL="mongodb://mongodb:27017/catalogue" \
    MONGO="true"
RUN chown -R roboshop:roboshop /opt/server  
USER roboshop   
EXPOSE 8080
CMD ["node","server.js"]