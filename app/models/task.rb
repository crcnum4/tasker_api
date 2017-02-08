class Task < ActiveRecord::Base
    belongs_to :users
    
    scope :created_between, lambda {|start_date| where("created_at >= ? AND created_at <= ?", start_date, Time.now.getlocal() )}
    
    def as_json(options={})
        super(:only => [:name, :created_at, :id])
    end
end
