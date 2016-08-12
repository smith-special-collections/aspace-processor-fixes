fix_for 'unittitle-2', depends_on: %w|noempty-1 noempty-2| do
  unittitles_by_id = {}
  @xml.xpath("//unittitle[@id and @id != '']").each do |utitle|
    if unittitles_by_id[utitle['id']]
      raise Fixes::Failure.new("Duplicate @id value in unittitless: #{utitle['id']}")
    end
    unittitles_by_id[utitle['id']] = utitle
  end
  @xml.xpath("//ref").each do |ref|
    if unittitles_by_id.key? ref['target']
      # rewrite ref to target enclosing 'c' instead
      ref['target'] = unittitles_by_id[ref['target']].ancestors('c').first['id']
    end
  end
end
