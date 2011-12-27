package :rmagick_gem do
  description "The rmagick gem, an image manipulation library"

  requires :rmagick_dependencies

  gem 'rmagick'

  verify do
    has_gem 'rmagick'
  end
end

package :rmagick_dependencies do
  requires :build_essential
  # TODO: This package requires 179MB of disk on my Ubuntu Oneiric server. A binary
  # installation of RMagick would be really nice!
  apt 'libmagick9-dev'
end