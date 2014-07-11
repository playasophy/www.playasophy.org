# Gallery tag for Jekyll
# Author:: Greg Look
#
# Based on the photos_tag plugin:
# https://gist.github.com/sukima/2631877

require 'digest/md5'

module Jekyll

  class GalleryTag < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
    end

     def path_for(filename)
       filename = filename.strip
       #prefix = (@context.environments.first['site']['photos_prefix'] unless filename =~ /^(?:\/|http)/i) || ""
       prefix = '/media'
       File.join(prefix, filename)
     end

    def render(context)
      # Get a unique identifier based on content
      content = super
      md5 = Digest::MD5.hexdigest(content)

      lines = content.split("\n").map(&:strip)
      list = ""

      lines.each do |line|
        if /^\s*(\S+)\s+(.+)$/ =~ line
          path = path_for($1)
          title = $2
          list << "<li class=\"item\">"
          list << "<a href=\"#{path}\" class=\"fancybox\" rel=\"gallery-#{md5}\" title=\"#{title.strip}\">"
          list << "<img src=\"#{path}\" alt=\"#{title.strip}\"/>"
          list << "</a></li>"
        end
      end

<<-HTML
<ul id="gallery-#{md5}-list" class="gallery">
  #{list}
</ul>
<script type="text/javascript">
  var msnry = new Masonry("#gallery-#{md5}-list", {
    columnWidth: 200,
    itemSelector: '.item'
  });
</script>
HTML
    end
  end

end

Liquid::Template.register_tag('gallery', Jekyll::GalleryTag)
