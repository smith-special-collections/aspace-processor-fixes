# Add @type='unspecified' to untyped containers
fix_for 'ca-1', depends_on: ['noempty-1']  do
  @xml.xpath("//container[not(@type)]").each do |el|
    el['type'] = 'unspecified'
  end
end
