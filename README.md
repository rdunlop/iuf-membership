# IUF Membership

This is the [IUF](https://unicycling.org) Membership system.

It holds the list of members, as well as receives payment for membership.

It can be used to manage the membership.

## Development Setup

To do development of this system, we recommend using [docker](https://docs.docker.com/docker-for-mac/install/)

After installing Docker, you need only run `docker-compose up` in order to have a running application.

Then browse to `http://localhost:3000` to see the application and interact with it.

If you want to have some data seeded (like fake users, fake memberships, etc), run `docker-compose run app rake db:seed:development`

## Features

TBD

## Deployment

TBD
