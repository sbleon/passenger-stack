package :bundler_gem do
  description "Bundler gem"
  requires :ruby

  gem 'bundler' do
    post :install, "ln -s -f #{RUBY_PATH}/bin/bundle /usr/local/bin/bundle"
  end

  verify do
    has_gem 'bundler'
  end
end