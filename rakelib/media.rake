# Tasks for interacting with media files stored in S3.

require 'aws-sdk-core'
require 'digest/md5'
require 'yaml'


# Lists objects in S3 matching the given prefix (under 'media/'). If a block is
# given, it is called with every object. Otherwise, returns an array of objects.
def list_objects(prefix="")
  prefix = "media/#{prefix}"
  puts "Listing media files in s3://#{$s3_bucket}/#{prefix}"

  objects = []
  $s3_client.list_objects(bucket: $s3_bucket, prefix: prefix).each do |resp|
    if block_given?
      resp.contents.each do |object|
        yield object
      end
    else
      objects.concat(resp.contents)
    end
  end
  objects unless block_given?
end


# Lists files in the project media directory matching the given prefix.
def list_files(prefix="")
  glob = if prefix.nil? || prefix.empty?
    "media/**/*"
  elsif prefix.end_with? '/'
    "media/#{prefix}**/*"
  else
    "media/#{prefix}*/**/*"
  end

  puts "Listing local files matching #{glob}"

  Dir[glob].select{|path| File.file? path }.map do |path|
    {
      path: path,
      size: File.size(path),
      md5: Digest::MD5.hexdigest(File.read(path))
    }
  end
end


# Collects local and S3 media into a combined hash.
def collect_media(prefix="")
  media = {}

  s3_media = list_objects(prefix)
  puts "Found #{s3_media.count} objects"
  s3_media.each do |object|
    path = object[:key].slice(6, object[:key].length)
    media[path] ||= {}
    media[path][:s3] = object
  end

  local_media = list_files(prefix)
  puts "Found #{local_media.count} files"
  local_media.each do |file|
    path = file[:path].slice(6, file[:path].length)
    media[path] ||= {}
    media[path][:local] = file
  end

  media
end


namespace :media do
  # Loads S3 configuration from the s3_website settings file and initializes
  # global variables to store an S3 client and the website bucket name.
  task :configure do |t|
    config = YAML.load_file('s3_website.yml')
    $s3_client = Aws::S3.new(region: config['s3_endpoint'])
    $s3_bucket = config['s3_bucket']
  end

  desc "Shows differences between the media available locally and in S3"
  task :diff, [:prefix] => :configure do |t, args|
    media = collect_media(args[:prefix])
    media.keys.sort.each do |path|
      puts "#{path}\n    #{media[path][:s3].inspect}\n    #{media[path][:local].inspect}"
    end
  end

  desc "Downloads missing media files from S3 for local development"
  task :pull, [:prefix] => :configure do |t, args|
    # list local media files (under prefix)
    # enumerate media files in bucket (under prefix)
    # download each remote file not present locally
  end

  desc "Uploads local media files to S3"
  task :push, [:prefix] => :configure do |t, args|
    s3_media = list_objects(args[:prefix])
    puts "Found #{s3_media.count} objects"
    puts s3_media.inspect

    local_media = list_files(args[:prefix])
    puts "Found #{local_media.count} files"
    puts local_media.inspect

    # upload each local file not present in bucket
  end
end
