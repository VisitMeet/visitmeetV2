# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super do |resource|
      if resource.errors.empty?
        # No need for reCAPTCHA verification
        resource.save
      end
    end
  end
end