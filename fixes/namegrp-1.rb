# Namegrp isn't supported properly in ASpace, so replace namegrps with concatenated
# contents, enclosed in whatever first element of namegrp was (name, persname, etc)
fix_for "namegrp-1", depends_on: %w|noempty-1 noempty-2 name-1| do
  @xml.xpath('//namegrp').each do |ng|
    target_subel = ng.first_element_child

    parts = ng.element_children.map(&:content).map(&:strip)
    parts[0].chomp!('/')

    target_subel.content = parts.join(' -- ')

    ng.swap target_subel
  end
end
