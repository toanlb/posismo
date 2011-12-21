require 'csv'
class Client::PublishesController < Admin::PublishesController
  layout 'client'

  before_filter :authenticate_client!
  skip_before_filter :authority_required
  skip_before_filter :authenticate_admin!

protected
  def find_client
    @client = current_client
  end

  def csv_name
    "#{params[:controller]}.csv"
  end
end