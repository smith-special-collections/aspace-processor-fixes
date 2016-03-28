fix_for "da-1" do
  @xml.xpath("//descgrp[@type and @type != 'add']/head").remove
end
