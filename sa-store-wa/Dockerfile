FROM node:6.11.2

RUN useradd --user-group --create-home --shell /bin/false app

ENV HOME=/Store
RUN mkdir $HOME
WORKDIR $HOME

RUN npm install -g @angular/cli@latest
COPY package.json $HOME/package.json
RUN npm install && npm cache clean
COPY . /Store

EXPOSE 4200
EXPOSE 49152

CMD ["npm", "start", "--host=0.0.0.0"]