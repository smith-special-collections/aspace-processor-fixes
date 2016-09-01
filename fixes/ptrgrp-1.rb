# Because ptrgrp/ref structure doesn't import correctly,
# ptrgrp/refs must be converted to ref/ptrs
fix_for 'ptrgrp-1', depends_on: %w|noempty-1 unitid-2| do
  @xml.xpath('//ptrgrp').each do |pg|
    refs = pg.xpath('./ref')
    if refs.blank?
      pg.remove
    elsif refs.count == 1
      pg.replace refs.first
    else
      pg.name = 'ref'
      refs.each do |ref|
        ref.name = 'ptr'
        ref['xlink:title'] = ref.content
        ref.content = nil
      end
    end
  end
end
