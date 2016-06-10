fix_for "dua-1", depends_on: ['noempty-1'] do
  @xml.xpath('(//date|//unitdate)[@startYear or @endYear]').each do |el|
    el['normal'] = [el['startYear'], el['endYear']].join("/") unless el['normal']
    %w|startYear endYear|.each do |attr|
      el.remove_attribute attr
    end
  end
end
