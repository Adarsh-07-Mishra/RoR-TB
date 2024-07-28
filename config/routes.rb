Rails.application.routes.draw do
  post 'request_otp', to: 'authentication#request_otp'
  post 'verify_otp', to: 'authentication#verify_otp'
end
