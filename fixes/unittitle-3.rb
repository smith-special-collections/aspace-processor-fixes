fix_for 'unittitle-3', depends_on: ['noempty-1', 'noempty-2', 'dsc-duped-cs'] do
  drop_me = []
  @xml.xpath('//unittitle[.//unitdate]').each do |ut|
    # Because we're moving uds into following-sibling position of ut,
    #   process unitdates in reverse

    ut.xpath('.//unitdate').reverse.each do |ud|
      ut.add_next_sibling(ud.dup)
      if ud.xpath('./following-sibling::node()').to_s[/\A,?\s*\z/]
        ud.xpath('./following-sibling::node()').remove
        ud.remove
      else
        ud.replace(Nokogiri::XML::Text.new(ud.text, @xml))
      end
    end
    if ut.content.strip.empty?
      drop_me << ut
    end
  end

  drop_me.each do |ut|
    ut.remove
  end
end
