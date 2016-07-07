fix_for "dua-2", depends_on: ['noempty-1'] do
  @xml.xpath('//unitdate[
    (contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "circa") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "ca") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "approx"))
    and @certainty != "approximate"]').each do |ud|
    ud['certainty'] = 'approximate'
  end
end
