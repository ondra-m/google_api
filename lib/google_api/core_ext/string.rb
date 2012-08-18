class String
  def red
    "\033[31m#{self}\033[0m"
  end

  def green
    "\033[32m#{self}\033[0m"
  end

  def bold
    "\033[1m#{self}\033[0m"
  end
end
