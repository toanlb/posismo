# -*- coding: utf-8 -*-
class PartnerNotifier < ActionMailer::Base
  default :from => "system@2pm.jp"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.partner_notifier.test.subject
  #
  def test
    @greeting = "Hi"
    mail :to => "hyungjin@itokuro.jp"
  end

  def resign_notify(partner)
    mail(:to => 'jyouji.urano@itokuro.jp') do |format|
      format.text
    end
    #mail(:to => partner.email) do |format|
    #  format.text
    #end
  end

  def notify_to_admin(admin, partner ,change_datas)
    content = ""
    change_datas.each {|key,val|
      content = content+Partner.human_attribute_name(key)+"が#{val[0]}から#{val[1]}に変更されました。\n"
    }

    mail(:to => admin.email,:subject => partner.login_id+"の情報が変更されました。") do |format|
      format.text { render :text => content }
    end
    # mail(:to => admin.email,:subject => partner.login_id) do |format|
      # format.text
    # end
  end
end
