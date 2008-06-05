class Gallery < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :path
  validates_uniqueness_of :name
  
  
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
  
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '') 
  end
  
  def get_filenames(prefix=nil)
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
  
end
