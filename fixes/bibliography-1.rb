# Rewrite bibliography with nested list as bibliography with series of bibrefs
fix_for 'bibliography-1', depends_on: ['noempty-1'] do
  @xml.xpath('//bibliography[./list]').each do |bib|
    # turn everything into bibrefs
    items = Nokogiri::XML::NodeSet.new(@xml,
                                       bib.xpath('./list/item').map do |item|
                                         if item.element_children.count == 1 && item.first_element_child.name =='bibref'
                                           item.first_element_child
                                         else
                                           item.name = 'bibref'
                                           item
                                         end
                                       end
                                      )
    # replace list with bibrefs
    bib.at_xpath('./list').replace(items)
  end
end
