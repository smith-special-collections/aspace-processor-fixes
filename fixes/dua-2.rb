fix_for "dua-2", depends_on: ['noempty-1', 'unittitle-3'] do
  @xml.xpath('//unitdate[
    (contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "circa") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "ca") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "ca.") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "c.") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "c ") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "approximately") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "approx"))]').each do |ud|
    a = ud.text
    a = a.gsub(/\b(circa|ca?|approx(imately)?)\b[,.]?/, '').gsub(/[\[\]]/, '').strip.gsub(/\s+/, ' ')
      ud.content = a
      ud['certainty'] = 'approximate'
  end
end
