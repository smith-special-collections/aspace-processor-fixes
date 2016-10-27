# ArchivesSpace doesn't properly handle nested lists (lists containing items containing lists)
# This SHOULD be fixed in the importer, but time did not permit, so this fix:
#
#   1. Turns leading text content in an item containing a sublist into an item
#   2. Transforms any <head>s in sublists to <item>s
#   3. Adds three underscores per level of nesting to contents of items in the nested list
#   4. Recurses into further sublists
#   5. flattens the nested list recursively into a single list
fix_for "nested-list-1", depends_on: ['noempty-1'] do
  @xml.xpath('//list[item/list and not(ancestor::list)]/item[list]').each do |toplevel|
    replacement_val = process_sublist_item(toplevel)
    toplevel.swap replacement_val
  end
end

def process_sublist_item(item, depth = 1)
  item_copy = item.dup

  # process matter preceding list in item
  preceding_content = item_copy.first_element_child.xpath('./preceding-sibling::text()').to_s.strip

  replacements = item_copy.xpath('./list/*').map do |thing|
    if thing.name == 'head'
      thing.name = 'item'
      thing.content = thing.content.prepend("___" * depth)
      thing
    else # everything else is items already
      if thing.at_xpath('./list')  # thing contains a list
        process_sublist_item(thing, depth+1)
      else # process normal item
        thing.content = thing.content.prepend("___" * depth)
        thing
      end
    end
  end
  # Turn preceding content if present into an item, and prepend to list
  # Preceding content is from the item, not the sublist, so it gets one level less nesting than list items
  if preceding_content != ''
    replacements.unshift(Nokogiri::XML::DocumentFragment.new(item_copy.document, "<item>#{"___" * (depth - 1)}#{item_copy.first_element_child.xpath('./preceding-sibling::text()').to_s.strip}</item>"))
  end
  return Nokogiri::XML::NodeSet.new(item.document, replacements.flatten)
end
