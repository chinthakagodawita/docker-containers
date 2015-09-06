require 'serverspec'
require 'docker'

# Setup Docker URL and certificates.
set :backend, :docker
docker_host = ENV['DOCKER_HOST'].dup
if (ENV['DOCKER_TLS_VERIFY'])
  cert_path = File.expand_path ENV['DOCKER_CERT_PATH']
  Docker.options = {
    client_cert: File.join(cert_path, 'cert.pem'),
    client_key: File.join(cert_path, 'key.pem')
  }
  Excon.defaults[:ssl_ca_file] = File.join(cert_path, 'ca.pem')
  docker_host.gsub!(/^tcp/,'https')
end
Docker.url = docker_host

# Require all local shared files.
Dir["#{File.dirname(__FILE__)}/_shared/**/*.rb"].each do |f|
  require f
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.tty = true
  config.include Helpers
end
