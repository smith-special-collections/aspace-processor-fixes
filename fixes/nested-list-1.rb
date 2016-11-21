# ArchivesSpace doesn't properly handle nested lists (lists containing items containing lists)
# This SHOULD be fixed in the importer, but time did not permit, so this fix:
#
#   1. Turns non-list content in an item directly containing a sublist into an item with text of contents
#   2. Transforms any <head>s in sublists to <item>s
#   3. Adds three underscores per level of nesting to contents of items in the nested list
#   4. Recurses into further sublists
#   5. flattens the nested list recursively into a single list
fix_for "nested-list-1", depends_on: ['noempty-1', 'nested-list-2'] do
  @xml.xpath('//list[item/list and not(ancestor::list)]/item[list]').each do |toplevel|
    replacement_val = process_sublist_item(toplevel)
    toplevel.swap replacement_val
  end
end

def process_sublist_item(item, depth = 1)
  item_copy = item.dup
  results = []

  items = item_copy.xpath('./list').each do |list|

    text = list.
           xpath('./preceding-sibling::node()').
           reverse.
           take_while {|el| el.name != 'list'}.
           reverse.
           map(&:text).
           join(' ').
           strip

    unless text.blank?
      before = Nokogiri::XML::Node.new('item', @xml)
      before.content = text.prepend("___" * (depth - 1))
      results << before
    end

    replacements = list.xpath('./*').map do |thing|
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

    results.push(*replacements)

    if list == item_copy.xpath('./list')[-1]
      text = list.xpath('./following-sibling::node()').text.strip
      unless text.blank?
        after = Nokogiri::XML::Node.new('item', @xml)
        after.content = text.prepend("___" * (depth - 1))
        results << after
      end
    end
  end
  return Nokogiri::XML::NodeSet.new(item.document, results.flatten)
end
