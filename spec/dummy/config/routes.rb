Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  # get '*request_path', to: 'pages#show', as: :page
  # root to: 'pages#show', request_path: 'home'
  mount Georgia::Mailer::Engine => '/mailer'
  mount Georgia::Engine => '/admin'

  root to: 'messages#new'

end
