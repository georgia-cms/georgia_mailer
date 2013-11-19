GeorgiaMailer::Engine.routes.draw do
  resources :messages, only: [:create], path: '/'
end
