# frozen_string_literal: true

set :rails_env, 'production'
set :branch, ENV['CIRCLE_SHA1'] || ENV['REVISION'] || ENV['BRANCH_NAME'] || 'develop'

server 'ec2-18-185-126-170.eu-central-1.compute.amazonaws.com', user: 'ec2-user', roles: %w[web db]

set :nginx_server_name, 'iuf-membership-staging.unicycling-software.com'
