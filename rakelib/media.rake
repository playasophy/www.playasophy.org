# Tasks for interacting with media files stored in S3.

require 'aws-sdk-core'
require 'digest/md5'
require 'mime/types'
require 'paint'
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
        yield object unless object[:key].end_with? '/'
      end
    else
      objects.concat(resp.contents.reject{|object| object[:key].end_with? '/' })
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
    "media/#{prefix}*"
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
      local_file = media[path][:local]
      s3_object = media[path][:s3]

      # This shouldn't happen.
      if local_file.nil? && s3_object.nil?
        raise "Local file and S3 object should not both be nil!"

      # The file is available in both locations.
      elsif local_file && s3_object
        etag = s3_object[:etag]
        etag = etag && etag.slice(1, etag.length - 2)

        # The files' size differs.
        if local_file[:size] != s3_object[:size]
          message = "%-50s size mismatch! local: %d bytes / s3: %d bytes" % [path, local_file[:size], s3_object[:size]]
          puts Paint[message, :yellow]

        # The files' hash differs.
        elsif local_file[:md5] != etag
          message = "%-50s hash mismatch! local: %s / s3: %s" % [path, local_file[:md5], etag]
          puts Paint[message, :yellow]

        # The file matches in both locations.
        else
          puts Paint[path, :green]
        end

      # The file is present locally but not in S3.
      elsif local_file
          message = "%-50s local only" % path
          puts Paint[message, :red]

      # The file is present in S3 but not locally.
      elsif s3_object
          message = "%-50s S3 only" % path
          puts Paint[message, :red]
      end
    end
  end

  desc "Downloads media files from S3 for local development"
  task :pull, [:prefix] => :configure do |t, args|
    media = collect_media(args[:prefix])

    media.keys.sort.each do |path|
      s3_object = media[path][:s3]
      local_file = media[path][:local]

      if s3_object && local_file.nil?
        puts "%-50s %10d bytes" % [path, s3_object[:size]]
        target = "media/#{path}"
        target_dir = File.dirname(target)
        mkdir_p target_dir unless File.directory? target_dir
        $s3_client.get_object({bucket: $s3_bucket, key: "media/#{path}"}, target: target)
      end
    end
  end

  desc "Uploads local media files to S3"
  task :push, [:prefix] => :configure do |t, args|
    media = collect_media(args[:prefix])

    media.keys.sort.each do |path|
      s3_object = media[path][:s3]
      local_file = media[path][:local]

      if local_file && s3_object.nil?
        content_type = MIME::Types.type_for(path).first
        puts "%-50s %10d bytes [%s]" % [path, local_file[:size], content_type]
        $s3_client.put_object(
          bucket: $s3_bucket,
          key: "media/#{path}",
          body: File.new(local_file[:path]),
          content_type: content_type && content_type.to_s
        )
      end
    end
  end
end
