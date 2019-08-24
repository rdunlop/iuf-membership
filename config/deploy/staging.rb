set :rails_env, 'production'
set :branch, ENV["CIRCLE_SHA1"] || ENV["REVISION"] || ENV["BRANCH_NAME"] || "develop"

server "ec2-35-163-185-179.us-west-2.compute.amazonaws.com", user: "ec2-user", roles: %w{db}
