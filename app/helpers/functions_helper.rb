module FunctionsHelper
  
  def function_selector
    Function.find(:all,:order => 'name').map { |fnc| [fnc.name,fnc.id] }.inject([[_('..public..'),nil]]) { |c,object|
          c << [object[0], object[1]] 
    }
  end
end
