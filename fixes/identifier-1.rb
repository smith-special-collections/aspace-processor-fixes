# @identifier on eadid is not preserved, move information to processinfo
fix_for 'identifier-1', depends_on: %w|noempty-1 noempty-2| do
  eadid = @xml.at_xpath('//eadid[@identifier]')

  pinfo = Nokogiri::XML::DocumentFragment.new(@xml, <<-FRAGMENT)
    <processinfo>
      <head>Aleph ID</head>
      <p>#{eadid['identifier']}</p>
    </processinfo>
  FRAGMENT

  @xml.at_xpath('//archdesc').add_child(pinfo)
end
