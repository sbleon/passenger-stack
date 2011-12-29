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
  apt %w(libcurl3 libcurl3-gnutls libcurl4-gnutls-dev)

  verify do
    has_apt 'libcurl3'
    has_apt 'libcurl3-gnutls'
    has_apt 'libcurl4-gnutls-dev'
  end
end