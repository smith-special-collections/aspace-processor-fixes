fix_for 'scopecontent-1', depends_on: %w|noempty-1 noempty-2| do
  @xml.xpath("//scopecontent/arrangement").each do |arr|
    sc = arr.parent
    sc.after(arr)
  end
end
