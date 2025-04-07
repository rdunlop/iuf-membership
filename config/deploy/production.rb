# frozen_string_literal: true

set :rails_env, 'production'
set :branch, ENV['CIRCLE_SHA1'] || ENV['REVISION'] || ENV['BRANCH_NAME'] || 'main'

server '35.158.75.138', user: 'ec2-user', roles: %w[web db]

set :nginx_server_name, 'iuf-membership.unicycling-software.com'
