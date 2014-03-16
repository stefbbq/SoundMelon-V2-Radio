class BlockedUpload < ActiveRecord::Base
   attr_accessible :song_id, :upload_source
end
