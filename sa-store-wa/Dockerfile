FROM node:6.11.3

RUN useradd --user-group --create-home --shell /bin/false app

ENV HOME=/Store
RUN mkdir $HOME
WORKDIR $HOME

RUN npm install -g @angular/cli
COPY package.json $HOME/package.json
RUN npm install && npm cache clean
COPY . /Store

EXPOSE 4200
EXPOSE 49152

CMD ["ng", "serve", "--host=0.0.0.0"]