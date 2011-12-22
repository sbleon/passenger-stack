package :git, :provides => :scm do
  description 'Git Distributed Version Control'
  version '1.7.7.5'
  source "http://git-core.googlecode.com/files/git-#{version}.tar.gz"
  requires :git_dependencies
  
  verify do
    has_file '/usr/local/bin/git'
  end
end

package :git_dependencies do
  description 'Git Build Dependencies'
  apt 'git-core', :dependencies_only => true
end
