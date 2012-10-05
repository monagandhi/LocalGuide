# Methods added to this helper will be available to all templates in the application.
module EmailHelper
   def blue_button(label, link = "/", options = {})
    width = options[:width] || 100

content = <<EOF.html_safe
<div class="interested-button">
  <div>
  <table width="#{width}" height="29" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td width="4" background="#{url_to_image "email/button-left.png"}"></td>
      <td class="interested-button" align="center" width="#{width}" background="#{url_to_image "email/button-middle.png"}" valign="middle">
        <a href="#{h link}">#{h label}</a>
      </td>
      <td width="4" background="#{url_to_image "email/button-right.png"}"></td>
    </tr>
  </table>
  </div>
</div>
EOF
  end

  def big_red_button(label, link = "/", options = {})
    width = options[:width] || 280 

content = <<EOF.html_safe
<div>
<table width="#{width}" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr height="41">
    <td width="6" background="#{url_to_image 'email/red-button-left.png'}"></td>
    <td align="center" valign="middle" width="#{width - 12}" background="#{url_to_image 'email/red-button-middle.png'}">
      <div class="red-buttonlabel"><a href="#{h link}">#{h label}</a></div>
    </td>
    <td width="6" background="#{url_to_image 'email/red-button-right.png'}"></td>
  </tr>
</table>
</div>
EOF
  end

  def small_green_button(label, link = "/", options = {})
content = <<EOF.html_safe
<div>
<table border="0" cellpadding="0" cellspacing="0">
  <tr height="28">
    <td bgcolor="#ffffff" width="9" background="#{url_to_image 'email/button-small-green-left.png'}"></td>
    <td bgcolor="#7bbf37" align="center" valign="middle" background="#{url_to_image 'email/button-small-green-middle-repeat.png'}" bgcolor="#57bb06">
      <div class="smallbuttonlabel"><a href="#{h link}">#{h label}</a></div>
    </td>
    <td bgcolor="#ffffff" width="8" background="#{url_to_image 'email/button-small-green-right.png'}"></td>
  </tr>
</table>
</div>
EOF
  end

  def featured_ribbon(price, label)
    content = <<-EOF
      <table width="275" height="57" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td width="19" background="#{url_to_image 'email/featured-listings/ribbon-left.png'}">&nbsp;</td>
    EOF

    unless price.blank?
      content << <<-EOF
        <td width="70" background="#{url_to_image 'email/featured-listings/ribbon-middle-repeat.png'}"><span class="ribbon-price">#{price}</span></td>
        <td background="#{url_to_image 'email/featured-listings/ribbon-middle-repeat.png'}">&nbsp;</td>
      EOF
    end

    content << <<-EOF
        <td background="#{url_to_image 'email/featured-listings/ribbon-middle-repeat.png'}"><span class="ribbon-label">#{label}</span></td>
        <td width="20" background="#{url_to_image 'email/featured-listings/ribbon-right.png'}"></td>
      </tr>
    </table>
    EOF
  end

  def big_blue_button(label, link = "/", options = {})
    width = options[:width] || 123

content = <<EOF.html_safe
<div>
<table width="#{width}" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr height="67">
    <td width="9" background="#{url_to_image 'email/big-button-left.png'}"></td>
    <td align="center" valign="middle" width="#{width - 18}" background="#{url_to_image 'email/big-button-middle.png'}">
      <a href="#{h link}">
        <img border="0" src="#{options[:icon_url]}"/>
      </a>
      <div class="buttonlabel" valign="top"><a href="#{h link}">#{h label}</a></div>
    </td>
    <td width="9" background="#{url_to_image 'email/big-button-right.png'}"></td>
  </tr>
</table>
</div>
EOF
  end

  def photoframe(image_link, link=nil, width=255)
content = <<EOF.html_safe
<div class="photoframe">
<div>
<table border="0" cellpadding="0" cellspacing="0">
<tr height="7">
<td width="7" background="#{url_to_image "email/frames/flex-top-left.png"}"></td>
<td colspan="3" background="#{url_to_image "email/frames/flex-top-middle.png"}"></td>
<td width="7" background="#{url_to_image "email/frames/flex-top-right.png"}"></td>
</tr>
<tr>
<td width="7" background="#{url_to_image "email/frames/flex-middle-left.png"}"></td>
<td colspan="3" align="center" style="line-height: 0;">
#{!link.nil? ? "<a href=\"#{h link}\">" : ""}<img width="#{h width}" border="0" src="#{h image_link}">#{!link.nil? ? "</a>" : ""}
</td>
<td width="7" background="#{url_to_image "email/frames/flex-middle-right.png"}"></td>
</tr>
<tr height="14">
<td width="7" background="#{url_to_image "email/frames/flex-bottom-left.png"}"></td>
<td width="58" background="#{url_to_image "email/frames/flex-bottom-left-shadow.png"}"></td>
<td background="#{url_to_image "email/frames/flex-bottom-middle.png"}" style="line-height: 0">&nbsp;</td>
<td width="32" background="#{url_to_image "email/frames/flex-bottom-right-shadow.png"}"></td>
<td width="7" background="#{url_to_image "email/frames/flex-bottom-right.png"}"></td>
</tr>
</table> 
</div> 
</div>
EOF
  end

  def fade_top
