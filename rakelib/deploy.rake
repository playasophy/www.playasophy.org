# Tasks for deploying the website.

namespace :deploy do
  desc "Deploy the website using the s3_website gem"
  task :s3 do |t|
    system "s3_website push"
    fail unless $?.success?
  end
end
