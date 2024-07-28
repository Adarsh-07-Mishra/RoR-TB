class UserMailer < ApplicationMailer
  def otp_email(user, otp)
    @user = user
    @otp = otp
    mail(to: @user.email, subject: 'Your OTP Code')
  end
end
