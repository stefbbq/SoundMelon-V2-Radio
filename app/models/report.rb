class Report < ActiveRecord::Base
	attr_accessible :title, :content, :reportable_type, :reportable_id
	belongs_to :reportable, polymorphic: true
	belongs_to :user

	validates :title, :presence => true
	validates_uniqueness_of :user_id, scope: [:reportable_type, :reportable_id]
end
