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
      get :spam
      get :ham
      get :resend_notification
    end
  end

end