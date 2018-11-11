## Scheduler Server Applciation 
This application is to manage your work time scheduler and hope to make it better for you

## Setting up project
**Step 1 Clone project from the GitHub repository**
- Clone project by `git clone {your repository url}`

**Step 2 create config files**
- Create database.yml by `cp config/database.yml.example config/database.yml`
- get master.key and put it in config/

**Step 3 Build docker image**
- Build docker image by `docker-compose build`

**Step 4 Install dependencies**
- run following command `docker-compose run web bundle install`

**Step 5 Migrate database structure**
- Create database by `docker-compose run web rake db:create`
- Migrate database by `docker-compose run web rake db:migrate`

**Step 6 Create a environment file**
- Create it by `cp .env.example .env`
- Set each variable to adjust your environment

**Step 7 Start docker container**
- Start docker container by `docker-compose up -d`

**Step 8 See rails project running**
- Access to `localhost:3000` and see it running!
