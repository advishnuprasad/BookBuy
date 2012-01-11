module IbtrsHelper
  def ops_ibtr_url(value, attribute)
    link_to value, Settings.ibtr_url + "/ibtrs?#{attribute}=#{value}"
  end
end
