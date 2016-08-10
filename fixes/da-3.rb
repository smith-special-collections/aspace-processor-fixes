# move descgrp subelements of various types to parent of descgrp, remove descgrp if empty
fix_for 'da-3', depends_on: ['noempty-1']  do
  path = "//descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/accessrestrict|
          //descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/accruals|
          //descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/acqinfo|
          //descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/altformavail|
          //descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/appraisal|
          //descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/custodhist|
          //descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/note|
          //descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/prefercite|
          //descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/processinfo|
          //descgrp[(@type and @type != 'add') or (not(normalize-space(@type)) and @encodinganalog = '544')]/userestrict"
  @xml.xpath(path).each do |el|
    descgrp = el.parent
    el.parent = descgrp.parent
    descgrp.remove if descgrp.element_children.count == 0
  end
end
