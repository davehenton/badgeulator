class AddAttachmentLogoToArtifacts < ActiveRecord::Migration
  def self.up
    change_table :artifacts do |t|
      t.attachment :logo
    end
  end

  def self.down
    remove_attachment :artifacts, :logo
  end
end
