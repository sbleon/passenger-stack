package :apache, :provides => :webserver do
  description 'Apache2 web server.'
  apt 'apache2 apache2.2-common apache2-mpm-prefork apache2-utils libexpat1 ssl-cert' do
    post :install, 'a2enmod rewrite'
  end

  verify do
    has_apt 'apache2'
    has_executable '/usr/sbin/apache2'
  end

  requires :build_essential
  optional :apache_etag_support, :apache_deflate_support, :apache_expires_support
end

package :apache2_prefork_dev do
  description 'A dependency required by some packages.'
  apt 'apache2-prefork-dev'

  verify do
    has_apt 'apache2-prefork-dev'
  end
end

package :passenger, :provides => :appserver do
  description 'Phusion Passenger (mod_rails)'
  version '3.0.11' # I don't think this version is necessarily installed, as I had to update this the version of passenger it had gotten me.
  binaries = %w(passenger-config passenger-install-nginx-module passenger-install-apache2-module passenger-make-enterprisey passenger-memory-stats passenger-spawn-server passenger-status passenger-stress-test)

  passenger_config = '/etc/apache2/extras/passenger.conf'
  passenger_gem_path = "#{RUBY_PATH}/lib/ruby/gems/1.8/gems/passenger-#{version}"
  passenger_module = "#{passenger_gem_path}/ext/apache2/mod_passenger.so"

  gem 'passenger', :version => version do
    binaries.each {|bin| post :install, "ln -s -f #{RUBY_PATH}/bin/#{bin} /usr/local/bin/#{bin}"} # The -f forces the operation, so it doesn't fail the second time you run it.
    
    post :install, 'echo -en "\n\n\n\n" | sudo passenger-install-apache2-module'

    # SET UP CONFIG FILE
    # set up directory
    post :install, 'mkdir -p /etc/apache2/extras'
    # blast old file (I should back it up, but oh well)
    post :install, "rm -rf #{passenger_config}"
    # recreate file
    post :install, "touch #{passenger_config}"

    [%Q(LoadModule passenger_module #{passenger_module}),
    %Q(PassengerRoot #{passenger_gem_path}),
    %q(PassengerRuby /usr/local/bin/ruby),
    %q(RailsEnv production)].each do |line|
      post :install, "echo '#{line}' |sudo tee -a #{passenger_config}"
    end

    # Tell apache to use new config file
    post :install, "echo 'Include #{passenger_config}'|sudo tee -a /etc/apache2/apache2.conf"
    # Restart apache to note changes
    post :install, '/etc/init.d/apache2 restart'
  end

  verify do
    has_gem 'passenger', version
    has_file passenger_config
    has_file passenger_module
    binaries.each {|bin| has_symlink "/usr/local/bin/#{bin}", "#{RUBY_PATH}/bin/#{bin}" }
    # This should work, but on Ubuntu Lucid Lynx (10.04), apache2 doesn't start automatically
    # and needs to be started manually.
    #has_process "apache2"
  end

  requires :apache, :apache2_prefork_dev, :ruby, :passenger_dependencies
end

package :passenger_dependencies do
  apt 'libcurl4-gnutls-dev' # Compilation dependency for apache module

  verify do
    has_apt 'libcurl4-gnutls-dev'
  end
end

# These "installers" are strictly optional, I believe
# that everyone should be doing this to serve sites more quickly.

# Enable ETags
package :apache_etag_support do
  apache_conf = "/etc/apache2/apache2.conf"
  config = <<eol
  # Passenger-stack-etags
  FileETag MTime Size
eol

  push_text config, apache_conf, :sudo => true
  verify { file_contains apache_conf, "Passenger-stack-etags"}
end

# mod_deflate, compress scripts before serving.
package :apache_deflate_support do
  apache_conf = "/etc/apache2/apache2.conf"
  config = <<eol
  # Passenger-stack-deflate
  <IfModule mod_deflate.c>
    # compress content with type html, text, and css
    AddOutputFilterByType DEFLATE text/css text/html text/javascript application/javascript application/x-javascript text/js text/plain text/xml
    <IfModule mod_headers.c>
      # properly handle requests coming from behind proxies
      Header append Vary User-Agent
    </IfModule>
  </IfModule>
eol

  push_text config, apache_conf, :sudo => true
  verify { file_contains apache_conf, "Passenger-stack-deflate"}
end

# mod_expires, add long expiry headers to css, js and image files
package :apache_expires_support do
  apache_conf = "/etc/apache2/apache2.conf"

  config = <<eol
  # Passenger-stack-expires
  <IfModule mod_expires.c>
    <FilesMatch "\.(jpg|gif|png|css|js)$">
         ExpiresActive on
         ExpiresDefault "access plus 1 year"
     </FilesMatch>
  </IfModule>
eol

  push_text config, apache_conf, :sudo => true
  verify { file_contains apache_conf, "Passenger-stack-expires"}
end
