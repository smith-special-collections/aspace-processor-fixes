@xml.xpath('(//date|//unitdate)[@startYear or @endYear]').each do |el|
  el['normal'] = [el['startYear'], el['endYear']].join("/") unless el['normal']
  %w|startYear endYear| do |attr|
    el.remove_attribute attr
  end

end
