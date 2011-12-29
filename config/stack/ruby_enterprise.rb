package :ruby_enterprise, :provides => :ruby do
  description 'Ruby Enterprise Edition'
  version '1.8.7-2011.03'
  ree_path = "/opt/ruby-enterprise-#{version}"
  # Other packages may reference this
  RUBY_PATH = ree_path

  file_name = "ruby-enterprise-edition-#{version}_amd64.deb"

  binaries = %w(erb gem irb rackup rails rake rdoc ree-version ri ruby testrb)
  noop do
    pre :install, "curl http://dl.dropbox.com/u/3283085/Debian_Packages/oneiric/#{file_name} > /tmp/#{file_name}"
    pre :install, "dpkg -i /tmp/#{file_name}"
    post :install, "rm /tmp/#{file_name}"
    binaries.each {|bin| post :install, "ln -s #{ree_path}/bin/#{bin} /usr/local/bin/#{bin}" }
  end

  verify do
    has_directory install_path
    has_executable "#{ree_path}/bin/ruby"
    binaries.each {|bin| has_symlink "/usr/local/bin/#{bin}", "#{ree_path}/bin/#{bin}" }
  end

  requires :ree_dependencies
end

package :ree_dependencies do
  apt %w(zlib1g-dev libreadline-dev libssl-dev curl)
  requires :build_essential

  verify do
    has_apt 'zlib1g-dev'
    has_apt 'libreadline-dev'
    has_apt 'libssl-dev'
    has_apt 'curl'
  end
end