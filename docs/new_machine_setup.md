This describes the steps needed to bring up a new server in EC2

## Dependencies

- `sudo yum update`

- install RVM (check the RVM website)
- Log out, log in (so that rvm is available)
- install correct version of ruby via e.g. `rvm install ruby-2.6.3`

- `sudo yum install git`

- `sudo yum install postgresql postgresql-devel`

- `sudo yum install nginx`
  - NOTE: This may fail, and you may need to run `sudo amazon-linux-extras install nginx1.12`
- create the `/etc/nginx/sites-enabled` and `/etc/nginx/sites-available` directories
  - `suio mkdir /etc/nginx/sites-enabled /etc/nginx/sites-available`
- update the `nginx.conf`:
  - `include /etc/nginx/sites-enabled/*;` directly after the `include /etc/nginx/conf.d/*.conf` line
  - change `user nginx;` to `user ec2-user;` to allow permissions to review the deployed app/socket.

- start nginx `sudo service nginx start`

- Install nodeJS
  - Install [NVM](https://github.com/nvm-sh/nvm)
  - Log out / log in (so that nvm is available)
  - `nvm install node`

- Install yarn `curl -o- -L https://yarnpkg.com/install.sh | bash`

## Configure RDS

- Ensure that the RDS instance allows access to the new EC2 instance Security Group.

- If this is a new environment, create a new db user:
  - log into the user with the superuser account (`psql -U <root user> -h <host> postgres`)
  - Then run `CREATE USER iuf_membership_staging WITH PASSWORD '<some password>';`
  - From within the master-database connection, create the database with `CREATE DATABASE <name of db>;`
  - Grant access to the user to the db `GRANT ALL PRIVILEGES ON DATABASE <name of db> to <user>;`
  - Log out `\q`

## Create a Load Balancer (for HTTPS reasons)

- When you start creating your load Balancer, you should add an HTTPS Listener.
- This will prompt you to create a new certificate using the ACM
- Create a new Certificate using ACM, with DNS validation
- Once the certificate is granted, continue creating your ELB.
- Update the Route 53 mapping to map to the ELB for the given DNS entry.

## Security Groups

- Ensure that the new Ec2 instance has a security group inbound rule to allow HTTP (port 80) traffic from the ELB
- Ensure that the new Ec2 instance has a security group inbound rule to allow SSH traffic from Anywhere
- Ensure that the ELB has HTTP/HTTPS access
- Ensure that the RDS has a security group rule which allows inbound access from a security group assigned to the EC2 instance

## Do the initial deployment

- Update the `deploy/<env>.rb` file with the URL of the EC2 instance.
- `cap staging deploy:check`, and address any missing-files
  - Specify the `.env` variables necessary to connect to the various services
- `bundle exec cap staging puma:nginx_config` in order to load the nginx configuration onto the server
- Log in to the machine, and restart nginx `sudo service nginx restart` to load the new config
- `cap staging deploy` to deploy the code, and start the puma server

## Install monit and configure it to keep the app running

- https://tecadmin.net/install-and-configure-monit-on-linux/
- You will ned to enable the epel repository
- `sudo yum install monit`
- `sudo service monit start`
- `cap staging puma:monit:config` in order to configure monit to watch puma for issues

## Configure nginx to start at boot

- `sudo systemctl enable nginx`

## Configure monit to start at boot

- `sudo systemctl enable monit`

## Set up CircleCI deployment

In order for CircleCI to be able to deploy to the server automatically, you must add a ssh public key to the server's `~/.ssh/authorized_keys` file. The matching private key should be installed in CircleCI configuration UI.
