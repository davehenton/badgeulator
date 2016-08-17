# Require the airbrake gem in your App.
# ---------------------------------------------
#
# Ruby - In your Gemfile
# gem 'airbrake', '~> 5.0'
#
# Then add the following to config/initializers/errbit.rb
# -------------------------------------------------------

Airbrake.configure do |config|
  config.host = 'http://errbit'
  config.project_id = 1 #true
  config.project_key = '1c0480263722c4d2c99ff91cddd9e95e'
end
