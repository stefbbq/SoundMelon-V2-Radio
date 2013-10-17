class Artist < ActiveRecord::Base
  attr_accessible :artist_name, :youtube_token, :soundcloud_token, :artist_photo,
									:website, :biography, :genre_tags
	has_attached_file :artist_photo,
		storage: :dropbox,
		dropbox_credentials: Rails.root.join("config/dropbox.yml"),
		styles: {medium: "300x300", thumb: "100x100"},
		dropbox_options: {
      path: proc { |style| "#{style}/#{id}_#{artist_photo.original_filename}" }
    },
		default_url: "/assets/core/footer_logo.png"
	belongs_to :user
	has_many :song, dependent: :destroy
	has_many :reports, as: :reportable #Allow Song to be reported
	serialize :youtube_token
	serialize :soundcloud_token
	serialize :genre_tags
end
