ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "soundmelon-stg.com",
#   :user_name            => "miniflckr.mailer@gmail.com",
#   :password             => "secretsauce",
#   :authentication       => "plain",
  :enable_starttls_auto => true
}

ActionMailer::Base.default_url_options[:host] = ENV['HOST_ADDR'].split('http://')[1]
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
