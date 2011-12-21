class AlterParameters < ActiveRecord::Migration
  def self.up
    rename_column :parameters, :metadata_flg, :data_flg
  end

  def self.down
    rename_column :parameters, :metadata_flg, :data_flg
  end
end
