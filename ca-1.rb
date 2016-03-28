fix_for 'ca-1' do
  @xml.xpath("//container[not(@type)]").each do |el|
    el['type'] = 'unspecified'
  end
end
