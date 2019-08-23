class OpenStruct
  def deep_to_h
    to_h.transform_values do |value|
      value.is_a?(OpenStruct) ? value.deep_to_h : value
    end
  end
end
