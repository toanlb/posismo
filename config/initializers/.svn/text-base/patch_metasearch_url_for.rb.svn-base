####
# MetaSearchにて並び替えが発生したときの記号（&#9650;）をCSSにて画像に変更するため
# HTMLタグ（<span></span>）を表示させるようpatchをあてる。

module MetaSearch::Helpers::UrlHelper
  def order_indicator_for(order)
    if order == 'asc'
      '<span>&#9650;</span>'
    elsif order == 'desc'
      '<span>&#9660;</span>'
    else
      nil
    end
  end
end

