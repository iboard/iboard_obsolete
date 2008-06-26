# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# care if the mailer can't send
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp

# Config for local testing and mailing through my ib1
config.action_mailer.smtp_settings = {
  :address => 'ib1.iboard.cc',
  :port    => 25,
  :domain  => 'ib1.iboard.cc',
  :authentication => :plain,
  :user_name => '*smptp*user*here*',
  :password  => '*your*secret*here*'
}


REGISTRATION_COPY_TO_ADDRESS='andreas@altendorfer.at'
REGISTRATION_FROM_ADDRESS='webmaster@iboard.cc'
REGISTRATION_DOMAIN_NAME='iBoard.cc'
REGISTRATION_HOST_PREFIX='http://iboard.cc/iboard'


TICKET_COPY_TO_ADDRESS="andreas@altendorfer.at"
TICKET_FROM_ADDRESS="webmaster@iboard.cc"
TICKET_RESERVATION_FOOTER="-- iBoard Event Portal (office@iboard.cc)"

# PAYPAL INTEGRATION

PAYPAL_PUB_CERT="iboard.cc.pubcert.pem"
PAYPAL_PRV_KEY="iboard.cc.priv.pem"
PAYPAL_CERT="paypal_cert.pem"
PAYPAL_CERT_ID="*your*cert*id*here*"
PAYPAL_BUSINESS_ACCOUNT="office@iboard.cc"
PAYPAL_COUNTRY="AT"
PAYPAL_NOTIFICATION_ADDRESS="andreas@altendorfer.at"

# Ensure the gateway is in test mode
ActiveMerchant::Billing::Base.gateway_mode = :production
ActiveMerchant::Billing::Base.integration_mode = :production
ActiveMerchant::Billing::PaypalGateway.pem_file =
                File.read(File.dirname(__FILE__) + '/../../paypal/paypal_cert.pem')
  
