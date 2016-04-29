# <dao>s without @xlink:title should get one, populated from:
# .. if did (or ../did if c or archdesc) >
#       unittitle OR unitid OR container OR unitdate
fix_for "dao-1" do
  @xml.xpath("//dao[not(@xlink:title)]").each do |el|
    parent = el.at_xpath("./parent::did|
                          ./parent::c|
                          ./parent::archdesc")
    did = (parent.name == 'did') ? parent : parent.at_xpath('./did')

    if parent
      title = case
              when (ns = did.xpath('./unittitle')).count > 0
                ns.text.gsub(/\s+/, ' ').strip
              when n = did.at_xpath('./unitid')
                n.content.gsub(/\s+/, ' ').strip
              when n = did.at_xpath('./container')
                n.content.gsub(/\s+/, ' ').strip
              when n = did.at_xpath('./unitdate')
                n.content.gsub(/\s+/, ' ').strip
              else
                raise Fixes::Failure.new("Couldn't find proxy for title amongst `..[did]/unittitle|unitid|container|unitdate`")
              end
      el['xlink:title'] = title if title
    else
      raise Fixes::Failure.new("Direct parent of `dao` is not `did`")
    end
  end
end
