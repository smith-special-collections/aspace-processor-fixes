fix_for "didm-1", depends_on: ['noempty-1']  do
  eadid = @xml.at_xpath('/ead/eadheader/eadid')
  ident = eadid['identifier']
  unitid = ident.blank? ? eadid.content : ident
  @xml.at_xpath('/ead/archdesc/did').add_child <<-FRAGMENT
    <unitid>#{unitid}</unitid>
  FRAGMENT
end
