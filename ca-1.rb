@xml.xpath("//container[not(@type)]").each do |el|
  el['type'] = 'unspecified'
end
