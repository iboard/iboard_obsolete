module DateHelper
end

class DateTime
  def localize(language)
     case language
     when "de_AT"
       sprintf( "%d. %s %d %02d:%02d", self.day, MONATSNAMEN[self.month-1], self.year, self.hour, self.min)
     else
       (self.to_s(:long))
     end
  end
end
