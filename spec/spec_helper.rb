require 'simplecov-cobertura'
require 'simplecov-json'

ENV['JETS_TEST'] = "1"
ENV['JETS_ENV'] ||= "test"
# Ensures aws api never called. Fixture home folder does not contain ~/.aws/credentails
ENV['HOME'] = "spec/fixtures/home"

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::CoberturaFormatter,
  SimpleCov::Formatter::JSONFormatter
])

SimpleCov.minimum_coverage 95
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/config/"
end

require "byebug"
require "fileutils"
require "jets"

abort("The Jets environment is running in production mode!") if Jets.env == "production"
Jets.boot

require "jets/spec_helpers"

ENV['AWS_REGION'] = 'us-east-1'

module Helpers
  
  def clean
    s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    bucket_name = ENV['BUCKET_NAME']    
    bucket = s3.bucket(bucket_name)    
    bucket.objects.each do |obj|
      obj.delete
    end
  end
  
  def payload(name)
    JSON.load(IO.read("spec/fixtures/payloads/#{name}.json"))
  end

  def open_img_fixture(name)
    image_data = File.open("spec/fixtures/#{name}.jpg", 'rb') { |file| file.read }
    base64_data = "data:image/jpeg;base64," + Base64.encode64(image_data)
    base64_data
  end

  def open_video_fixture(name)
    image_data = File.open("spec/fixtures/#{name}.mp4", 'rb') { |file| file.read }
    base64_data = "data:video/mp4;base64," + Base64.encode64(image_data)
    base64_data
  end

end

RSpec.configure do |c|
  c.include Helpers
end
