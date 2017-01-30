class User < ActiveRecord::Base
    has_many :devices
    has_many :tasks
end
