class CreatePartners < ActiveRecord::Migration
  def self.up
    create_table :partners do |t|
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
      t.confirmable

      ## 認証アタック防止
      ## apply_devise_schema :failed_attempts, Integer, :default => 0
      ## apply_devise_schema :unlock_token, String
      ## apply_devise_schema :locked_at, DateTime
      t.lockable
      
      ## パスワード再設定
      ## apply_devise_schema :reset_password_token
      t.recoverable
           
      #基本情報     
      t.integer :registration_status, :default => 0, :null => false #登録状態 (仮登録, 承認, 非承認)
      #t.integer :partner_type #グループ (テスト、イトクロ媒体, ポイントサイト)
      t.string :media_type #媒体種類 ［Webサイト, メールマガジン]
      t.integer :contract_type, :default => 0 # 契約種別　[法人, 個人]
      t.string :company_name #社名 ※法人の場合
      t.string :company_name_kana #社名（フリガナ） ※法人の場合
      t.string :contractor_department #契約者部署 ※法人の場合
      t.string :contractor_position #契約者役職 ※法人の場合
      t.string :contractor_name #契約者名 ※法人の場合
      t.string :contractor_name_kana #契約者名(フリガナ) ※法人の場合
      t.string :manager_department #担当者部署 ※法人の場合
      t.string :manager_position #担当者役職 ※法人の場合
      t.string :manager_name, :default => "", :null => false #※担当者名
      t.string :manager_name_kana, :default => "", :null => false #※担当者名（フリガナ）
      t.string :postal_code #郵便番号
      t.string :address #住所
      t.string :tel #電話番号
      
      #支払先情報
      t.integer :payment_type, :default => 0 #支払先種別（銀行, 郵便局, 請求書送付）
      #銀行
      t.string :bank_name #銀行名
      t.string :bank_code #金融機関コード（4桁）
      t.string :branch_name #支店名
      t.string :branch_code #支店コード（3桁）
      t.string :account_type #口座種別 (普通, 当座)
      t.string :account_number #口座番号（7桁）
      t.string :account_name #口座名義
      #郵便局
      t.string :jpbank_account_number #ゆうちょ銀行口座番号
      t.string :jpbank_account_name #ゆうちょ銀行口座名義
      
      #その他
      t.text :memo #備考
      
      #登録承認
      t.boolean :active, :default => false
      
      #削除FLAG
      t.boolean :deleted, :default => false
      t.timestamps
      
    end
    
  end

  def self.down
    drop_table :partners
  end
end
