This describes the steps needed to bring up a new server in EC2

## Dependencies

- `sudo yum update`

- install RVM (check the RVM website)
- install correct version of ruby via e.g. `rvm install ruby-2.6.3`

- `sudo yum install git`

- `sudo yum install postgresql postgresql-devel`

- `sudo yum install nginx`
- create the `/etc/nginx/sites-enabled` and `/etc/nginx/sites-available` directories
- update the `nginx.conf`:
  - `include /etc/nginx/sites-enabled/*;` directly after the `include /etc/nginx/conf.d/*.conf` line
  - change `user nginx;` to `user ec2-user;` to allow permissions to review the deployed app/socket.

- start nginx `sudo service nginx start`

- Install nodeJS
  - Install [NVM](https://github.com/nvm-sh/nvm)
  - `nvm intsall node`

- Install yarn `curl -o- -L https://yarnpkg.com/install.sh | bash`

## Configure RDS

- Ensure that the RDS instance allows access to the new EC2 instance Security Group.

- If this is a new environment, create a new db user:
  - log into the user with the superuser account (`psql ...`)
  - Then run `CREATE USER iuf_membership_staging WITH PASSWORD '<some password>';`
  - From within the database connection, create the database with `CREATE DATABASE <name of db>;`

## Configure EC2

- Ensure that the new Ec2 instance has a security group inbound rule to allow HTTP (port 80) traffic

## Do the initial deployment

- `cap staging deploy:check`, and address any missing-files
  - Specify the `.env` variables necessary to connect to the various services
- `bundle exec cap staging puma:nginx_config` in order to load the nginx configuration onto the server
- `cap staging deploy`
