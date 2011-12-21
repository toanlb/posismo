# -*- coding: utf-8 -*-
class AdminNotifier < ActionMailer::Base
  default :from => "system@2pm.jp"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.admin_notifier.partner_registered.subject
  #
  def partner_registered(admin, partner)
    @partner = partner
    @subject = "パートナー#{partner.login_id}が作成されました。"

    unless admin.email.blank?
      mail(:to => admin.email,
           :subject => @subject) do |format|
        format.text
      end
    end
  end

  def notify_promotion_to_partner(promotion, partners)
    content = promotion.name+"が削除されました"
    partners.each do |partner|
      mail(:to => partner.email) do |format|
        format.text {render :text => content}
      end
      #mail(:to => 'jyouji.urano@itokuro.jp') do |format|
      #  format.text { render :text => content}
      #end
    end
  end

  def notify_error(admin, subject, content)
    unless admin.email.blank?
      mail(:to => admin.email, :subject => subject) do |format|
        format.text{render :text => content}
      end
    end
  end
end
