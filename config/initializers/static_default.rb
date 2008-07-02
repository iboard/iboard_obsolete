APPLICATION_TITLE='iBoard'
APPLICATION_NAME='iboard'
DEFAULT_LANGUAGE='en_US'
DEFAULT_ROOT_PASSWORD="admin"
BINARY_PATH=RAILS_ROOT+"/binary_data"
GALLERY_PATH_PREFIX=RAILS_ROOT+"/galleries"
GALLERY_CACHE_PREFIX=RAILS_ROOT+"/gallery_cache"
UNZIP_COMMAND="unzip -uo "
POSTING_PREVIEW_LENGTH=512
POSTING_LISTING_LENGTH=256
RAND_CHARS="1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

# out = txt.gsub(/\[\[wowza:(.*):(.*):(.*):(.*)\]\]/, WOWZA_INIT + '\1:\2' + WOWZA_MIDDLE + 
#                     ' width="\3" height="\4" ' + WOWZA_CLOSE
#  txt = out


# FOR IE
IE_INIT='<script type="text/javascript" src="/flash/swfobject.js"></script>
            <div id="player'
            
IE_INIT_2=  '">Loading Player</div>
            <script type="text/javascript">
            var so = new SWFObject(\'/flash/player.swf\',\'mpl\','
IE_INIT_3=  ',\'8\');
            so.addParam(\'allowscriptaccess\',\'always\');
            so.addParam(\'allowfullscreen\',\'true\');'
            
IE_2=       ' so.addVariable(\'file\',\''


IE_CLOSE=   '\'); so.write(\'player'
            
IE_CLOSE_2= '\');
            </script>'


WOWZA_INIT='<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" 
                    codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0" 
                    '
WOWZA_2=' id="videostreaming" align="middle" >
          <param name="allowScriptAccess" value="sameDomain" />
          <param name="allowFullScreen" value="true" />
          <param name="movie" value="videostreaming.swf" />
          <param name="quality" value="high" />
          <param name="bgcolor" value="#000000" />	
          <embed src="http://streaming.iboard.cc/flash/mediaplayer.swf" 
                 allowscriptaccess="always"
                 allowfullscreen="true" '
                 
WOWZA_3=' flashvars="'

WOWZA_CLOSE='" />
         </object>'    


        