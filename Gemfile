source 'http://rubygems.org'

# Only define Ruby version once (i.e. for Heroku)
version_file = File.join(File.dirname(__FILE__), '.ruby-version')
ruby File.read(version_file).strip

gem 'thin'
gem 'sinatra-activerecord'
gem 'rake'
gem 'rack'
gem 'pg'
gem 'dotenv'
gem 'slack-ruby-client', '~> 0.13'
gem 'figlet'

# Rack console
gem 'racksh'

group :test do
  gem 'rack-test'
  gem 'rspec'
  gem 'webmock'
end
