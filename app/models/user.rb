class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :recoverable, :confirmable, :lockable, :rememberable, :recoverable and :omniauthable
  devise :magic_link_authenticatable, :validatable, :timeoutable , :trackable
end
