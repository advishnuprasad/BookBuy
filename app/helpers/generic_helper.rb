module GenericHelper
  def format_for_html(input_string)
    ret_str = input_string.gsub(/"/,'&quot;')
    return ret_str
  end
end
