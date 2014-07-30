require 'sinatra/base'
require 'haml'
require 'kramdown'
require 'rack-google-analytics'

class Knownabouts < Sinatra::Base
  @@locals = { :bootstrap_theme => 'http://bootswatch.com/simplex/bootstrap.min.css' }

  get '/' do
    haml :readme, :locals => @@locals.merge({ :title => 'Knownabouts' })
  end

  run! if app_file == $0
end
