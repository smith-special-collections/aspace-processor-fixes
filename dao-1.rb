fix_for "dao-1" do
  @xml.xpath("//dao[not(@xlink:title)]").each do |el|
    parent = el.at_xpath("./parent::*:did")
    if parent
      title = case
              when (ns = parent.xpath('./unittitle')).count > 0
                ns.parent.xpath('./unittitle').text.gsub(/\s+/, ' ').strip
              when n = parent.at_xpath('./unitid')
                n.content.gsub(/\s+/, ' ').strip
              when n = parent.at_xpath('./container')
                n.content.gsub(/\s+/, ' ').strip
              when n = parent.at_xpath('./unitdate')
                n.content.gsub(/\s+/, ' ').strip
              else
                raise Fixes::Failure.new("Couldn't find proxy for title amongst `..[did]/unittitle|unitid|container|unitdate`")
              end
      el['xlink:dao'] = title if title
    else
      raise Fixes::Failure.new("Direct parent of `dao` is not `did`")
    end
  end
end
