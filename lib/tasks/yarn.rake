# frozen_string_literal: true

namespace :yarn do
  desc 'Yarn Install'
  task install: :environment do
    sh 'yarn install'
  end
end

Rake::Task['assets:precompile'].enhance ['yarn:install']
