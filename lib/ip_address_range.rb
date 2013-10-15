class IpAddressRange < Range
  def size
    last.integer - first.integer + 1
  end
end