package :git, :provides => :scm do
  description 'Git Distributed Version Control'

  requires :github_keys

  apt 'git'

  verify do
    has_file '/usr/bin/git'
  end
end

package :github_keys do
  github_key = File.read(File.join(File.dirname(__FILE__), 'git', 'github_key.txt'))
  # Don't require verification of github's ssh fingerprint for anyone on the system
  push_text github_key, '/etc/ssh/ssh_known_hosts', :sudo => true
end
