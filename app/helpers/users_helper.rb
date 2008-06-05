module UsersHelper
  require "base64"
  
  def generate_secure_code_img_url(send_code)
    f = File.open( "/tmp/#{send_code}.sendcode.iboard.cc", "r")
    fout_name =  "/tmp/#{send_code}.image.iboard.cc.jpg"
    if f
      str = f.read
      f.close
      img_file = File.open(fout_name, "w+")
      img_file.puts(string_graphics_to_file(str.chomp))
      img_file.close
    end
    "#{root_url}binaries/0/send_image?file=" + Base64::encode64(fout_name)
  end
  
  
  def string_graphics_to_file(str)
      canvas = Magick::Image.new(100, 20, Magick::HatchFill.new('white','lightcyan2'))
       gc = Magick::Draw.new()
       gc.stroke("transparent")
       gc.fill("black")
       gc.annotate(canvas, 0, 0, 0, 0, str.to_s) do
         gc.gravity = Magick::SouthGravity
         gc.font_family = "Courier"
         gc.pointsize = 18
         gc.font_weight = Magick::BoldWeight
       end
       gc.draw(canvas)
       canvas.to_blob { canvas.format = "jpg" }
  end
  
end
