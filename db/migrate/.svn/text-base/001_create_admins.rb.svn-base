class CreateAdmins < ActiveRecord::Migration
  def self.up
    create_table :admins do |t|
      # Columns for Devise
      ## 基本ログイン情報
      ## t.string :login_id, :null => false, :unique => true  # LoginID
      ## t.string :email
      ## t.string :encrypted_password
			## t.string :password_salt
      t.database_authenticatable
      
      ## ログイン履歴追跡
      ## apply_devise_schema :sign_in_count,      Integer, :default => 0
      ## apply_devise_schema :current_sign_in_at, DateTime
      ## apply_devise_schema :last_sign_in_at,    DateTime
      ## apply_devise_schema :current_sign_in_ip, String
      ## apply_devise_schema :last_sign_in_ip,    String
      t.trackable
      
      ## メールアドレス確認
      ## apply_devise_schema :confirmation_token,   String
      ## apply_devise_schema :confirmed_at,         DateTime
      ## apply_devise_schema :confirmation_sent_at, DateTime
			t.confirmable
			      
      ## 認証アタック防止
      ## apply_devise_schema :failed_attempts, Integer, :default => 0
      ## apply_devise_schema :unlock_token, String
      ## apply_devise_schema :locked_at, DateTime
      t.lockable

      #ユーザ氏名
      t.string :name, :null => false
      
      #スーパーユーザFLAG
      t.boolean :super_user, :default => false
      
      #削除FLAG
      t.boolean :deleted, :default => false
      
      t.timestamps
     
    end
    
  end

  def self.down
    drop_table :admins
  end
end
