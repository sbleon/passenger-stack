package :ruby_enterprise, :provides => :ruby do
  description 'Ruby Enterprise Edition'
  version '1.8.7-2011.03'
  ree_path = "/opt/ruby-enterprise-#{version}"
  # Other packages may reference this
  RUBY_PATH = ree_path

  binaries = %w(erb gem irb rackup rails rake rdoc ree-version ri ruby testrb)
  # Apply patch to remove SSLv2 support, which is no longer present in Ubuntu 11.10 and OpenSSL >1.0
  push_text File.read(File.join(File.dirname(__FILE__), 'ruby_enterprise', 'sslv2_patch')), "/tmp/sslv2_patch", :sudo => true
  source "http://rubyenterpriseedition.googlecode.com/files/ruby-enterprise-#{version}.tar.gz" do
    post :extract, "patch /usr/local/build/ruby-enterprise-1.8.7-2011.03/source/ext/openssl/ossl_ssl.c < /tmp/sslv2_patch"
    custom_install "sudo ./installer --auto=#{ree_path} --dont-install-useful-gems --no-dev-docs"
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
  apt %w(zlib1g-dev libreadline-dev libssl-dev)
  requires :build_essential

  verify do
    has_apt 'zlib1g-dev'
    has_apt 'libreadline-dev'
    has_apt 'libssl-dev'
    has_apt 'curl'
  end
end