content = <<EOF.html_safe
<table width="560" border="0" cellspacing="0" cellpadding="0"><tr height="23"><td background="#{url_to_image "email/fade-top.png"}">&nbsp;</td></tr></table>
EOF
  end

  def fixed_line
content = <<EOF.html_safe
<hr width="520">
EOF
  end

  def fade_bottom
content = <<EOF.html_safe
<table width="560" border="0" cellspacing="0" cellpadding="0"><tr height="23"><td background="#{url_to_image "email/fade-bottom.png"}">&nbsp;</td></tr></table>
EOF
  end

  def airbnb_signature(text = "Cheers", options={})
  content = <<EOF.html_safe
<p style="#{options[:style]}">
#{h text},<br/>
<img alt="The AirTeam" src="#{url_to_image "email/signature-airteam.png"}">
</p>
EOF
  end 

  def itinerary_row_for(label, content, options = {})
content = <<EOF.html_safe
<tr #{@rowhighlight ? 'bgcolor="#f3f8fe"' : ''}>
<td width="7"></td>
<td width="16" valign="top">#{options[:icon] ? "<img width=\"16\" height=\"16\" src=\"#{h options[:icon]}\">" : ""}</td>
<td width="144" class="label" valign="top">#{h label}</td>
<td width="300" class="content" valign="top">#{h content}</td>
<td width="7"></td>
</tr>
EOF

  # make sure the next row rendered is not highlighted
  @rowhighlight = !@rowhighlight

  content
  end

  def itinerary_table_header(header_text)
content = <<EOF.html_safe
<tr>
<td width="7"></td>
<td colspan="3" width="540">
<h1 class="infoheader">#{h header_text}</h1>
</td>
<td width="7"></td>
</tr>
EOF
  end

  def spacing_table
content = <<EOF.html_safe
<table width="500" border="0" cellspacing="5" cellpadding="0">
<tr><td style="line-height: 5px;">&nbsp;</td></tr>
</table>
EOF
  end

  def big_green_button(options = {}, &block)
    content = capture(&block) if block_given?
    options[:link] = options[:link] || "/"

    icon_row = <<EOF.html_safe
<td background="#{url_to_image 'email/sm-green-button-middle.png'}">
  <a href="#{options[:link]}">
    <img border="0" src="#{h options[:icon_url]}">
  </a>
</td>
EOF

    output = <<EOF.html_safe
<div>
<table border="0" cellpadding="0" cellspacing="0" #{options[:width].nil? ? "" : "width=\"#{options[:width]}\""}>
<tr height="42">
<td bgcolor="#7bbf37" width="6" background="#{url_to_image "email/sm-green-button-left.png"}"></td>
<td bgcolor="#7bbf37" background="#{url_to_image "email/sm-green-button-middle.png"}" align="center">
<div class="greenbuttonlabel">
  <a class="link" href="#{options[:link]}">
    #{h content}
  </a>
</div>
</td>
#{options[:icon_url].nil? ? "" : icon_row}
<td bgcolor="#7bbf37" width="5" background="#{url_to_image "email/sm-green-button-right.png"}"></td>
</tr>
</table>
</div>
</a>
EOF
    
    @emailcontentblock = block
    output
  end

  def itinerary_table_for(header_text, options = {}, &block)
    # reset alternate row highlighting state
    @rowhighlight = false

    output = "<table width=\"560\" border=\"0\" cellspacing=\"0\" cellpadding=\"5\" style=\"margin: 0 auto\" class=\"info #{options[:class] || ""}\">".html_safe
    output << itinerary_table_header(header_text)
    output << capture(&block) if block_given?
    output << "</table>".html_safe

    @emailcontentblock = block
    output
  end

  def speech_bubble(options = {}, &block)
    width = options[:width] || 397
    has_tail = options[:has_tail].nil? ? true : options[:has_tail]

    block_content = block_given? ? capture(&block) : ""

    output = <<EOF.html_safe
