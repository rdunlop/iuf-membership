# frozen_string_literal: true

set :rails_env, 'production'
set :branch, ENV['CIRCLE_SHA1'] || ENV['REVISION'] || ENV['BRANCH_NAME'] || 'main'

# server 'ec2-52-58-78-3.eu-central-1.compute.amazonaws.com', user: 'ec2-user', roles: %w[web db]
server '3.126.82.52', user: 'ec2-user', roles: %w[web db]

set :nginx_server_name, 'iuf-membership-staging.unicycling-software.com'
