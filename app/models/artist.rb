class Artist < ActiveRecord::Base
  attr_accessible :artist_name, :youtube_token, :soundcloud_token, :artist_photo,
									:website, :city, :genre_tags, :facebook_link, :twitter_link, :itunes_link
	
	before_save :record_city
	
	has_attached_file :artist_photo,
		storage: :dropbox,
		dropbox_credentials: Rails.root.join("config/dropbox.yml"),
		styles: {medium: "300x300", thumb: "100x100"},
		dropbox_options: {
      path: proc { |style| "#{style}/#{id}_#{artist_photo.original_filename}" }
    },
		default_url: "/assets/artist-default.jpg"
	belongs_to :user
	has_many :song, dependent: :destroy
	has_many :reports, as: :reportable #Allow Song to be reported
	serialize :youtube_token
	serialize :soundcloud_token
	serialize :genre_tags
	
	private
		def record_city
			self.city = self.user.city
			self.city_coords = self.user.city_coords
		end
end
