# coding: utf-8
# Because ArchivesSpace doesn't handle multiple unittitles at the same level
# of description, concatentate their contents, using ‡ (DOUBLE DAGGER) as a separator
fix_for 'unittitle-1', depends_on: ['noempty-1', 'noempty-2', 'unittitle-2'] do
  @xml.xpath("//did[count(./unittitle) > 1]").each do |did|
    new_title = Nokogiri::XML::Node.new('unittitle', @xml)

    # Note: Attributes are discarded

    new_title.children = Nokogiri::XML::NodeSet.new(
      @xml,
      did.xpath('./unittitle').flat_map do |uid|
        contents = uid.children.to_a
        contents << Nokogiri::XML::Text.new('‡', @xml)
      end[0...-1] # Trim the excess double-dagger
    ) # end NodeSet constructor

    # Make the exchange
    (old_first_utitle, *rest) = did.xpath('./unittitle')
    old_first_utitle.swap new_title
    rest.each(&:remove)
  end
end
