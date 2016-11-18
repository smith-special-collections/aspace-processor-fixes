# Notes inside lists which themselves contain lists are broken.
fix_for 'nested-list-2', depends_on: ['noempty-1'] do
  # If nested lists exist in non-items inside lists, just flatten out the lists
  @xml.xpath('//item/*[self::*[not(list)]]//list[.//list]').each do |horrible_list|
    horrible_list.swap(@xml.encode_special_chars(horrible_list.content))
  end
end
