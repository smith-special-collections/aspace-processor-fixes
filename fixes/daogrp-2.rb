# In <daogrp>element, when a child <arc> element contains the attribute xlink:show="new", 
# check to see if the same <arc> also contains xlink:actuate attribute. 
# If not, add xlink:actuate="onRequest" to the <arc>
fix_for "daogrp-2", depends_on: ['noempty-1'] do
  @xml.xpath("//daogrp/arc[@xlink:show = 'new']").each do |arc|
    arc['xlink:actuate'] = 'onRequest'
  end
end

