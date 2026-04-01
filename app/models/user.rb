class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :confirmable, :lockable, :timeoutable
  ROLES = %w[admin user].freeze
  attr_accessor :login
  validates :username, presence: { message: "Username is must.!" },
                       uniqueness: { message: "Username is already taken.!" },
                       length: { minimum: 6, maximum: 20, message: "Username must be 6 to 20 character long.!" }
  validates :role, inclusion: { in: ROLES, message: "Invalide role.!" }
  def self.find_for_database_authentication(warden_conditions)
    data = warden_conditions[:login]
    where("username = :data OR email = :data", { data: data }).first
  end
  def admin?
    self.role == "admin"
  end
  def user?
    self.role == "user"
  end
end
