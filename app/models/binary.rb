######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### #########

include ActionView

#
# Any kind of binary data which may be displayed in postings by [[embed:....]] interpreter
# Binaries are stored in the global configured BINARY_PATH (see config/initializers/static_defaults.rb)
#
class Binary < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :description  
  validates_presence_of :mime_type  
  belongs_to            :user
  
  def self.search(search_txt, page, per_page=8)
    Binary.paginate( :page => page, :per_page => per_page, :order => 'title',
      :conditions => ['title like ? or description like ?', "%#{search_txt}%", "%#{search_txt}%"])
  end
 
  #
  # Virtaul Attribute to save the uploaded file 
  #
  def uploaded_file=(field)
     if field != ""
       mt = field.content_type || "application/binary"
       self.filename = base_part_of(field.original_filename) 
       self.mime_type = mt
       path = get_path
       data = field.read
       self.size     = data.length
       if ! File::exist? path
         Dir::mkdir(path)
       else 
         # delete old images
         Dir::new(path).each do |oldfile|
            if oldfile[0].chr != '.'
              File::unlink(path+"/"+oldfile)
            end
         end
       end
       f = File.new(path + "/" + self.filename,"w")
       f << data
       f.close
     end
  end
  
  #
  # Shortcut to return a HEX-interpration of the id in BINARY_PATH
  #
  def get_path
    BINARY_PATH + "/" + sprintf("%08x", self.id )
  end
   
  
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '') 
  end
  
  #
  # Generate HTML-code to embed object
  # TODO: Shouldn't this be done by a html(erb)-template?!
  # 
  def embed(path,width="400",height="250")
      width = width.to_i-10
      height= height.to_i-40
      "<OBJECT CLASSID=\"clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B\" 
            			      width=\"#{width}\" CODEBASE=\"http://www.apple.com/qtactivex/qtplugin.cab\" 
            			      height=\"#{height}\">
            			          <PARAM name=\"SRC\" value=\"#{path}\">
            			          <PARAM name=\"CONTROLLER\" value=\"true\">
            			          <PARAM name=\"scale\" value=\"Aspect\">
            			          <PARAM name=\"AUTOPLAY\" value=\"true\">
            			          <PARAM name=\"border\" value=\"1\">
            			          <PARAM name=\"target\" value=\"webbrowser\">
            			          <PARAM name=\"href\">
            			          <EMBED src=\"#{path}?filename=#{filename}\" border=\"0\" 
            			                 width=\"#{width}\" autoplay=\"true\" scale=\"Aspect\" 
            			                 pluginspage=\"http://www.apple.com/quicktime/download/\" 
            			                 height=\"#{height}\" target=\"webbrowser\" 
            			                 controller=\"true\" bgcolor=\"FFFFCC\">
            			          </EMBED>
            			      </OBJECT>"
  end


  #
  # Caclulate the thumbnail with RMagick
  #
  public 
  def thumbnail(thumb_size = "64x64",file_full_path=nil)
    fp = file_full_path.nil? ? get_path + "/" + self.filename : file_full_path
    if File::exists?( fp ) 
      f = File::open(fp,"r")
      if file_full_path || ['image/jpg','image/gif','image/png', 'image/jpeg'].include?(self.mime_type)
        binary = f.sysread(File::size(fp))
        img = Magick::Image::from_blob(binary).first
        f.close
        img_tn = img 
        img_tn.change_geometry!(thumb_size) do |cols, rows, image| 
          if cols < img.columns  or rows < img.rows then 
            image.resize!(cols, rows) 
          end     
        end     
        GC.start
      else 
        fnf_f = RAILS_ROOT + "/public/images/" + self.mime_type.gsub(/\//,"_") + ".gif"
        f = File::open(fnf_f,"r")
        fnf_b = f.sysread(File::size(fnf_f))
        img = Magick::Image::from_blob(fnf_b).first
        f.close
        img_tn = img
        img_tn.change_geometry!(thumb_size) do |cols, rows, image| 
           if cols < img.columns  or rows < img.rows then 
             image.resize!(cols, rows) 
           end     
        end
      end
    else
      fnf_f = File::open(RAILS_ROOT + "/public/images/filenotfound.gif","r")
      fnf_b = fnf_f.sysread(File::size(fnf_f))
      img = Magick::Image::from_blob(fnf_b).first
      fnf_f.close
      img_tn = img 
      img_tn.change_geometry!(thumb_size) do |cols, rows, image| 
        if cols < img.columns  or rows < img.rows then 
          image.resize!(cols, rows) 
        end     
      end     
    end
    
    GC.start
    return img_tn.to_blob
  end

end
