# coding: utf-8
# Because ArchivesSpace doesn't handle multiple unitids,
# concatenate their contents, using ‡ (DOUBLE DAGGER) as a separator
fix_for 'unitid-1', depends_on: ['noempty-1', 'noempty-2', 'unidid-2'] do
  @xml.xpath("//did[count(./unitid) > 1]").each do |did|
    new_id = Nokogiri::XML::Node.new('unitid', @xml)

    # Attributes for final unitid are taken from first unitid
    did.at_xpath('./unitid').attributes.values.each do |attr|
      new_id[attr.name] = attr.value
    end

    new_id.children = Nokogiri::XML::NodeSet.new(
      @xml,
      did.xpath('./unitid').flat_map do |uid|
        contents = uid.children.to_a
        contents << Nokogiri::XML::Text.new('‡', @xml)
      end[0...-1] # Trim the excess double-dagger
    ) # end NodeSet constructor

    # Make the exchange
    (old_first_uid, *rest) = did.xpath('./unitid')
    old_first_uid.swap new_id
    rest.each(&:remove)
  end
end
