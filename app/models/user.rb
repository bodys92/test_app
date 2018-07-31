class User < ApplicationRecord

    attr_accessor :remember_token, :activation_token
    before_create :create_activation_digest
    before_save :downcase_email
    validates(:name, presence:true)
    validates :name, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence:true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX}, 
                    uniqueness: {case_sensitive: false}
    has_secure_password
    validates :password, presence: true, length: {minimum: 6},
                        allow_nil: true

    def activate 
        update_attribute(:activated, true)
        update_attribute(:activated_at, Time.zone.now)
    end

    def User.digest(string)
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
        BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token
    def User.token_new
        SecureRandom.urlsafe_base64
    end
    
    # Remembers a user in the database for use in persistent sessions.
    def remember
        self.remember_token = User.token_new
        update_attribute(:remember_digest, User.digest(self.remember_token))
    end

    def authenticated?(attribute, token)
        digest = self.send("#{attribute}_digest")
        if digest.nil?
            return false
        else
            BCrypt::Password.new(digest) == token
        end
    end
    
    def forget
        update_attribute(:remember_digest, nil)
    end

    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end



private

    def create_activation_digest
        self.activation_token = User.token_new
        self.activation_digest = User.digest(self.activation_token)
    end

    def downcase_email
        self.email = self.email.downcase
    end

end
