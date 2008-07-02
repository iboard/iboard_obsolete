class ShopItemsController < ApplicationController

  include ActiveMerchant::Billing::Integrations
  require 'crypto42'
  require 'money'

  def index
    if not params[:shop]
      @shop_items = ShopItem.find(:all)
    else
      @shop = Shop.find(params[:shop]) 
      @shop_items = ShopItem.find_all_by_shop_id(params[:shop])
    end
  end

  def new
    @shop_item = ShopItem.new
    @shop_item.shop = Shop.find(params[:shop])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @shop_item }
    end
  end

  def create
    @shop_item = ShopItem.new(params[:shop_item])

    respond_to do |format|
      if @shop_item.save
        flash[:notice] = _('Item was successfully created.')
        format.html { redirect_to(@shop_item) }
        format.xml  { render :xml => @shop_item, :status => :created }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @shop_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def edit
    @shop_item = ShopItem.find(params[:id])
  end
  
  def update
    @shop_item = ShopItem.find(params[:id])

    respond_to do |format|
      if @shop_item.update_attributes(params[:shop_item])
        flash[:notice] = _('Item was successfully updated.')
        format.html { redirect_to(@shop_item) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @shop_item.errors, :status => :unprocessable_entity }
      end
    end  end

  def destroy
    @shop_item = ShopItem.find(params[:id])
    @shop_item.destroy

    respond_to do |format|
      format.html { redirect_to(shop_items_url) }
      format.xml  { head :ok }
    end
  end

  def show
    @shop_item = ShopItem.find(params[:id])
  end
  
  def buy
    @shop_item = ShopItem.find(params[:id])
    if @shop_item.stock < 1
      flash[:error] = _('Sorry, this item sold out')
      redirect_to(@shop_item.shop)
    end
    fetch_decrypted(
         @shop_item.title, "#{@shop_item.id.to_s}", @shop_item.price,"1", "EUR",
         _('Thank you!'), wait_paypal_url, (@shop_item.delivery_type == 0 ? "1" : "0" )
    )
  end
  
 
  def update_paypal_form
       
       @shop_item = ShopItem.find(params[:id])
       
       count = params[:count].to_i || 1
       if count > @shop_item.stock
         count = @shop_item.stock
       end
       total = count * @shop_item.price
       fetch_decrypted(
            @shop_item.title, "#{@shop_item.id.to_s}", @shop_item.price,count.to_s, "EUR",
            _('Thank you!'), wait_paypal_url, (@shop_item.delivery_type == 0 ? "1" : "0" )
       )
       
       new_html = "<input id='encrypted' type='hidden' name='encrypted' value='#{@encrypted_basic}' />"+
                  '<p>' +
                    _('Total price') + ':' + 
                    " <span style='display: inline;' id='total'>#{total}</span> EUR" +
                  '</p>'
                  
       if params[:count] != count.to_s
         new_html += " " + _('Sorry, only %d item(s) on stock.') % @shop_item.stock
       end
       
       render :text => new_html
   end


   private
     def fetch_decrypted(item_name, item_number, amount,count,currency, custom,return_to,no_shipping="1")

       # cert_id is the certificate if we see in paypal when we upload our own certificates
       # cmd _xclick need for buttons
       # item name is what the user will see at the paypal page
       # custom and invoice are passthrough vars which we will get back with the asunchronous
       # notification
       # no_note and no_shipping means the client want see these extra fields on the paypal payment
       # page
       # return is the url the user will be redirected to by paypal when the transaction is completed.
       decrypted = {
         "cert_id" => "#{PAYPAL_CERT_ID}",
         "cmd" => "_xclick",
         "business" => "#{PAYPAL_BUSINESS_ACCOUNT}",
         "item_name" => "#{item_name}",
         "item_number" => "#{item_number}",
         "quantity" => "#{count}",
         "custom" =>"#{custom}",
         "amount" => "#{amount}",
         "currency_code" => "#{currency}",
         "country" => "#{PAYPAL_COUNTRY}",
         "no_note" => "1",
         "no_shipping" => no_shipping,
       }

       decrypted.merge!("invoice" => "#{DateTime::now}", "return" => "#{return_to}")

       @encrypted_basic = Crypto42::Button.from_hash(decrypted).get_encrypted_text


       @action_url = ENV['RAILS_ENV'] == "production" ? "https://www.paypal.com/at/cgi-bin/webscr" : 
                                                        "https://www.sandbox.paypal.com/uk/cgi-bin/webscr"
   end
end
