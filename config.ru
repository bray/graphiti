require './graphiti'

auth = YAML.load_file(File.join('config', 'auth.yml'))
use Rack::Auth::Basic, "Protected Area" do |username, password|
  username == auth['username'] && password == auth['password']
end

run Graphiti
