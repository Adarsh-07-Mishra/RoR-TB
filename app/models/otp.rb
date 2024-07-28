class Otp < ApplicationRecord
  validates :email, presence: true
  validates :otp, presence: true
  validates :expires_at, presence: true

  def self.generate_otp
    rand(100_000..999_999).to_s
  end

  def self.valid_otp?(email, otp)
    otp_record = Otp.find_by(email: email, otp: otp)
    return false unless otp_record
    return false if otp_record.expires_at < Time.current

    otp_record.destroy
    true
  end
end
