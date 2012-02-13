package :imagemagick do
  description 'ImageMagick binaries'

  apt 'imagemagick'

  verify do
    has_apt 'imagemagick'
  end
end