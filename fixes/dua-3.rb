# Backwards date ranges (end date before begin date)
fix_for 'dua-3', depends_on: ['noempty-1', 'noempty-2', 'dua-1', 'dua-2'] do
  @xml.xpath("//unitdate[contains(@normal, '/')]|//date[contains(@normal, '/')]").each do |date|
    (start_date, end_date) = date['normal'].split('/')

    if end_date < start_date
      if date.content.blank?
        date.content = "#{start_date}-#{end_date}"
      end
      date.remove_attribute('normal')
    end
  end
end
