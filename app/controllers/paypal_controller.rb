class PaypalController < ApplicationController

  include ActiveMerchant::Billing::Integrations
  require 'crypto42'
  require 'money'


  protect_from_forgery :except => [:wait, :ipn, :thanks_for_donation]
  
  
  def thanks_for_donation
  end
  
  def wait
    @transaction = Payment.new
    if params[:txn_id]
      @transaction.txn_id = params[:txn_id]
    else
      @transaction.txn_id = params[:tx]
    end      
    @transaction.notification = request.raw_post
  end
  
  def update_wait
    @transaction = Payment.find(:first, :conditions => [ "txn_id = ?", params[:txn_id] ] )
    if @transaction 
      begin
        @notify = Paypal::Notification.new(@transaction.notification)
      rescue
        @notify = nil    
      end
      render :layout => false
    else
      render :text => _('Transaction "%{txn_id}" not found (waiting %{date})') % {:txn_id => params[:txn_id], :date => DateTime::now.to_s}, :layout => false
    end
  end
  
  def ipn
     # Create a notify object we must
     begin
       notify = Paypal::Notification.new(request.raw_post)
    
       #we must make sure this transaction id is not allready completed
       if !Payment.count("*", :conditions => ["txn_id = ?", notify.transaction_id]).zero?
          Log::log('Transaction already stored',1,'system',request.env['REMOTE_ADDR'])
       else
         UserMailer.deliver_paypal_notification(PAYPAL_NOTIFICATION_ADDRESS,notify,request.env['SERVER_NAME'])
    
         @transaction = Payment.create(:txn_id => notify.transaction_id, :notification => request.raw_post)
         @transaction.save!
         
         Log::log('Transaction saved '+ @transaction.txn_id ,1,'system',request.env['REMOTE_ADDR'])
       end
     rescue => e
       Log::log('ipn failed '+ e.inspect + "\n" + params.inspect ,1,'system',request.env['REMOTE_ADDR'])
     end
     render :nothing => true
   end
  
  
  def donate
    
    fetch_decrypted(_('Donation for iboard.cc'), "#{_('Donation')} #{DateTime::now()}", "10", "EUR",
                    _('Thank you for donating to iboard.cc!'),
                    thanks_for_donation_url )
  
    render(:action => "donate")
    return
  end
  
  def change_amount
      fetch_decrypted(_('Donation for iboard.cc'), "#{_('Donation')} #{DateTime::now()}", params[:amount], "EUR",
                      _('Thank you for donating to iboard.cc!'),
                      thanks_for_donation_url )
      render :text => "<input id='encrypted_basic' type='hidden' name='encrypted' value='#{@encrypted_basic}' />"
  end
  
  
  private
    def fetch_decrypted(item_name, item_number, amount,currency, custom,return_to,shipping="1")
  
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
        "custom" =>"#{custom}",
        "amount" => "#{amount}",
        "currency_code" => "#{currency}",
        "country" => "#{PAYPAL_COUNTRY}",
        "no_note" => "1",
        "no_shipping" => shipping,
      }
  
      decrypted.merge!("invoice" => "#{DateTime::now}", "return" => "#{return_to}")
      
      @encrypted_basic = Crypto42::Button.from_hash(decrypted).get_encrypted_text
      
  
      @action_url = ENV['RAILS_ENV'] == "production" ? "https://www.paypal.com/at/cgi-bin/webscr" : 
                                                       "https://www.sandbox.paypal.com/uk/cgi-bin/webscr"
  end
end

