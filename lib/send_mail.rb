def send_mail(config_path, subject, body)
  config = YAML.load_file(config_path).symbolize_keys[ENVIRONMENT.to_sym]
  raise if config.nil?


  mail = Mail.new do
    from config[:from]
    to config[:to]
    subject subject
    body body
  end

  mail.charset = 'utf-8'
  mail.delivery_method :smtp, config[:smtp_settings]

  mail.deliver!
end
