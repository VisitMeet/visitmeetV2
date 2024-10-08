# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.errors.empty?
        unless verify_recaptcha(model: resource) && resource.save
          resource.errors[:base] << 'Captcha verification failed.'
          resource.destroy
          render :new and return
        end
      end
    end
  end
end