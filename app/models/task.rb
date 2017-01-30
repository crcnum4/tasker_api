class Task < ActiveRecord::Base
    belongs_to :users
    
    def as_json(options={})
        super(:only => [:name, :created_at])
    end
end
