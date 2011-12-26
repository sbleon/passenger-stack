package :git, :provides => :scm do
  description 'Git Distributed Version Control'
  version '1.7.7.5'
  source "http://git-core.googlecode.com/files/git-#{version}.tar.gz"
  requires :git_dependencies, :github_keys

  verify do
    has_file '/usr/local/bin/git'
  end
end

package :git_dependencies do
  description 'Git Build Dependencies'
  apt 'git-core', :dependencies_only => true
end

package :github_keys do
  github_key = File.read(File.join(File.dirname(__FILE__), 'git', 'github_key.txt'))
  # Don't require verification of github's ssh fingerprint for anyone on the system
  push_text github_key, '/etc/ssh/ssh_known_hosts', :sudo => true
end
