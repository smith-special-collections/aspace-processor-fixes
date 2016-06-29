fix_for 'note-4', depends_on: ['noempty-1'] do
  @xml.xpath('//did/note').each do |note|
    odd = Nokogiri::XML::Node.new('odd', @xml)
    odd.children = note.children
    note.parent.add_next_sibling odd
    note.remove
  end
end
