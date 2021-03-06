class APIController < ApplicationController
  AUTHENTICATION_TOKEN_DESCRIPTION = <<-EOS
    L'authentification de l'API se fait via un header HTTP :

    ```
      Authorization: Bearer &lt;Token administrateur&gt;
    ```
  EOS

  before_action :authenticate_user
  before_action :default_format_json

  def authenticate_user
    if !valid_token?
      request_http_token_authentication
    end
  end

  protected

  def valid_token?
    administrateur.present?
  end

  def administrateur
    @administrateur ||= (authenticate_with_bearer_token || authenticate_with_param_token)
  end

  def authenticate_with_bearer_token
    authenticate_with_http_token do |token, options|
      Administrateur.find_by(api_token: token)
    end
  end

  def authenticate_with_param_token
    Administrateur.find_by(api_token: params[:token])
  end

  def default_format_json
    request.format = "json" if !request.params[:format]
  end
end
