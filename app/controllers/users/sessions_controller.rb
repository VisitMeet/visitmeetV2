# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      unless verify_recaptcha(model: resource)
        resource.errors[:base] << 'Captcha verification failed.'
        render :new and return
      end
    end
  end
end