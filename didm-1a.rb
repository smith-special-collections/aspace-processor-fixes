fix_for 'didm-1a', depends_on: ['noempty-1']  do
  eadid = @xml.at_xpath('/ead/eadheader/eadid')
  unitid = eadid['identifier'] || eadid.content
  @xml.at_xpath('/ead/archdesc/did/unitid').content = unitid
end
