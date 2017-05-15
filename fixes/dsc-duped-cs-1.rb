# Merge hierarchies of <c>s/<cXX>s in <dsc>s with @types
# 'analyticover' and 'in-depth'
fix_for 'dsc-duped-cs-1' do
  in_depth = @xml.at_xpath("//dsc[@type='in-depth']")
  in_depth_cs = in_depth.xpath("c|c01")
  analyticover = @xml.at_xpath("//dsc[@type='analyticover']")
  analyticover_cs = analyticover.xpath('c|c01')

  last_idx = nil
  in_depth_cs.zip(0...in_depth.count).each do |c, idx|
    without_date = c.xpath('./did/unittitle/text()').to_s.gsub(/\s+/, ' ').strip.sub(/^series [ixv]+[.:]\s+/, '')
    with_date = c.xpath('./did/unittitle//text()').to_s.gsub(/\s+/, ' ').strip.sub(/^series [ixv]+[.:]\s+/, '')
    target = analyticover_cs[idx]
    analytic_title = target.xpath('./did/unittitle//text()').to_s.gsub(/\s+/, ' ').strip.sub(/^series [ixv]+[.:]\s+/)

    if [without, with].include?(analytic_title)
      # move stuff from target to c
      # unitdates go in did, should we dedupe these by expression?
      target.xpath("did/unitdate").each do |ud| ud.parent = c.at_xpath('did') end
      # These go directly in cs
      target.xpath("arrangement|scopecontent") do |a_or_s| a_or_s.parent = c end
      # Only copy unittitle if it differs in content
      if target.at_xpath("did/unittitle").content != c.at_xpath("did/unittitle").content
        target.at_xpath("did/unittitle").parent = c.at_xpath("did")
      else
        target.at_xpath("did/unittitle").remove
      end
      # Any leftover unittitles are clearly for copying
      if target.at_xpath('did/unittitle')
        target.xpath('did/unittitle').each do |n| n.parent = c.at_xpath('did') end
      end
    else
      last_idx = idx
      break
    end

  end

  if last_idx
    analyticover_cs[last_idx..-1].each do |c|
      c.parent = in_depth
    end
  end

  analyticover.remove
  in_depth['type'] = 'combined'
end
