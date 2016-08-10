fix_for 'unitid-2', depends_on: %w|noempty-1 noempty-2| do
  unitids_by_id = {}
  @xml.xpath("//unitid[@id and @id != '']").each do |uid|
    if unitids_by_id[uid['id']]
      raise Fixes::Failure.new("Duplicate @id value in unitids: #{uid['id']}")
    end
    unitids_by_id[uid['id']] = uid
  end
  @xml.xpath("//ref").each do |ref|
    if unitids_by_id.key? ref['target']
      # rewrite ref to target enclosing 'c' instead
      ref['target'] = unitids_by_id[ref['target']].ancestors('c').first['id']
    end
  end
end
