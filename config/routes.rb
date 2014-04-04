GeorgiaMailer::Engine.routes.draw do

  resources :messages, only: :create

end

Georgia::Engine.routes.draw do

  resources :messages do
    collection do
      get :search
      get :destroy_all_spam
    end
    member do
      get :resend_notification
      post :spam
      post :ham
    end
  end

end