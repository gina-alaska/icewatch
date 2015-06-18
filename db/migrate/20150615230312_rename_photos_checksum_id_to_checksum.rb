class RenamePhotosChecksumIdToChecksum < ActiveRecord::Migration
  def change
    rename_column :photos, :checksum_id, :checksum
  end
end
