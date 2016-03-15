uds = @xml.xpath('//unitdate[@normal]')

if uds.empty?
  ud_fragment = <<-FRAGMENT.strip
    <unitdate normal="0000/9999">0000-9999</unitdate>
  FRAGMENT
else
  dates = uds.map {|el|
    el['normal'].split("/").map do |date|
      date[0..3]
    end.flatten.sort.reject {|date| not date.match(/\A\d{4}\z/)}
  bookend_dates = [dates.first, dates.last].uniq
  ud_fragment = <<-FRAGMENT.strip
    <unitdate normal="#{bookend_dates.join('/')}">#{bookend_dates.join('-')}</unitdate>
  FRAGMENT
end
@xml.at_xml('/ead/archdesc/did').add_child ud_fragment
