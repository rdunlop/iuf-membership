# frozen_string_literal: true

set :rails_env, 'production'
set :branch, ENV['CIRCLE_SHA1'] || ENV['REVISION'] || ENV['BRANCH_NAME'] || 'develop'

server 'ec2-35-163-185-179.us-west-2.compute.amazonaws.com', user: 'ec2-user', roles: %w[web db]

set :nginx_server_name, 'iuf-membership-staging.unicycling-software.com'