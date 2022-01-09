#Full docker explanation: youtu.be/gAkwW2tuIqE

FROM node:12
#the base image. Every docker image needs a base image. node is a base image that runs nodejs well.
#The node version is 12. Follow the link (node) to view the base image. There are many publically
#available images on the internet which u can use as base image.

WORKDIR /app
#this will be the working dir in your image

COPY package*.json .
#copy the package.json and package-lock.json files into current working dir of the docker image.

RUN npm install
#install all packages in package-lock.json

COPY . .
#copy everything in current local dir to docker image working dir

ENV PORT=8080                      
#Or u can just create an env file. Then u don't need this command as that file would've already
#been copied into your image's working dir along with the rest of the code by the previous layer

EXPOSE 8080
#the docker container will listen on this port at runtime. U can specify multiple ports as well.
#The docker container will only listen on the specified ports, not on anything else. We need only 8080 in our case
#as that is the port our server listens on. Note that creating an ENV file doesn't mean that u don't have to write this
#command (obviously, as this is just telling container what ports to listen on).

CMD npm start
#runs the application (server)



#Note that each of these commands is run as a "layer". 1st command (FROM) is layer 1, 2nd command (WORKDIR) is layer 2
#and so on. So when this docker file is run to create a docker image, each of these layers form a commit. (like commit#1 =>
#Create base image, Commit#2 => create working directory and so on...).
#Also, this dockerfile is run whenever u make changes to anything (like the code or pakcage.json etc.).
#Note that docker caches each layer (which means if nothing is changed in some layer, then we don't need to run it). So
#if (say) nothing is changed in package.json or package-lock.json (no new packages installed), and nothing is changed in base
#image, then the first 4 commands won't run (their cache will be used). But if something changes in a layer, then all
#subsequent layers will also be run even if they are cached and nothing changed in them.
#This is the reason that we wrote COPY package*.json command before copying the code. Had we not wrote this command and
#just wrote COPY . . (copy everything in local to docker image) (package.json and package-lock.json would also have got
#copied as they are part of the current local dir) and then RUN npm install command, then every time we made changes in code
#COPY . . wpould;ve run and all subsequent commands (including RUN npm install) even though there may not be any new packages
#to install.


#"docker build -t username/appname:version dirinwhichdockerfileisstored"
#this will run the above commands and givr u a docker image id.
#use "docker run imageid" to run the container locally
#u can also push the image to a registry from where others can pull it and run docker containers for it.
#Note that u will need to map ports on your local machine to ports u have exposed, otherwise no one will be 
#listening on any port. U can give a "-p LocalMachinePort:DockerExposedPort" in "docker run" command
#to do this eg. "docker run -p 5000:8080 imageid". U can go to http://localhost:5000 to see your app running (http not https)