# move descgrp subelements of various types to parent of descgrp, remove descgrp if empty
fix_for 'da-3', depends_on: ['noempty-1']  do
  path = "//descgrp/accessrestrict|
          //descgrp/accruals|
          //descgrp/acqinfo|
          //descgrp/altformavail|
          //descgrp/appraisal|
          //descgrp/custodhist|
          //descgrp/note|
          //descgrp/prefercite|
          //descgrp/processinfo|
	  //descgrp/relatedmaterial|
          //descgrp/separatedmaterial|
          //descgrp/userestrict"
  @xml.xpath(path).each do |el|
    descgrp = el.parent
    el.parent = descgrp.parent
    descgrp.remove if descgrp.element_children.count == 0
  end
end
