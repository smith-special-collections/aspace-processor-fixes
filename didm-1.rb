fix_for "didm-1" do
  eadid = @xml.at_xpath('/ead/eadheader/eadid')
  unitid = eadid['identifier'] || eadid.content
  @xml.at_xpath('/ead/archdesc/did').add_child <<-FRAGMENT
    <unitid>#{unitid}</unitid>
  FRAGMENT
end
