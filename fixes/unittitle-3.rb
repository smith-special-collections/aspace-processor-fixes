fix_for 'unittitle-3', depends_on: ['noempty-1', 'noempty-2', 'dsc-duped-cs'] do
  @xml.xpath('//unittitle[.//unitdate]').each do |ut|
    # Because we're moving uds into following-sibling position of ut,
    #   process unitdates in reverse
    ut.xpath('.//unitdate').reverse.each do |ud|
      ut.add_next_sibling(ud.dup)
      ud.replace(Nokogiri::XML::Text.new(ud.text, @xml))
    end
  end
end
