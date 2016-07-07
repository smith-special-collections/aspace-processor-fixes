fix_for "noempty-2", depends_on: ['noempty-1'] do
  @xml.xpath('//date[normalize-space(@normal | @startYear | @endYear | text()) = ""]|
              //unitdate[normalize-space(@normal | @startYear | @endYear | text()) = ""]').remove
end
