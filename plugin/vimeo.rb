#  (c) BhEaN
#  Licence : MIT
#  
#  This liquid plugin insert a embeded Vimeo video to your octopress or Jekill blog
#  using the following syntax:
#    {% vimeo video_id  %}
#
#  You can specify the with & height of the video with this syntax:
#    {% vimeo video_id 450 500 %}
#
#  And you can specify the alt text for the link too with:
#    {% vimeo video_id 450 500 Click here to play! %}
#
#  This plugin has been designed to optimize loading time when many vimeo videos
#  are inserted to a single page by delaying the vimeo <iframe>'s until the user
#  click on the thumbnail image of the video.
#  
#  Special care have been taken to make sure tha the video resizes properly when 
#  the webbrowser page width changes, or on smartphones. 
#  
#  Its based in the original lazy-load plugin for Youtube of erossignon:
#    https://github.com/erossignon/jekyll-youtube-lazyloading/tree/master
#
#  You can see a demo of this plugin in: 
#    https://pornohardware.com
#   
require 'json'
require 'erb'

class Vimeo < Liquid::Tag
  Syntax = /^\s*(\d+)(\s+(\d*)\s*(\d*)\s*(.+)\s*)?/
  Cache = Hash.new

  def initialize(tagName, markup, tokens)
    super

    if markup =~ Syntax then
      @id = $1

      if $3 == "" then
          @width = '100%'
      else
          @width = $3.strip + 'px'
      end

      if $4 == "" then
          @height = '100%'
      else
          @height = $4.strip + 'px'
      end

      if $5 == "" then
	  @alt = 'Click here to play'
      else
	  @alt = $5.strip
      end 
    else
      raise "No Vimeo ID provided in the \"vimeo\" tag"
    end
  end

  def render(context)

    if ( Cache.has_key?(@id)) then 
        return Cache[@id]
    end

    # extract video information using a REST command 
    response = Net::HTTP.get_response("vimeo.com","/api/v2/video/#{@id}.json")
    data = response.body

    # if something was wrong, raise an error
    if data.index('not found')
        puts "web service error or invalid video id"
    end

    result = JSON.parse(data[1..-2])

    # extract needed data from the json string
    @title = result["title"]
    @description = result["description"]
    @thumbnail = result["thumbnail_large"]

    puts "Generating lazy-vimeo (#{@width} x #{@height}) thumbnail for [#{@title}]"

    @style = "width:#{@width};height:#{@height};background:#000 url(#{@thumbnail}) center center no-repeat;background-size:contain;position:absolute" 
    
    @emu = "//player.vimeo.com/video/#{@id}?autoplay=1"

    @videoFrame =  CGI.escapeHTML("<iframe style=\"vertical-align:top;width:#{@width};height:#{@height};position:absolute;\" src=\"#{@emu}\" frameborder=\"0\" allowfullscreen></iframe>")
 
    # with jQuery 
    #@onclick    = "$('##{@id}').replaceWith('#{@videoFrame}');return false;"
 
    # without JQuery
    @onclick    = "var myAnchor = document.getElementById('#{@id}');" + 
                  "var tmpDiv = document.createElement('div');" +  
                  "tmpDiv.innerHTML = '#{@videoFrame}';" + 
                  "myAnchor.parentNode.replaceChild(tmpDiv.firstChild, myAnchor);"+
                  "return false;" 

   # note: so special care is required to produce html code that will not be massage by the 
   #       markdown processor :
   #       extract from the markdown doc :  
   #           'The only restrictions are that block-level HTML elements ¿ e.g. <div>, <table>, <pre>, <p>, etc. 
   #            must be separated from surrounding content by blank lines, and the start and end tags of the block
   #            should not be indented with tabs or spaces. '
   result = <<-EOF

<div class="ratio-4-3 embed-video-container" style="width:#{@width} !important;height:#{@height} !important;" onclick="#{@onclick}" title="#{@alt}">
<a class="video-lazy-link" style="#{@style}" href="//vimeo.com/#{@id}" id="#{@id}" onclick="return false;">
<div class="video-lazy-link-div"></div>
<div class="video-lazy-link-info">#{@title}</div>
</a>
<div class="video-info" >#{@description}</div>
</div><br />

EOF
  Cache[@id] = result
  return result

  end

  Liquid::Template.register_tag "vimeo", self
end
