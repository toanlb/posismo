class CreateClients < ActiveRecord::Migration
  def self.up
    create_table :clients do |t|
      # Columns for Devise
      ## 基本ログイン情報
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
			#t.confirmable
			      
      ## 認証アタック防止
      ## apply_devise_schema :failed_attempts, Integer, :default => 0
      ## apply_devise_schema :unlock_token, String
      ## apply_devise_schema :locked_at, DateTime
      t.lockable
      
      ## パスワード再設定
      ## apply_devise_schema :reset_password_token
      t.recoverable
      
      #基本情報
      t.boolean :consigned, :default => false #受託クライアントFALG
      t.integer :registration_status, :default => 0 #登録状態 (仮登録, 承認, 非承認)
      t.string :site_name #サイト名
      t.string :site_url #サイトURL
      t.string :company_name #会社名
      t.string :company_name_kana #会社名（フリガナ）
      t.string :contractor_department #契約者部署
      t.string :contractor_position #契約者役職
      t.string :contractor_name #契約者名
      t.string :contractor_name_kana #契約者名(フリガナ)
      t.string :manager_department #担当者部署
      t.string :manager_position #担当者役職
      t.string :manager_name #担当者名
      t.string :manager_name_kana #担当者名（フリガナ）
      t.string :postal_code #郵便番号
      t.string :address #住所
      t.string :tel #電話番号
      
      #その他
      t.text :memo #備考            
      
      #登録承認
      t.boolean :activated, :default => false
       
      #削除FLAG
      t.boolean :deleted, :default => false 

      t.timestamps
      
    end
    
  end

  def self.down
    drop_table :clients
  end
end
