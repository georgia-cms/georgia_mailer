GeorgiaMailer::Engine.routes.draw do

  resources :messages do
    collection do
      get :search
      get :destroy_all_spam
    end
    member do
      get :spam
      get :ham
    end
  end
end
