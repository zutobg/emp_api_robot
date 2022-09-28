class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Basic::ControllerMethods
  http_basic_authenticate_with name:     Settings.API.Credentials.Login,
                               password: Settings.API.Credentials.Password,
                               except:   :index
end
