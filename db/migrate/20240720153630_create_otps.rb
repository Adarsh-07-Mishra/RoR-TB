class CreateOtps < ActiveRecord::Migration[7.1]
  def change
    create_table :otps do |t|
      t.string :email
      t.string :otp
      t.datetime :expires_at

      t.timestamps
    end
  end
end
