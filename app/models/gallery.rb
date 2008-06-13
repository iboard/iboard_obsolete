######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 
#
#  iBoard 2.0 File
#  (c) 2008 by Andi Altendorfer
#  Licence: GPL
#  Warranty: absolutely none
#
######### ######### ######### ######### ######### ######### ######### ######### ######### ######### ######### 

#
# Upload photos in one ZIP-file - unpack it in GALLERY_PATH
# Display thumbnails and pictures
#
class Gallery < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :path
  validates_uniqueness_of :name
  
  #
  # Virtual Attribute
  #
  def foto_zip_file=(field)
    if field != ""
      mt = field.content_type
      if mt != "application/zip"
        # error message
      else
        filename = base_part_of(field.original_filename) 
        path = GALLERY_PATH_PREFIX + "/#{self.path}"
        FileUtils::rm_r(path, :force => true)
        FileUtils::mkdir_p(path)
        data = field.read
        f = File.new(path + "/" + filename,"w")
        f << data
        f.close
        # unpack
        system( "cd #{path}; #{UNZIP_COMMAND} #{path}/#{filename};cd -")
        File::unlink("#{path}/#{filename}")
      end
    end
  end
  
  #
  # TODO: 
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '') 
  end
  
  #
  # return all picture-files as an array
  #
  public
  def get_filenames(prefix=nil)
    @files ||= collect_files(prefix)
    @files
  end
  
  def collect_files(prefix)
    files = []
    path = prefix.nil? ? GALLERY_PATH_PREFIX + "/#{self.path}" :  prefix
    if File::exists? path
      Dir::new(path).each do |f|
         if f[0].chr != '.'
           if File::directory?(path+"/"+f)
             self.get_filenames(path+"/"+f).each do |subdir|
               files << subdir.gsub(GALLERY_PATH_PREFIX,"")
             end
           else
             files << path.gsub(GALLERY_PATH_PREFIX,"")+"/"+f
           end
         end
      end
    end
    files
  end
  
  def get_prev_filename(filename,prefix=nil)
    all = get_filenames(prefix)
    all.each_with_index do |f,idx|
      if f.eql? filename
        if idx > 0
          return all[(idx-1)]
        end
      end
    end
    nil
  end
  
  def get_next_filename(filename,prefix=nil)
    all = get_filenames(prefix)
    all.each_with_index do |f,idx|
      if f.eql? filename
        if idx < all.length
          return all[(idx+1)]
        end
      end
    end
    nil
  end
  
  
  
end
