class AuthenticationController < ApplicationController
  def request_otp
    @user = User.find_by_email(params[:email])

    if @user
      # If user exists, generate OTP and send it
      otp = Otp.generate_otp
      Otp.create(email: @user.email, otp: otp, expires_at: 10.minutes.from_now)
      UserMailer.otp_email(@user, otp).deliver_now
      render json: { message: 'OTP sent to your email!' }, status: :ok
    else
      # If user does not exist, create a new user
      @user = User.create(email: params[:email], password: SecureRandom.hex)
      if @user.persisted?
        otp = Otp.generate_otp
        Otp.create(email: @user.email, otp: otp, expires_at: 10.minutes.from_now)
        UserMailer.otp_email(@user, otp).deliver_now
        render json: { message: 'OTP sent to your email!' }, status: :ok
      else
        render json: { error: 'Unable to create user' }, status: :unprocessable_entity
      end
    end
  end

  def verify_otp
    email = params[:email]
    otp = params[:otp]
    @user = User.find_by_email(email)

    unless @user
      render json: { error: 'User not found' }, status: :not_found
      return
    end

    if Otp.valid_otp?(email, otp)
      token = JwtService.encode(user_id: @user.id)
      time = Time.now + 7.hours
      render json: {
        message: 'User logged in successfully!',
        token: token,
        exp: time.strftime('%m-%d-%Y %H:%M')
      }, status: :ok
    else
      render json: { error: 'Invalid OTP or OTP expired' }, status: :unauthorized
    end
  end

  private

  def otp_params
    params.permit(:email, :otp)
  end
end
