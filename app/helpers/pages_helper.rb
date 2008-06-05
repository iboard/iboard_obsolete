module PagesHelper
  
  
  def default_order_opts(selected_value)
    values = [
        ['title', _('Title') ],
        ['created_at desc', _('Date created descending')],
        ['created_at asc', _('Date created ascending')],
        ['updated_at desc', _('Date modified descending')],
        ['updated_at asc', _('Date modified ascending')],
        ['position asc', _('manually ascending')],
        ['position desc', _('manually descanding')]
      ]
      
    values.map { |v|
      selected = ( v[0] == selected_value ) ? " SELECTED " : ""
      "<option value='#{v[0]}' #{selected}>#{v[1]}</option>\n"
    }
  end
end