<table width="#{width}" border="0" cellpadding="0" cellspacing="0">
<tr height="16">
<td width="27" background="#{url_to_image "email/newspeechbubble/top-left.png"}"></td>
<td background="#{url_to_image "email/newspeechbubble/top-middle.png"}"></td>
<td width="17" background="#{url_to_image "email/newspeechbubble/top-right.png"}"></td>
</tr>
<tr height="34">
<td height="34" width="27" background="#{has_tail ? url_to_image("email/newspeechbubble/middle-left-top.png") : url_to_image("email/newspeechbubble/middle-left.png")}"></td>
<td rowspan="2" bgcolor="#eeeff0" valign="top">
<div class="messagecontent">
#{block_content}
</div>
</td>
<td width="17" rowspan="2" background="#{url_to_image "email/newspeechbubble/middle-right.png"}"></td>
</tr>
<tr><td width="27" background="#{url_to_image "email/newspeechbubble/middle-left.png"}">&nbsp;</td></tr>
<tr height="15">
  <td width="27" background="#{url_to_image "email/newspeechbubble/bottom-left.png"}"></td>
  <td background="#{url_to_image "email/newspeechbubble/bottom-middle.png"}"></td>
  <td width="17" background="#{url_to_image "email/newspeechbubble/bottom-right.png"}"></td>
</tr>
</table>
EOF

    @emailcontentblock = block
    output
  end

  def host_monthly_header_row(label)
    content = <<EOF.html_safe
  <tr>
    <td width="6" height="37" background="#{url_to_image "email/host-monthly/header-left.png"}"></td>
    <td width="556" height="37" bgcolor="#f9f9f9" align="left" background="images/email/host-monthly/content-background-repeat.png">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <th class="host-monthly-header" height="37" valign="top" background="#{url_to_image "email/host-monthly/header-middle-repeat.png"}"><div>#{h label}</div></th>
          <td height="37" width="6" background="#{url_to_image "email/host-monthly/header-right.png"}"></td>
        </tr>
      </table>
    </td>
    <td width="3" background="#{url_to_image "email/host-monthly/right-repeat.png"}"></td>
  </tr>
  <tr>
    <td width="6" height="20" background="#{url_to_image "email/host-monthly/left-repeat.png"}"></td>
    <td width="556" height="20" bgcolor="#f9f9f9" align="left"></td>
    <td width="3" background="#{url_to_image "email/host-monthly/right-repeat.png"}"></td>
  </tr>
EOF
  end

  def host_monthly_content_for(&block)
    block_content = block_given? ? capture(&block) : ""

    output = <<EOF.html_safe
  <tr>
    <td width="6" background="#{url_to_image "email/host-monthly/left-repeat.png"}"></td>
    <td width="556" background="#{url_to_image "email/host-monthly/content-background-repeat.png"}">
    <table width="556" cellpadding="0" cellspacing="0" border="0">
      <tr>
        <td width="25"></td>
        <td valign="top">
          #{block_content}
        </td>
        <td width="15"></td>
      </tr>
    </table>
    </td>
    <td width="3" background="#{url_to_image "email/host-monthly/right-repeat.png"}"></td>
  </tr>
  <tr>
    <td width="6" height="20" background="#{url_to_image "email/host-monthly/left-repeat.png"}"></td>
    <td width="556" bgcolor="#f9f9f9"></td>
    <td width="3" background="#{url_to_image "email/host-monthly/right-repeat.png"}"></td>
  </tr>
EOF

    @emailcontentblock = block
    output
  end

  def grey_frame(options = {}, &block)
    block_content = capture(&block) if block_given?
    content = <<EOF.html_safe
<table #{"class=\"#{options[:class]}\"" if options[:class]} width="562" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="3" height="4" style="margin:0;padding:0;line-height:0px;"><img width="562" height="4" src="#{url_to_image "email/frames/grey/frame-top.png"}" /></td>
  </tr>
  <tr>
    <td width="1" bgcolor="#cacaca"></td>
    <td width="560" bgcolor="#f8f8f8">
      <table width="560" cellspacing="0" cellpadding="20">
        <tr><td>#{block_content}</tr></td>
      </table>
    </td>
    <td width="1" bgcolor="#cacaca"></td>
  </tr>
  <tr>
    <td colspan="3" height="6" style="margin:0;padding:0;line-height:0px;"><img width="562" height="6" src="#{url_to_image "email/frames/grey/frame-bottom.png"}" /></td>  
  </tr>
  <tr>
    <td colspan"3" height="25"></td>
  </tr>
</table>
EOF
  end
  
  # Allow for two or three args
  def icon_tile_for(*args, &block)    
    text = args[0]
    
    if args.length == 3
      # then content is given
      content = args[1]
      options = args[2]
      options ||= {}
    else
      # then use the block_content
      content = capture(&block)
      options = args[1]
      options ||= {}
    end

    if options[:beveled_big_icon]
      icon = "icons/beveled-icons-big-#{options[:beveled_big_icon]}.png"
      icon_html ||= "<img width=\"54\" height=\"48\" src=\"#{url_to_image icon}\" />"
      icon_td_width = 66
    end
    if options[:beveled_medium_icon]
      icon = "icons/beveled-icons-medium-#{options[:beveled_medium_icon]}.png"
      icon_html ||= "<img width=\"37\" height=\"32\" src=\"#{url_to_image icon}\" />"
      icon_td_width = 50
    end
    icon ||= options[:icon]
    icon_html ||= options[:icon_html]
    icon_td_width ||= options[:icon_td_width]
    options[:valign] ||= 'top'

    content = <<EOF.html_safe
