# Add @label='unspecified' to untyped containers
fix_for 'ca-2', depends_on: ['noempty-1']  do
  @xml.xpath("//container[not(@label)]").each do |el|
    el['label'] = 'unspecified'
  end
end
