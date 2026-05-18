Rails.application.routes.draw do
  # Định nghĩa route cho việc đăng ký tài khoản
  post '/register', to: 'users#create'
  # Định nghĩa route cho việc đăng nhập (POST request)
  post '/login', to: 'sessions#create'

  resources :subscribers
  resources :products do
    resources :subscriptions, only: [:index, :create]
  end

  namespace :admin do #Tất cả các URL bên trong sẽ tự động được thêm tiền tố /admin ở đầu
    resources :users, only: [] do # Chỉ định resource user nhưng không tạo các route CRUD tiêu chuẩn
      resources :roles, controller: 'user_roles', only: [:create, :destroy] # Tạo nested route cho roles
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
