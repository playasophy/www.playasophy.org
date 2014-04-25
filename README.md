Playasophy Website
==================

This repo contains an [Octopress](http://octopress.org/) website for the
[Playasophy](http://www.playasophy.org/) Burning Man camp.

## Working With the Website

The website uses the `rake` command-line build tool. This is based on the Ruby
programming language. The general invocation is `rake <task>`. Use `rake -T` for
a list of available tasks to run.

### AWS Credentials

To interact with S3 and deploy the website, you'll need AWS credentials. The
easiest way to use these is to create a script file which runs Rake with the
credentials as environment variables:

```bash
#!/bin/bash

AWS_ACCESS_KEY_ID="<key id>" \
AWS_SECRET_ACCESS_KEY="<secret key>" \
rake "$@"
```

## Media

Media for the site is served from a separate directory as the rest of the
website files. Locally, this is the `media/` directory. These files are
published to `s3://www.playasopy.org/media/` separately and not tracked in git.

To compare the local files to S3, use the `media:diff` task. This task shows
media which matches as green, and missing or differing files as red with a
status message.

```
% ./aws-rake media:diff
Listing media files in s3://www.playasophy.org/media/
Found 55 objects
Listing local files matching media/**/*
Found 55 files
camp/2012/camp_photo.jpg
camp/2013/layout/final-iso.png
...
```

To pull media down from S3, use `media:pull`. To push local media, use
`media:push`. All of these tasks can be passed a prefix, which will restrict the
task to files which start with the given prefix. For example, to only upload
camp media for 2012, you could do:

```
% ./aws-rake 'media:diff[camp/2012/]'
```

## Publishing

Deploying the website to S3 uses the `s3_website` gem. This can be done using
the `deploy:s3` task:

```
% ./aws-rake deploy:s3
```
