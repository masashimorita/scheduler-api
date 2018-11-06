## How to set up already created project

**Step 1 Clone project from the GitHub repository**
- Clone project by `git clone {your repository url}`

**Step 2 Build docker image**
- Build docker image by `docker-compose build`

**Step 3 Start docker container**
- Start docker container by `docker-compose up -d`

**Step 4 Migrate database structure**
- Create database by `docker-compose run web rake db:create`
- Migrate database by `docker-compose run web rake db:migrate`

**Step 5 See rails project running**
- Access to `localhost:3000` and see it running!
