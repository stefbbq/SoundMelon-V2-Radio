class Artist < ActiveRecord::Base
  attr_accessible :artist_name, :youtube_token, :soundcloud_token, :artist_photo,
									:website, :biography
	has_attached_file :artist_photo,
		storage: :dropbox,
		dropbox_credentials: Rails.root.join("config/dropbox.yml"),
		styles: {medium: "300x300>", thumb: "100x100>"},
		default_url: "/assets/core/footer_logo.png"
	belongs_to :user
	has_many :artist_upload, dependent: :destroy
	serialize :youtube_token
	serialize :soundcloud_token
end
