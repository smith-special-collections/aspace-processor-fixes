fix_for 'c-1', depends_on: ['noempty-1'] do
  c_level = 'c00'
  preposition = "[not(@level) or (@level = 'otherlevel' and not(@otherlevel))]"
  path = "//c#{preposition}|" + 11.times.map { "//#{c_level.succ! + preposition}" }.join("|")
  @xml.xpath(path).each do |c|
    c['level'] = 'otherlevel' unless c['level']
    if c['level'] == 'otherlevel'
      c['otherlevel'] = c['otherlevel'] || 'unspecified'
    end
  end
end
