fix_for "didm-3", depends_on: ['dua-1', 'noempty-1'] do
  uds = @xml.xpath('//unitdate[@normal]')

  if uds.empty?
    ud_fragment = <<-FRAGMENT.strip
      <unitdate normal="0000/2999">0000-2999</unitdate>
    FRAGMENT
  else
    dates = uds.map do|el|
      el['normal'].split("/").map do |date|
        date[0..3]
      end
    end.flatten.sort.reject {|date| not date.match(/\A\d{4}\z/)}
    bookend_dates = [dates.first, dates.last].uniq
    ud_fragment = <<-FRAGMENT.strip
      <unitdate normal="#{bookend_dates.join('/')}">#{bookend_dates.join('-')}</unitdate>
    FRAGMENT
  end
  @xml.at_xpath('/ead/archdesc/did').add_child ud_fragment
end
