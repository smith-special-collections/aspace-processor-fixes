# 'name' elements whose encodinganalog attributes
#   indicate a more specific element should be changed
#   to that more specific element
fix_for 'name-1', depends_on: ['noempty-1'] do
  nem = Fixes::NAME_ENCODINGANALOG_MAPPINGS # alias bc LOOOONG
  names = @xml.xpath('//name[' + nem.keys.map {|k| "@encodinganalog = '#{k}'" }.join(" or ") + ']')
  names.each do |name|
    name.name = nem[name['encodinganalog']]
  end
end

# Silence const redef warnings if reloading - THIS IS BAD AND I FEEL BAD ABOUT IT
warn_level = $VERBOSE
$VERBOSE = nil
::Fixes::NAME_ENCODINGANALOG_MAPPINGS = {
  '110' => 'corpname',
  '111' => 'corpname',
  '130' => 'title',
  '240' => 'title',
  '245' => 'title',
  '610' => 'subject',
  '611' => 'subject',
  '630' => 'subject',
  '650' => 'subject',
  '651' => 'geogname',
  '654' => 'subject',
  '700' => 'persname',
  '710' => 'corpname'
}
$VERBOSE = warn_level # Unsilence warnings
