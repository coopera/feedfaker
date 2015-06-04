require 'sinatra'
require "sinatra/json"

require_relative 'config'
require_relative 'gh_faker'

get '/users/:id/emails' do
  return json(GHFaker.emails(params[:id]))
end

GHFaker.new(Config['teamtracker_url'], Config['gh_url']).start