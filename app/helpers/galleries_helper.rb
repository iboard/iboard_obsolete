module GalleriesHelper
  
  def thumbnail_url(gallery,fn,width=64,height=64,webview='webview',webwidth=340,webheight=240)
    link_to_remote( "<img class='thumbnail' src='"+
                    thumbnail_gallery_url( :id => gallery, :filename => fn,:width=>width,:height=>height)+
                    "' width=#{width} height=#{height}>", 
                    :url => { :action => 'show_picture', :width=>webwidth, :heigth=>webheight, :filename => fn, :id => gallery },
                    :update => webview,
                    :before => "Element.scrollTo('body');Element.show('photo_spinner');",
                    :complete => "Element.hide('photo_spinner');Element.show('#{webview}');" )
    
  end
  
end
