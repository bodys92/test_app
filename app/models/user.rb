class User < ApplicationRecord

    attr_accessor :activation_token,:remember_token, :reset_token


    before_create :create_activation_digest
    before_save :downcase_email

    has_secure_password
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship",
                                    foreign_key: "follower_id",
                                    dependent: :destroy
    
    has_many :passive_relationships, class_name: "Relationship",
                                    foreign_key: "followed_id",
                                    dependent: :destroy                                

    has_many :following, through: :active_relationships, source: :followed
    has_many :followers, through: :passive_relationships, source: :follower


    validates(:name, presence:true)
    validates :name, length: {maximum: 50}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence:true, length: {maximum: 255},
                    format: {with: VALID_EMAIL_REGEX}, 
                    uniqueness: {case_sensitive: false}
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

    def feed
        following_ids = "SELECT followed_id FROM relationships
                         WHERE  follower_id = :user_id"
                         
        Micropost.where("user_id IN (#{following_ids})
                         OR user_id = :user_id", user_id: id)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end

    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def crate_reset_digest
        self.reset_token = User.token_new
        update_attribute(:reset_digest, User.digest(self.reset_token))
        update_attribute(:reset_send_at, Time.zone.now)
    end

    def password_token_expired?
        reset_send_at < 2.hours.ago
    end

    def follow(other_user)
        following << other_user
    end

    def unfollow(other_user)
        following.delete(other_user)
    end

    def following?(other_user)
        following.include?(other_user)
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
