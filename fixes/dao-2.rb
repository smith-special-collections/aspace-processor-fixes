fix_for "dao-2", depends_on: ['noempty-1'] do
  @xml.xpath("//daogrp/arc[@xlink:show = 'new']").each do |arc|
    arc['xlink:actuate'] = 'onRequest'
  end
end