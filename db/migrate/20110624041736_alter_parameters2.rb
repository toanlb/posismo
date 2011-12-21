class AlterParameters2 < ActiveRecord::Migration
  def self.up
    rename_column :parameters, :data_flg, :metadata_flg
  end

  def self.down
    rename_column :parameters, :metadata_flg, :data_flg
  end
end
