fix_for 'note-3', depends_on: ['noempty-1'] do
  @xml.xpath('//c/note').each do |note|
    odd = Nokogiri::XML::Node.new('odd', @xml)
    odd.children = note.children
    note.replace odd
  end
end
