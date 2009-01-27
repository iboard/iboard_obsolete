# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper
    
  def gender_dropdown_options
    i=0
    GENDER.map { |g| [g,(i += 1)]  }
  end
  
  def gender_name(id)
    _(GENDER[id-1])
  end
  
  def country_dropdown_options
    ISO3166.map { |c| 
      info = []
      info << "#{c[2]}" unless (c[2]=="NULL")
      info << "#{c[3]}" unless (c[3]=="NULL")
      info << "#{c[8]}" unless (c[8]=="NULL")
      [ c[1] + " (#{info.join(', ')})", c[0] ] 
    }
  end
  
  def country_name(id)
    ISO3166.detect { |c| c[0] == id }[1]
  end
  
  def language_chooser
    render "layouts/language_chooser"
  end
  
  def logged_in?
    user != nil
  end
 
  def granted_for?(function_name)
    if not logged_in?      
      return false
    else      
      
      if  user.username.eql?('root')    
        return true
      end
      
      # check if user updates his own record
      user_self_update = false
      begin
        if ( params[:id].to_i == (user.id.to_i) and
             params["_method"]  == "put"     and
             params["action"]   == "update"  and
             params["controller"]== "users" 
           )
           user_self_update = true
        end
      rescue
        user_self_update = false
      end
      return true if user_self_update == true
      

      function = Function.find_by_name(function_name)
      if not function
        return false
      end
      acls = Accessor.find_all_by_user_id(user,:conditions => ['function_id = ?', function.id])
      return acls.any?   
    end
  end

  def interpret(txt,wrap_paragraph=false)
      # posting-links
      out = txt.gsub(/\[\[posting:([0-9]+):(.*)\]\]/, '<a href='+ root_url + 'postings/\1>\2</a>')
      txt = out
      # controller
      out = txt.gsub(/\[\[controller:(.*):(.*)\]\]/, '<a href='+ root_url + '\1>\2</a>')
      txt = out
      # external links
      out = txt.gsub(/\[\[extern:(.*):(\/+)(.*):(.*)\]\]/, '<a target=_blank href="\1://\3">\4</a>')
      txt = out
      # local links
      out = txt.gsub(/\[\[local:(.*):(\/+)(.*):(.*)\]\]/, '<a target=_top href="\1://\3">\4</a>')
      txt = out
      # thumbnail
      out = txt.gsub(/\[\[thumbnail:(.*):(.*)\]\]/, '!' + root_url + 'binaries/thumbnail/\1'+ '(\2)!')
      txt = out
      # lthumbnail
      out = txt.gsub(/\[\[lthumbnail:(.*):(.*)\]\]/, '!<' + root_url + 'binaries/thumbnail/\1'+ '(\2)!')
      txt = out
      # rthumbnail
      out = txt.gsub(/\[\[rthumbnail:(.*):(.*)\]\]/, '!>' + root_url + 'binaries/thumbnail/\1'+ '(\2)!')
      txt = out
      # fullsize
      out = txt.gsub(/\[\[image:(.*):(.*)\]\]/, '!' + root_url + 'binaries/original/\1'+ '(\2)!')
      txt = out
      # embend
      out = txt.gsub(/\[\[embed:(.*):(.*):(.*)\]\]/, '<embed width=\2 height=\3 src=' + root_url + 'binaries/embed/\1'+'?width=\2&height=\3>')
      txt = out
      # resize
      out = txt.gsub(/\[\[sizedimage:(.*):(.*):(.*)\]\]/, '!' + root_url + 'binaries/thumbnail/\1?size=\2'+ '(\3)!')
      txt = out
      # lfullsize
      out = txt.gsub(/\[\[limage:(.*):(.*)\]\]/, '!<' + root_url + 'binaries/original/\1'+ '(\2)!')
      txt = out
      # lresize
      out = txt.gsub(/\[\[lsizedimage:(.*):(.*):(.*)\]\]/, '!<' + root_url + 'binaries/thumbnail/\1?size=\2'+ '(\3)!')
      txt = out
      # rfullsize
      out = txt.gsub(/\[\[rimage:(.*):(.*)\]\]/, '!>' + root_url + 'binaries/original/\1'+ '(\2)!')
      txt = out
      # icon
      out = txt.gsub(/\[\[icon:(.*):(.*):(.*):(.*)\]\]/, '<img src="'+root_url+'images/\1'+'" width=\2 height=\3 title="\4">' )
      txt = out
      # iconlink
      out = txt.gsub(/\[\[iconlink:(.*):(.*):(.*):(.*):(.*):(.*)\]\]/, 
        '<a href="\5:\6"><img border=0 src="'+root_url+'images/\1'+'" width=\2 height=\3 title="\4"></a>' )
      txt = out
      # rresize
      out = txt.gsub(/\[\[rsizedimage:(.*):(.*):(.*)\]\]/, '!>' + root_url + 'binaries/thumbnail/\1?&size=\2'+ '(\3)!')
      txt = out
      # gallery-link
      out = txt.gsub(/\[\[gallerylink:(.*):(.*)\]\]/, "<a target=_top href='" +
        root_url + 'galleries/webgallery/\1' + 
        "' title='Show Gallery'>"+
        '\2</a>')
      txt = out
      #mp3
      out = txt.gsub(/\[\[mp3:(.*)\]\]/, '<EMBED src="\1" autostart=true loop=false volume=100 width=240 height=30>')
      txt = out
      
      # gallery-layout
      out = txt.gsub(/\[\[gallerylayoutlink:(.*):(.*):(.*)\]\]/, "<a target=_top href='" +
        root_url + 'galleries/webgallery/\1?layout=\2' + 
        "' title='Show Gallery'>"+
        '\3</a>')
      rcl = RedCloth.new(out)
      rcl.hard_breaks = true if rcl.respond_to?("hard_breaks=")
      rc = (rcl.to_html.gsub(
         /<p style="float:right"><img src=/,'<p style="float:right"><img hspace=10 vspace=5 src=').gsub(
         /<div style="float:right"><img src=/,'<div style="float:right"><img hspace=10 vspace=5 src=').gsub(
         /<div style="float:left"><img src=/,'<div style="float:left"><img hspace=10 vspace=5 src=').gsub(
         /<p style="float:left"><img src=/,'<p style="float:left"><img hspace=10 vspace=5 src=') 
         )
         
      
       notie = rc.gsub(
       /flv:(.*):(.*):(.*):flv/, 
            WOWZA_INIT+  ' width="\2" height="\3" '  + WOWZA_2 +  ' width="\2" height="\3" ' +
            WOWZA_3 + 'height=\3&width=\2&file=rtmp://streaming.iboard.cc/fastplay/&id=\1' + WOWZA_CLOSE  )
            
      # fuckie_rand = random_string(5)
       fuckie =      rc.gsub(
       /flv:(.*):(.*):(.*):flv/, 
            IE_INIT+ '\1' + IE_INIT_2  + '\'\2\',\'\3\'' + IE_INIT_3 +
            ' so.addVariable(\'width\',\'\2\');
              so.addVariable(\'height\',\'\3\'); ' +
            IE_2 +  'rtmp://streaming.iboard.cc/fastplay/&id=\1' +
            IE_CLOSE + '\1' + IE_CLOSE_2  )
      
       if  !request.env["HTTP_USER_AGENT"].include? "MSIE" 
         return notie
       else
         return fuckie
       end 
  end
  
  def icon(icon,title='',width=24, height=24)
    "<img src='#{root_url}images/#{icon}' width=#{width} height=#{height} border=0 title='#{title}'>"
  end

  def access_denied(back_to=nil)
    redirect_address = back_to || root_path
    flash[:error] = _('Access denied')
    redirect_to redirect_address
  end

  def shadow_wrapper(&block)
    begin
      if USE_SHADOW_WRAPPER
        concat("<div class='shadow_table'>
            <div class='shadow_above_row'>
                <div class='shadow_upper_left'></div>
                <div class='shadow_upper_middle'></div>
                <div class='shadow_upper_right'></div>
            </div>
            <div class='shadow_content_row'>
                <div class='shadow_content_left'></div>
                <div class='shadow_content'>", block.binding )
         
                yield
         
         concat("</div>
                <div class='shadow_content_right'></div>
            </div>
            <div class='shadow_below_row'>
                <div class='shadow_below_left'></div>
                <div class='shadow_below_middle'></div>
                <div class='shadow_below_right'></div>
            </div>
        </div>", block.binding )
      else
        concat("<!-- no shadows begin -->", block.binding )
        yield
        concat("<!-- no shadows end -->", block.binding )
      end
    rescue
      concat("<!-- no shadows begin -->", block.binding )
      yield
      concat("<!-- no shadows end -->", block.binding )
    end
  end
  
  def render_stars(rating,comment)
    StarsRenderer.new(rating,comment,self).render_stars
  end
    
  def block_ascii_text(text,width=60,ident='')
    words = text.split(" ")
    word = 0
    rc = ""
    line = ident
    words.each do |word|
      line += word + " "
      if line.length >= width
        rc += line + "\n"
        line = ident
      end
    end
    rc + line
  end
end
