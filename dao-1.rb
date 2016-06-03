# <dao>s without @xlink:title should get one, populated from:
# 1. daodesc if it doesn't match a list of generic values
# .. if did (or ../did if c or archdesc) >
#       unittitle OR unitid OR container OR unitdate + daodesc if it has a defined replacement value
fix_for "dao-1" do
  @xml.xpath("//dao[not(@xlink:title)]").each do |el|
    parent = el.xpath("ancestor::did|ancestor::c|ancestor::archdesc").last
    raise Fixes::Failure.new('No suitable parent found to take title from.') unless parent

    did = (parent.name == 'did') ? parent : parent.at_xpath('./did')
    daodesc = el.at_xpath('./daodesc')

    daodesc_content = daodesc ? daodesc.content.gsub(/\s+/, ' ').strip : ""

    title = nil
    appendage = nil # string to be appended to title

    ::Fixes::CANONICAL_GENERIC_DAODESC_VALUES.each do |k, v|
      if k === daodesc_content # case-style match - equality for String, #match for regexp
        appendage = v || ""
        break
      end
    end

    if appendage.nil? && !daodesc_content.blank?
      title = daodesc_content
    else
      if parent
        title = case
                when (ns = did.xpath('./unittitle')).count > 0
                  ns.text
                when n = did.at_xpath('./unitid')
                  n.content
                when n = did.at_xpath('./container')
                  n.content
                when n = did.at_xpath('./unitdate')
                  n.content
                else
                  raise Fixes::Failure.new("Couldn't find proxy for title amongst `..[did]/unittitle|unitid|container|unitdate`")
                end
        title = title.gsub(/\s+/, ' ').strip.chomp('.')
        title += appendage if appendage
      else
        raise Fixes::Failure.new("Direct parent of `dao` is not `did`")
      end
    end
    el['xlink:title'] = title
  end

end

