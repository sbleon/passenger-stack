package :nokogiri_gem do
  description "nokogiri gem (xml library)"

  requires :nokogiri_dependencies, :ruby

  gem 'nokogiri'

  verify do
    has_gem 'nokogiri'
  end
end

package :nokogiri_dependencies do
  requires :build_essential
  apt %w(libxslt1-dev libxml2-dev)

  verify do
    has_apt 'libxslt1-dev'
    has_apt 'libxml2-dev'
  end
end