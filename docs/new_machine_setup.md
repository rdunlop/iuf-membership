This describes the steps needed to bring up a new server in EC2

## Dependencies

- `sudo yum update`

- install RVM (check the RVM website)
- install correct version of ruby via e.g. `rvm install ruby-2.6.3`

- `sudo yum install git`

- `sudo yum install postgresql postgresql-devel`

## Configure RDS

- Ensure that the RDS instance allows access to the new EC2 instance Security Group.

## Do the initial deployment

- `cap staging deploy:check`, and address any missing-files
  - Specify the `.env` variables necessary to connect to the various services
- `cap staging deploy`
