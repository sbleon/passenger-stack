package :mysql_gem, :provides => :ruby_database_driver do
  description 'Ruby MySQL gem'
  apt 'libmysqlclient-dev'

  gem 'mysql'
  
  verify do
    has_gem 'mysql'
  end
  
  requires :ruby
end
