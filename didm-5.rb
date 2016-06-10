fix_for "didm-5", depends_on: ['noempty-1']  do
  @xml.at_xpath("/ead/archdesc/did").add_child "<physdesc><extent>1 collection</extent>"
end
