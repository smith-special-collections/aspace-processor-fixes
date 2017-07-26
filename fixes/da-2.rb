# move descgrp subelements of various types to odd in parent of descgrp, remove descgrp if empty
fix_for 'da-2', depends_on: ['noempty-1']  do
  path = "//descgrp/address|
          //descgrp/blockquote|
          //descgrp/chronlist|
          //descgrp/list|
          //descgrp/p"
  @xml.xpath(path).each do |el|
    descgrp = el.parent
    odd = Nokogiri::XML::Node.new "odd", @xml
    descgrp.parent.add_child(odd)
    el.parent = odd
    descgrp.remove if descgrp.element_children.count == 0
  end
end
