# Rails Starter Template
**This template is to set up ruby on rails project easier for developer**


## How to set up Rails project from scratch

**Step 1 Clone this template from GitHub repository**

- You can clone it by `git clone https://github.com/MasaCode/rails_starter.git`

**Step 2 Configure .env variables**

- Rename `.env.example` to `.env` by running `mv .env.example .env`
- Modify each MYSQL variable to adjust project

**Step 3 Modify your Dockerfile to adjust project**

- You need to modify Dockerfile's `APP_HOME` variable to your directory name
```Dockerfile
ENV APP_HOME /{your directory name}
```

**Step 4 Modify docker-compose.yml to adjust project**
- Now you modify `web` container's volume and `datastore` name

```yml
datastore:
  image: busybox
  volumes:
    - {Your datastore name}:/var/lib/mysql

web:
  build: .
  command: bundle exec rails s -p 3000 -b '0.0.0.0'
  volumes:
    - .:/{Your project directory name}
    - {your local bundle name}:/usr/local/bundle
  ports:
    - "3000:3000"
  depends_on:
    - db

volumes:
  {Your datastore name}:
    driver: local
  {your local bundle name}
    driver: local
```

**Step 5 Create a project**
- Create a project by `docker-compose run web rails new . --force --database=mysql`

**Step 6 Build docker image**
- Build you docker image by `docker-compose build`

**Step 7 Start docker container**
- Start docker container by `docker-compose up -d`

**Step 8 Adjust your `config/database.yml`**
- Modify `username`, `password`, `host`, `database` variables

```yml
default: &default
  adapter: mysql2
  encoding: utf8
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: {Your MYSQL_USER}
  password: {Your MYSQL_PASSWORD}
  host: db

development:
  <<: *default
  database: {Your MYSQL_DATABASE}
```

**Step 9 See rails project running**
- Access to `localhost:3000` and see it running!


## How to set up already created project

**Step 1 Clone project from the GitHub repository**
- Clone project by `git clone {your repository url}`

**Step 2 Build docker image**
- Build docker image by `docker-compose build`

**Step 3 Start docker container**
- Start docker container by `docker-compose up -d`

**Step 4 Migrate database structure**
- Migrate database by `docker-compose run web rake db:migrate`

**Step 5 See rails project running**
- Access to `localhost:3000` and see it running!
