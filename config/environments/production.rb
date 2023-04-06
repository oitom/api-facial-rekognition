Jets.application.configure do
  # Example:
  # config.function.memory_size = 2048

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # Docs: http://rubyonjets.com/docs/email-sending/
  # config.action_mailer.raise_delivery_errors = false

  config.function.vpc_config = {
    security_group_ids: %w[sg-0fd20ef9d751ed2e6],
    subnet_ids: %w[subnet-01e8a49551acbc4cc subnet-032d11aaf773c43c1],
  }

  config.domain.hosted_zone_name = "rvhub.com.br."
  config.domain.name = "api.rvhub.com.br"
  config.domain.cert_arn = "arn:aws:acm:us-east-1:744843104550:certificate/48c05076-c355-4cde-a0a2-664d0a67cbaf"
  config.domain.base_path = "facial-recognition"
end
