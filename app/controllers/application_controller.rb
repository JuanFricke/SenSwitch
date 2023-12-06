class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    # Redireciona para a raiz após o login
    root_path
  end
end
