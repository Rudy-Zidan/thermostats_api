# Requirements
- This project use sqlite.
- Create gemset first using: ```rvm gemset use 2.6.3@thermostats_api --create```
- Redis server runs at port 6379

# Setup and Run
- Start install gems using: ```bundle install```
- Run: ```rails db:setup```
- Start server: ```rails s```
- Start Sidekiq to process jobs using the following command: ```sidekiq```
- To run tests type: ```bundle exec rspec```
