fix_for 'c-1', depends_on: ['noempty-1'] do
  @xml.xpath("//c[not(@level) or (@level = 'otherlevel' and not(@otherlevel))]").each do |c|
    c['level'] = 'otherlevel' unless c['level']
    if c['level'] == 'otherlevel'
      c['otherlevel'] = c['otherlevel'] || 'unspecified'
    end
  end
end
