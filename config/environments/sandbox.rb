Jets.application.configure do
  # Example:
  # config.function.memory_size = 1536

  # config.action_mailer.raise_delivery_errors = false
  # Docs: http://rubyonjets.com/docs/email-sending/

  config.function.vpc_config = {
    security_group_ids: %w[sg-079357cc725c0c697],
    subnet_ids: %w[subnet-0091648c2908cd452 subnet-0f6fe007158c0f29f],
  }
  
  config.domain.hosted_zone_name = "sbx.rvhub.com.br."
  config.domain.name = "api.sbx.rvhub.com.br"
  config.domain.cert_arn = "arn:aws:acm:us-east-1:138913610205:certificate/db988a66-d6af-44a9-b3b7-d0bac844c83a"
  config.domain.base_path = "facial-recognition"
end
