module WorklistsHelper
  def validity_status(valid)
    if valid == 'Y'
      return "Valid"
    elsif valid == 'N'
      return "Invalid"
    else
      return nil
    end
  end
end
