# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false
#config.action_view.cache_template_extensions         = false

# care if the mailer can't send
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp

# Config for local testing and mailing through my ib1
config.action_mailer.smtp_settings = {
  :address => '88.198.11.47',
  :port    => 25,
  :domain  => 'ib1.iboard.cc',
  :authentication => :plain,
  :user_name => '*smpt*user*here*',
  :password  => '*your*secret*here*'
}

REGISTRATION_COPY_TO_ADDRESS='andreas@altendorfer.at'
REGISTRATION_FROM_ADDRESS='webmaster@iboard.cc'
REGISTRATION_DOMAIN_NAME='iBoard.cc'
REGISTRATION_HOST_PREFIX='http://nockenfell.local/iboard'


TICKET_COPY_TO_ADDRESS="andreas@altendorfer.at"
TICKET_FROM_ADDRESS="office@iboard.cc"
TICKET_RESERVATION_FOOTER="-- iBoard Event Portal (office@iboard.cc)"


# PAYPAL INTEGRATION

PAYPAL_PUB_CERT="iboard.cc.pubcert.pem"
PAYPAL_PRV_KEY="iboard.cc.priv.pem"
PAYPAL_CERT="paypal_cert_sandbox.pem"
PAYPAL_CERT_ID="*YOUR*CERT*ID*HERE*"
PAYPAL_BUSINESS_ACCOUNT="office_1214412127_biz@iboard.cc"
PAYPAL_COUNTRY="DE"
PAYPAL_NOTIFICATION_ADDRESS="andreas@altendorfer.at"

# Ensure the gateway is in test mode
ActiveMerchant::Billing::Base.gateway_mode = :test
ActiveMerchant::Billing::Base.integration_mode = :test
ActiveMerchant::Billing::PaypalGateway.pem_file =
                File.read(File.dirname(__FILE__) + '/../../paypal/paypal_cert.pem')
