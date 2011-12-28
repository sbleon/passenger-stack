package :mysql2_gem, :provides => :ruby_database_driver do
  description 'Ruby MySQL2 gem'
  apt 'libmysqlclient-dev'

  gem 'mysql2'
  
  verify do
    has_gem 'mysql2'
  end
  
  requires :ruby
end
