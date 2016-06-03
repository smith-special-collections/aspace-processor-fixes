fix_for "da-1" do
  heads = @xml.xpath("//descgrp[@type and @type != 'add']/head")
  heads.each do |el|
    descgrp = el.parent
    el.remove
    if descgrp.element_children.count == 0
      descgrp.remove
    end
  end
end
