class Client::OneTagsController < Admin::OneTagsController
  layout 'client'

  skip_before_filter :authenticate_admin!
  skip_before_filter :authority_required
  before_filter :authenticate_client!
  before_filter :find_client
  before_filter :find_promotion
  before_filter :client_consigned!

protected
  def find_client
     @client = current_client
  end
  
  def client_consigned!
    if current_client.consigned 
      raise ActiveRecord::RecordNotFound
    end
  end
end
