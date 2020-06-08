if Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp

  ActionMailer::Base.smtp_settings = {
      domain:               'smtp.sendgrid.net',
      enable_starttls_auto: true,
      address:              "smtp.sendgrid.net",
      port:                 587,
      authentication:       :login,
      user_name:            ENV['SENDGRID_USERNAME'],
      password:             ENV['SENDGRID_PASSWORD'],
  }

elsif Rails.env.development?
  ActionMailer::Base.perform_caching = true
  ActionMailer::Base.delivery_method = :letter_opener_web
else
  ActionMailer::Base.delivery_method = :test
end
