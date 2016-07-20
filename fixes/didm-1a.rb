fix_for 'didm-1a', depends_on: ['noempty-1']  do
  eadid = @xml.at_xpath('/ead/eadheader/eadid')
  unitid_content = unless eadid['identifier'].blank?
                     eadid['identifier']
                   else
                     eadid.content
                   end
  unitid = @xml.at_xpath('/ead/archdesc/did/unitid') || @xml.at_xpath('/ead/archdesc/did').add_child('<unitid />').first
  unitid.content = unitid_content
end
