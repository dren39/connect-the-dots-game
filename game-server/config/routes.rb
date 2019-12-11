Rails.application.routes.draw do
  get '/initialize', to: 'points#init'
  post '/node-clicked', to: 'points#node_clicked'
end
