# move descgrp subelements of various types to parent of descgrp, remove descgrp if empty
fix_for 'da-2' do
  path = "//descgrp[@type and @type != 'add']/accessrestrict|
          //descgrp[@type and @type != 'add']/accruals|
          //descgrp[@type and @type != 'add']/acquinfo|
          //descgrp[@type and @type != 'add']/altformavail|
          //descgrp[@type and @type != 'add']/appraisal|
          //descgrp[@type and @type != 'add']/custodhist|
          //descgrp[@type and @type != 'add']/note|
          //descgrp[@type and @type != 'add']/prefercite|
          //descgrp[@type and @type != 'add']/processinfo|
          //descgrp[@type and @type != 'add']/userestrict"
  @xml.xpath(path).each do |el|
    descgrp = el.parent
    el.parent = descgrp.parent
    descgrp.remove if descgrp.element_children.count == 0
  end
end
