# encoding: utf-8
module ApplicationHelper
BODY_CLASS = {
  "/admin/account" => "admin account",
  "/client/top" => "client top",
  "/client/account" => "client account",
  "/partner/top" => "partner top",
  "/partner/account" => "partner account"
}.freeze

  def publish_tag(publish)
    <<-EOS
        <script src="https://#{BACKEND_HOST}/impression?pid=#{publish.id}"></script>
        <a href="#{publish.promotion.url}" onClick="return sendUrl#{publish.id}();">リンクの対象</a>
    EOS
  end

  def publish_click_url(publish)
    <<-EOS
        https://#{BACKEND_HOST}/click?pid=#{publish.id}
    EOS
  end

  def image_banner_url(banner)

  end

  def banner_click_tag(publish, banner)
    case banner.type
    when 'ImageBanner'
      material = <<-EOS
        <img src="https://#{FRONTEND_HOST + banner.image.url}" alt="#{banner.name}" />
      EOS
    when 'TextBanner'
      material = banner.text
    end
    <<-EOS
    <script src="https://#{BACKEND_HOST}/impression?pid=#{publish.id}&bid=#{banner.id}"></script>
    <a href="#{publish.promotion.url}" onClick="return sendUrl#{publish.id}_#{banner.id}();">
      #{material}
    </a>
    EOS
  end

  def body_class
    #/client界面のcontrollerはclient/clientです、しかしcssの中にbody class = "client client mask"ではなくて、body class = "client top"欲しいです。
    #/client/accountのbody_classは"client account"欲しいです。
    #partnerもそのようなです。
    BODY_CLASS[request.fullpath].nil? ? "#{params[:controller].split("/").first} #{params[:controller].split("/").last}" : BODY_CLASS[request.fullpath]
  end

  def td_active?(model)
    model.active? ? "<span class=\"active\">有効</span>" : "<span class=\"inactive\">無効</span>"
  end

  # bodyにconsigned_workクラスを追加するためのヘルパー
  # コントローラーでdeclare_consigned_work!を呼び出していたら、trueを返す
  def consigned_work?
    # @consigned_workは コントローラで
    # declare_consigned_work! 呼び出したらtrueになる。
    !!@consigned_work
  end 
end