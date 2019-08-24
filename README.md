# IUF Membership

This is the [IUF](https://unicycling.org) Membership system.

It holds the list of members, as well as receives payment for membership.

It can be used to manage the membership.

## Development Setup

To do development of this system, we recommend using [docker](https://docs.docker.com/docker-for-mac/install/)

After installing Docker, you need only run `docker-compose up` in order to have a running application.

Then browse to `http://localhost:3000` to see the application and interact with it.

If you want to have some data seeded (like fake users, fake memberships, etc), run `docker-compose run app rake db:seed:development`

### Running tests in development

If you make any modifications, you should run the tests to ensure that existing features still work. To run the tests:

    docker-compose run app bash
    bundle exec rake db:create db:migrate RAILS_ENV=test
    bundle exec rake test

## Features

TBD

### Database Setup

- The following environment variables are used to specify the database setup
  - DATABASE_HOST - name of the server
  - DATABASE_NAME - name of the database
  - DATABASE_USERNAME
  - DATABASE_PASSWORD

### Paypal integration

Create a Paypal Application through the [Developer Dashboard](https://developer.paypal.com)
- When creating the App, choos ethe following settings:
  - Accept payments
- Copy the following detail from the Dashboard:
  - Set the PAYPAL_CLIENT_ID in the `.env.local` file
  - Set the PAYPAL_SECRET in the `.env.local` file

## Deployment

TBD
