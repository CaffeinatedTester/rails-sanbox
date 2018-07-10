class User < ApplicationRecord
  PASSWORD_VALIDATOR = /(      # Start of group
    (?:                        # Start of nonmatching group, 4 possible solutions
      (?=.*[a-z])              # Must contain one lowercase character
      (?=.*[A-Z])              # Must contain one uppercase character
      (?=.*\W)                 # Must contain one non-word character or symbol
    |                          # or...
      (?=.*\d)                 # Must contain one digit from 0-9
      (?=.*[A-Z])              # Must contain one uppercase character
      (?=.*\W)                 # Must contain one non-word character or symbol
    |                          # or...
      (?=.*\d)                 # Must contain one digit from 0-9
      (?=.*[a-z])              # Must contain one lowercase character
      (?=.*\W)                 # Must contain one non-word character or symbol
    |                          # or...
      (?=.*\d)                 # Must contain one digit from 0-9
      (?=.*[a-z])              # Must contain one lowercase character
      (?=.*[A-Z])              # Must contain one uppercase character
    )                          # End of nonmatching group with possible solutions
    .*                         # Match anything with previous condition checking
  )/x # End of group

  before_save { self.email = email.downcase }
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 255},
    format: {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: "valid email required"},
    uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 6, maximum: 25},
   format: {:with => PASSWORD_VALIDATOR,
   message: "must contain 3 of the following 4: a lowercase letter, an uppercase letter, a digit, a non-word character or symbol"}
end
