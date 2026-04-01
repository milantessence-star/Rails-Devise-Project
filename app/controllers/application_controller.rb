class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authenticate_user!
  before_action :configure, if: :devise_controller?

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  protected
  def configure
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username, :role, :email ])
    devise_parameter_sanitizer.permit(:sign_in, keys: [ :login ])
    devise_parameter_sanitizer.permit(:account_update, keys: [ :username, :role, :email ])
  end
  def require_admin!
    unless current_user.admin?
      flash[:alert] = "You arent authorized.!"
      redirect_to root_path
    end
  end
  def require_user!
    unless current_user.user?
      flash[:alert] = "You arent authorized.!"
      redirect_to root_path
    end
  end
end
