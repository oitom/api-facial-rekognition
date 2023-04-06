Jets.application.configure do
  # Example:
  # config.function.memory_size = 1536

  # config.action_mailer.raise_delivery_errors = false
  # Docs: http://rubyonjets.com/docs/email-sending/

  config.function.vpc_config = {
    security_group_ids: %w[sg-079357cc725c0c697],
    subnet_ids: %w[subnet-0bec0a694d9cb1e25 subnet-0115acf8338db9fd0],
  }

  config.domain.hosted_zone_name = "dev.rvhub.com.br."
  config.domain.name = "api.dev.rvhub.com.br"
  config.domain.cert_arn = "arn:aws:acm:us-east-1:138913610205:certificate/72625c73-f6f6-48e4-9afc-24902f07a13a"
  config.domain.base_path = "facial-recognition"
  
end
