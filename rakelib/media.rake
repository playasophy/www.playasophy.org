# Tasks for interacting with media files stored in S3.

require 'aws-sdk-core'
require 'yaml'


# Loads S3 configuration from the s3_website settings file and initializes an
# S3 client. Returns the client and the website bucket name.
def init_s3
  config = YAML.load_file('s3_website.yml')
  client = Aws::S3.new(region: config['s3_endpoint'])
  [client, config['s3_bucket']]
end


namespace :media do
  desc "Downloads missing media files from S3 for local development"
  task :pull, :prefix do |t, args|
    s3, bucket = init_s3
    # list local media files (under prefix)
    # enumerate media files in bucket (under prefix)
    # download each remote file not present locally
  end

  desc "Uploads local media files to S3"
  task :push, :prefix do |t, args|
    prefix = "media/#{args[:prefix]}"
    prefix += '/' unless prefix.end_with? '/'

    s3, bucket = init_s3
    url = "s3://#{bucket}/#{prefix}"

    puts "Listing media files in #{url}"
    bucket_media = []
    s3.list_objects(bucket: bucket, prefix: prefix).each do |resp|
      bucket_media.concat(resp.contents)
      resp.contents.each{|object| puts object.key }
    end
    puts "Found #{bucket_media.count} objects"

    # enumerate local media files (under prefix)
    puts "Enumerating local files in #{prefix}"

    # upload each local file not present in bucket
  end
end