# Hash of "canonical" <daodesc> values, where:
#   keys   = generic phrases that don't make good titles,
#   values = nil (representing "discard entirely")
#            or a string to be appended to other source of title
unless defined?(::Fixes::CANONICAL_GENERIC_DAODESC_VALUES) == "constant"
  ::Fixes::CANONICAL_GENERIC_DAODESC_VALUES = {
    /\Ahttps?:\/\// => nil,
    /\A\[Search full text in Listview\]\.?\z/ => ": Search full text",
    /\A\[View card index online.\]\.?\z/ => ": Card index",
    /\AClick for a color digital image\.?\z/ => nil,
    /\AClick for black and white digital images from microfilm\.?\z/ => ": Images from microfilm",
    /\AClick for color digital facsimile of photograph\.?\z/ => nil,
    /\AClick for color digital facsimile\.?\z/ => nil,
    /\AClick for color digital facsimiles\.?\z/ => nil,
    /\AClick for color digital image of recto\.?\z/ => ": Recto",
    /\AClick for color digital image of verso\.?\z/ => ": Verso",
    /\AClick for color digital image\.?\z/ => nil,
    /\AClick for color digital images of collection\.?\z/ => nil,
    /\AClick for color digital images of contents\.?\z/ => nil,
    /\AClick for color digital images of entire album\.?\z/ => ": Entire album",
    /\AClick for color digital images of entire item\.?\z/ => ": Entire item",
    /\AClick for color digital images of entire scrapbook\.?\z/ => ": Entire scrapbook",
    /\AClick for color digital images of entire transcript\.?\z/ => ": Entire transcript",
    /\AClick for color digital images of entire volume\.?\z/ => ": Entire volume",
    /\AClick for color digital images of entire work\.?\z/ => ": Entire work",
    /\AClick for color digital images of folder contents\.?\z/ => nil,
    /\AClick for color digital images of manuscript letter\.?\z/ => nil,
    /\AClick for color digital images of manuscript letters\.?\z/ => nil,
    /\AClick for color digital images of this series\.?\z/ => nil,
    /\AClick for color digital images\.?\z/ => nil,
    /\AClick for digital facsimile\.?\z/ => nil,
    /\AClick for digital facsimile of series\.?\z/ => nil,
    /\AClick for digital facsimile transcript\.?\z/ => ": Transcript",
    /\AClick for digital images from microfilm\.?\z/ => ": Images from microfilm",
    /\AClick for digital images of entire work produced from microfilm\.?\z/ => ": Images from microfilm",
    /\AClick for digital images produced from microfilm\.?\z/ => ": Images from microfilm",
    /\AClick for digital images\.?\z/ => nil,
    /\AClick for image\.?\z/ => nil,
    /\AClick for larger view\.?\z/ => nil,
    /\AClick for select color digital images\.?\z/ => ": Selected images",
    /\AClick for selected color digital facsimile\.?\z/ => ": Selected images",
    /\AClick for selected color digital facsimiles\.?\z/ => ": Selected images",
    /\AClick for selected color digital images\.?\z/ => ": Selected images",
    /\AClick here for color digital images of album in its entirety\.?\z/ => nil,
    /\AClick here for color digital images\.?\z/ => nil,
    /\AClick here for digital copy of positive microfilm \.?\z/ => ": Images from microfilm",
    /\AClick here for digital copy\.?\z/ => nil,
    /\AClick here for online access \.?\z/ => nil,
    /\AClick here to open image in a new window \.?\z/ => nil,
    /\AClick here to open in a new window \.?\z/ => nil,
    /\AClick here to see image\.?\z/ => nil,
    /\AClick here to see the digital surrogate of this invoice book\.?\z/ => ": Invoice book",
    /\AClick here to see the digital surrogate of this journal\.?\z/ => ": Journal",
    /\AClick here to see the digital surrogate of this letter book\.?\z/ => ": Letter book",
    /\AClick here to view digital surrogate \.?\z/ => nil,
    /\AClick here to view images\.?\z/ => nil,
    /\AClick this link to access the digitized documents\.?\z/ => nil,
    /\AClick to listen to audio file\.?\z/ => ": Audio file",
    /\AClick to listen to interview\.?\z/ => ": Audio interview",
    /\AColor digital images available\.?\z/ => nil,
    /\AColor digital images of contents\.?\z/ => nil,
    /\ADigital images available.\.?\z/ => nil,
    /\ADigital surrogate available\.?\z/ => nil,
    /\ADigital surrogate available here\.?\z/ => nil,
    /\ADigitized version available for viewing online\.?\z/ => nil,
    /\AFull-size online image\.?\z/ => nil,
    /\AGo to digital images\.?\z/ => nil,
    /\AListen to audio file\.?\z/ => ": Audio file",
    /\ARecto: Click for color digital image\.?\z/ => ": Recto",
    /\ASee archived web site\.?\z/ => nil,
    /\ASee digital facsimile\.?\z/ => nil,
    /\ASee digital image\.?\z/ => nil,
    /\ASee digital image (from microfiche)\.?\z/ => ": Image from microfiche",
    /\ASee digital images\.?\z/ => nil,
    /\ASee selected digital images\.?\z/ => ": Selected images",
    /\AVerso: Click for color digital image\.?\z/ => ": Verso",
    /\AVerso: click for larger view\.?\z/ => ": Verso"
  }

end

unless defined?(::Fixes::CANONICAL_GENERIC_DD_VALUES_WITH_COMPLEX_BEHAVIOR) == 'constant'
  ::Fixes::CANONICAL_GENERIC_DD_VALUES_WITH_COMPLEX_BEHAVIOR = {
    /\ANetworked resource available to users with a valid Harvard ID\.?\z/ => nil, # should be accessrestrict?
    /\AFor a full description consult HOLLIS \.?\z/ => nil,                        # shoult be extref
    # Rest Should be relatedmaterials/extref?
    /\ADigitized version available for viewing on archive.org\.?\z/ => nil,
    /\ADigitized version available for viewing on YouTube\.?\z/ => nil,
    /\AOther digitized versions available for listening through Pacific Film Archive Audio Recordings Collection on archive.org\.?\z/ => nil
  }
end
