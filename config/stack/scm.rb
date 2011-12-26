package :git, :provides => :scm do
  description 'Git Distributed Version Control'

  apt 'git'
  
  verify do
    has_file '/usr/bin/git'
  end
end
