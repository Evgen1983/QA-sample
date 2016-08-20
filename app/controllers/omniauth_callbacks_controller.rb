class OmniauthCallbacksController < Devise::OmniauthCallbacksController 
   
  before_action :provider_sign_in, only: [ :facebook, :twitter ]
  

  def facebook
  end

  def twitter
  end

  def finish_sign_up
    data = session["devise.provider_data"]
    provider = data["provider"]
    @user = User.find_for_oauth(auth.merge(data))
      if @user && @user.persisted?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: provider.capitalize) if is_navigational_format?
      else
        flash[:notice] = 'Email is required to compete sign up'
        render 'omniauth_callbacks/confirm_email'
      end 
  end

  private
  def provider_sign_in
    @user = User.find_for_oauth(auth)
    if @user && @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: auth.provider.capitalize) if is_navigational_format?
    else
      session["devise.provider_data"] = ({provider: auth.provider, uid: auth.uid})
      flash[:notice] = 'Email is required to compete sign up'
      render 'omniauth_callbacks/confirm_email'
    end
  end
  
  def auth
    request.env['omniauth.auth'] || OmniAuth::AuthHash.new(params[:auth])
  end
end