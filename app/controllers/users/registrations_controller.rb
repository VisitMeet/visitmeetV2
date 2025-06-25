# app/controllers/users/registrations_controller.rb

class Users::RegistrationsController < Devise::RegistrationsController
  include Recaptcha::Adapters::ControllerMethods
  include Recaptcha::Adapters::ViewMethods
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    if verify_recaptcha(action: 'signup', minimum_score: 0.5, secret_key: Rails.application.credentials.dig(:recaptcha, :secret_key))
      super do |resource|
        if resource.errors.empty?
          # Your post-signup logic here
          resource.save
        end
      end
    else
      build_resource(sign_up_params)
      flash.now[:alert] = "reCAPTCHA verification failed. Please try again."
      clean_up_passwords(resource)
      render :new, status: :unprocessable_entity
    end
  end

  

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :full_name])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :full_name])
  end
end