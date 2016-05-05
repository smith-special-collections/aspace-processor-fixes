# <dao>s without @xlink:title should get one, populated from:
# 1. daodesc if it doesn't match a list of generic values
# .. if did (or ../did if c or archdesc) >
#       unittitle OR unitid OR container OR unitdate + daodesc if it has a defined replacement value
fix_for "dao-1" do
  @xml.xpath("//dao[not(@xlink:title)]").each do |el|
    parent = el.at_xpath("./parent::did|
                          ./parent::c|
                          ./parent::archdesc")
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
                  ns.text.gsub(/\s+/, ' ').strip
                when n = did.at_xpath('./unitid')
                  n.content.gsub(/\s+/, ' ').strip
                when n = did.at_xpath('./container')
                  n.content.gsub(/\s+/, ' ').strip
                when n = did.at_xpath('./unitdate')
                  n.content.gsub(/\s+/, ' ').strip
                else
                  raise Fixes::Failure.new("Couldn't find proxy for title amongst `..[did]/unittitle|unitid|container|unitdate`")
                end
        title += appendage
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
    "[Search full text in Listview]" => ": Search full text",
    "[View card index online.]" => ": Card index",
    "Click for a color digital image" => nil,
    "Click for black and white digital images from microfilm" => ": Images from microfilm",
    "Click for color digital facsimile of photograph" => nil,
    "Click for color digital facsimile" => nil,
    "Click for color digital facsimiles" => nil,
    "Click for color digital image of recto" => ": Recto",
    "Click for color digital image of verso" => ": Verso",
    "Click for color digital image" => nil,
    "Click for color digital images of collection" => nil,
    "Click for color digital images of contents" => nil,
    "Click for color digital images of entire album" => ": Entire album",
    "Click for color digital images of entire item" => ": Entire item",
    "Click for color digital images of entire scrapbook" => ": Entire scrapbook",
    "Click for color digital images of entire transcript" => ": Entire transcript",
    "Click for color digital images of entire volume" => ": Entire volume",
    "Click for color digital images of entire work" => ": Entire work",
    "Click for color digital images of folder contents" => nil,
    "Click for color digital images of manuscript letter" => nil,
    "Click for color digital images of manuscript letters" => nil,
    "Click for color digital images of this series" => nil,
    "Click for color digital images" => nil,
    "Click for digital facsimile" => nil,
    "Click for digital facsimile of series" => nil,
    "Click for digital facsimile transcript" => ": Transcript",
    "Click for digital images from microfilm" => ": Images from microfilm",
    "Click for digital images of entire work produced from microfilm" => ": Images from microfilm",
    "Click for digital images produced from microfilm" => ": Images from microfilm",
    "Click for digital images" => nil,
    "Click for image" => nil,
    "Click for larger view" => nil,
    "Click for select color digital images" => ": Selected images",
    "Click for selected color digital facsimile" => ": Selected images",
    "Click for selected color digital facsimiles" => ": Selected images",
    "Click for selected color digital images" => ": Selected images",
    "Click here for color digital images of album in its entirety" => nil,
    "Click here for color digital images" => nil,
    "Click here for digital copy of positive microfilm " => ": Images from microfilm",
    "Click here for digital copy" => nil,
    "Click here for online access " => nil,
    "Click here to open image in a new window " => nil,
    "Click here to open in a new window " => nil,
    "Click here to see image" => nil,
    "Click here to see the digital surrogate of this invoice book" => ": Invoice book",
    "Click here to see the digital surrogate of this journal" => ": Journal",
    "Click here to see the digital surrogate of this letter book" => ": Letter book",
    "Click here to view digital surrogate " => nil,
    "Click here to view images" => nil,
    "Click this link to access the digitized documents" => nil,
    "Click to listen to audio file" => ": Audio file",
    "Click to listen to interview" => ": Audio interview",
    "Color digital images available" => nil,
    "Color digital images of contents" => nil,
    "Digital images available." => nil,
    "Digital surrogate available" => nil,
    "Digital surrogate available here" => nil,
    "Digitized version available for viewing on archive.org" => nil,
    "Digitized version available for viewing on YouTube" => nil,
    "Digitized version available for viewing online" => nil,
    "For a full description consult HOLLIS " => nil,
    "Full-size online image" => nil,
    "Go to digital images" => nil,
    "Listen to audio file" => ": Audio file",
    "Networked resource available to users with a valid Harvard ID" => nil,
    "Other digitized versions available for listening through Pacific Film Archive Audio Recordings Collection on archive.org" => nil,
    "Recto: Click for color digital image" => ": Recto",
    "See archived web site" => nil,
    "See digital facsimile" => nil,
    "See digital image" => nil,
    "See digital image (from microfiche)" => ": Image from microfiche",
    "See digital images" => nil,
    "See selected digital images" => ": Selected images",
    "Verso: Click for color digital image" => ": Verso",
    "Verso: click for larger view" => ": Verso"
  }
end
