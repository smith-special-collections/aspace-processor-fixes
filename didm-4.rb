# Component-level dids must have either unittitle or unitdate
# If this is not the case, and the element has a head, turn it into a unittitle
# If the element doesn't have a head, search its ancestor cs (all the way to archdesc)
#   and use the first unitdate and/or unittitle you find
fix_for 'didm-4', depends_on: ['noempty-1']  do
  @xml.xpath("/ead/archdesc/*[not(local-name(.) = 'did')]//did[count(./unitdate|./unittitle) = 0]").each do |did|
    if head = did.at_xpath('./head')
      ut = Nokogiri::XML::Node.new "unittitle", @xml
      ut.children = head.children
      did.add_child ut
    else
      insert_us = Nokogiri::XML::NodeSet.new(@xml)
      cursor = did.ancestors('c,archdesc').first

      # Walk up until we hit a c or archdesc with relevant content
      while (insert_us.empty? && cursor)
        insert_us += cursor.xpath('./did/unittitle|./did/unitdate')
        cursor = cursor.ancestors('c,archdesc').first
      end

      if !insert_us.empty?
        insert_us = Nokogiri::XML::NodeSet.new(
          @xml,
          insert_us.map do |el|
            me = el.dup
            me['id'] = "#{SecureRandom.hex}__copy_of__#{el['id']}" if el['id']
            me
          end
        )
        did.children += insert_us
      else
        raise Fixes::Failure
      end
    end
  end
end
