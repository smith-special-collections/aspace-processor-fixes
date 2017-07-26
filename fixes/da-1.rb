fix_for "da-1", depends_on: ['noempty-1']  do
  heads = @xml.xpath("//descgrp/head")
  heads.each do |el|
    descgrp = el.parent
    el.remove
    if descgrp.element_children.count == 0
      descgrp.remove
    end
  end
end
