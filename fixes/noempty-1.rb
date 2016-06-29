fix_for "noempty-1" do
  @xml.xpath("//*[not(node()) and not(@*)]").remove
end
