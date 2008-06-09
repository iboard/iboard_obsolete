class StarsRenderer
  
  def initialize(rating,comment,template)
    @rating = rating
    @comment= comment
    @template=template
  end
  
  def render_stars
    content_tag :div, star_images(@rating,@comment), :class => 'star', :id => "rating_stars_#{@comment.id}"
  end
  
  def star_images(rating,comment)
     o=""
     if comment 
         (1..5).each do |position| 
           o += link_to_remote(
                  star_image( position.to_f <= comment.rating.to_f ), 
                  :url => set_rating_comment_path(comment,:rating => position),
                  :method => :put,
                  :complete => "Element.highlight('rating_stars_#{comment.id}')",
                  :update => "rating_stars_#{comment.id}"
                )
         end
       else
         (1..5).each do |position| 
           o += star_image( position <= rating )
       end
     end
     o
   end

   def star_image(filled)
     image_tag("#{star_type(filled)}")
   end

   def star_type(filled)
     if filled
       "star_filled.gif"
     else
       "star.gif"
     end
   end
   
   def method_missing(*args,&block)
     @template.send(*args,&block)
   end
   
end
