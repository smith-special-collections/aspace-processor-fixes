# move descgrp subelements of various types to odd in parent of descgrp, remove descgrp if empty
fix_for 'da-2', depends_on: ['noempty-1']  do
  path = "//descgrp[@type and @type != 'add']/address|
          //descgrp[@type and @type != 'add']/blockquote|
          //descgrp[@type and @type != 'add']/chronlist|
          //descgrp[@type and @type != 'add']/list|
          //descgrp[@type and @type != 'add']/p"
  @xml.xpath(path).each do |el|
    descgrp = el.parent
    odd = Nokogiri::XML::Node.new "odd", @xml
    descgrp.parent.add_child(odd)
    el.parent = odd
    descgrp.remove if descgrp.element_children.count == 0
  end
end