<table class="icon_tile" cellspacing="0" cellpadding="0">
  <tr>
    <td width="#{icon_td_width}" valign="#{options[:valign]}" align="left" rowspan="2">#{icon_html}</td>
    <td height="20" class="heading">#{text}</td>
  </tr>
  <tr>
    <td valign="#{options[:valign]}" class="subheading">#{content}</td>
  </tr>
</table>
EOF
    content
  end
  
  # Meant to be used in conjunction with EmailHelper#col
  #
  #  <% cols :width => 500 do |c| %>
  #    <% c.col :width => 250 do %>
  #      <p>one</p>
  #    <% end %>
  #    <% c.col :width => 250 do %>
  #      <p>two</p>
  #    <% end %>
  #  <% end %>
  #
  def cols(options = {}, &block)
    block_content = capture(self, &block) if block_given?

    width_str = options[:width].blank? ? '' : " width=\"#{options[:width]}\""

    content = <<EOF.html_safe
<table#{width_str} cellspacing="0" cellpadding="0">
  <tr>
  #{block_content}
  </tr>
</table>
EOF
    content
  end
  
  def col(options = {}, &block)
    block_content = capture(&block) if block_given?

    width_str = options[:width].blank? ? '' : " width=\"#{options[:width]}\""

    options[:valign] ||= 'top'
    
    content = <<EOF.html_safe
<td valign="#{options[:valign]}"#{width_str}>
  #{block_content}
</td>
EOF
    content
  end  
  
  def spacer_line
    content = <<EOF.html_safe
<table width="520" cellspacing="0" cellpadding="0">
  <tr><td height="25"></td></tr>
  <tr><td height="2" width="520"><img height="2" width="520" src="#{url_to_image 'email/spacer_line.png'}" /></td></tr>
  <tr><td height="25"></td></tr>
</table>
EOF
  end
  
  def button_bar options = {}, &block
    block_content = capture(&block) if block_given?
        
    total_width = 560
    effective_width = total_width - 2*(@button_bar_num_columns - 1) # for borders
    num_columns = @button_bar_num_columns
    icon_td_width = 70
    text_td_width = (effective_width / num_columns - icon_td_width).to_i
    block_content.gsub!('ICON_TD_WIDTH', icon_td_width.to_s).gsub!('TEXT_TD_WIDTH', text_td_width.to_s)
    
    classnames = ['button_bar']
    classnames << "columns_#{@button_bar_num_columns}"
        
    @button_bar_num_columns = 0
        
    content = <<EOF.html_safe
<table class="#{classnames.join(' ')}" width="562" height="53" cellspacing="0" cellpadding="0" bgcolor="#f4f4f4" background="#{url_to_image 'email/button_bar.png'}">
  <tr>
    <td height="1"></td>
  </tr>
  <tr>
    <td height="49">
      <table width="562" height="49" cellspacing="0" cellpadding="0">
        <tr>
          <td width="1"></td>
          #{block_content}
          <td width="1"></td>
        </tr>
      </table>
    </td>
  </tr>
  <tr>
    <td height="3"></td>
  </tr>
</table>
<table width="562" cellspacing="0" cellpadding="0">
  <tr><td height="25">&nbsp;</td></tr>
</table>
EOF
    content
  end
  
  def button_bar_item text, link, icon
    @button_bar_num_columns = 0 if @button_bar_num_columns.nil?
    @button_bar_num_columns = @button_bar_num_columns + 1
    
    content = <<EOF.html_safe
    <td width="ICON_TD_WIDTH" class="icon" height="49"><a href="#{link}"><img src="#{url_to_image icon}" width="32" height="32" /></a></td>
    <td width="TEXT_TD_WIDTH" class="text" height="49"><a href="#{link}">#{text}</a></td>
EOF
    if @button_bar_num_columns > 1
      borders = <<EOF.html_safe
    <td width="1" height="49" bgcolor="#d1d1d1"></td>
    <td width="1" height="49" bgcolor="#fbfbfb"></td>
EOF
      content = borders + content
    end
    content
  end
  
  def profile_pic_frame content
    content = <<EOF.html_safe
    <div class="profile_pic_frame" style="background: #fff url(#{url_to_image 'profile_pic_frame.png'})">#{content}</div>
EOF
  end
  
  def aut_params
    @aut ? {:aut => @aut, :auc => @auc, :aui => @aui} : {}
  end
end

