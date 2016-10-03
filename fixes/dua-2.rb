fix_for "dua-2", depends_on: ['noempty-1'] do
  @xml.xpath('//unitdate[
    (contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "circa") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "ca") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "ca.") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "approximately") or
     contains(translate(./text(), "ABCDEFGHIJKLMNOPQRSTUVWXYZ", "abcdefghijklmnopqrstuvwxyz"), "approx"))
    and @certainty != "approximate"]').each do |ud|
    ud['certainty'] = 'approximate'
    a = ud.text
    a.slice! 'circa'
    a.slice! 'ca'
    a.slice! 'ca.'
    a.slice! 'approximately'
    a.slice! 'approx'
    a = a.tr('.', '') if a.include? "."
    a = a.tr(',', '') if a.include? ","
    a = a.tr('[]', '').tr('?', '')
    a.slice! 'notebook' if a.include? "notebook"
    a.strip!
    ud.content = a
  end
end
