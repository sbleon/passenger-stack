package :curb_gem do
  description "The curb gem, a curl interface in ruby"

  requires :curb_dependencies

  gem 'curb'

  verify do
    has_gem 'curb'
  end
end

package :curb_dependencies do
  requires :build_essential
  apt %w(libcurl3 libcurl4-openssl-dev)

  verify do
    has_apt 'libcurl3'
    has_apt 'libcurl4-openssl-dev'
  end
end