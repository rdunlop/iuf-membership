# IUF Membership

This is the [IUF](https://unicycling.org) Membership system.

It holds the list of members, as well as receives payment for membership.

It can be used to manage the membership.

## Environments

Staging: https://iuf-membership-staging.unicycling-software.com
Production: https://iuf-membership.unicycling-software.com

## API Endpoints

When integrating with this application, to check whether a given user is a Member, the endpoint is:

- `POST /api/member_status`, given 3 arguments:
  - `first_name`
  - `last_name`
  - `birthdate` (Date in ISO8601 format)

This endpoint will return with a JSON response, either:
`{ found: true }` or `{}` (if not found)

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
- For production use:
  - Set the PAYPAL_MODE to `live`, to use the real paypal, and creditcards will be processed

### Email Integration

In order to send email, we use AWS SES. We use an IAM User with permissions on SES in order to do this.

Specify:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- EMAIL_FROM (Address all email should be sent 'from')
- HOSTNAME (name of the host where all email links should point)

### Rollbar Integration

We use [Rollbar](https://rollbar.com) for tracking any exceptions/errors which may occur.

To configure this:
- ROLLBAR_ACCESS_TOKEN
- ROLLBAR_ENV # if you want to override the Rails.env

## Deployment

The application is automatically deployed when CI passes.

If `develop` is merged, it will be deployed to the staging server.
If `master` is merged, it will be deployed to the production server.

If you want to deploy manually `bundle exec cap staging deploy`
