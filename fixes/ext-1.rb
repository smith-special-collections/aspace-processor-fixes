# Parses all extents - if they fit requirements, GREAT! if they don't,
# demote extent to physdesc
fix_for 'ext-1', preflight: true do
  @xml.xpath('//physdesc/extent').each do |extent|
    ::Fixes.parse_extent(extent)
  end
end

def Fixes.parse_extent(extent)
  content = extent.content

  stripped = content.sub(/\A\/ Quantity: /, '')     # Special case display str
  stripped.sub!(/\A(\.\s)?[\s,)(]+/, '')            # Leading punc
  approx = stripped.match(Fixes::EXTENT_APPROX_RE)
  if approx
    stripped.sub!(Fixes::EXTENT_APPROX_RE, '')
    extent.parent.after('<physdesc>Extent is approximate.</physdesc>')
  end
  stripped.sub!(/[\s.,):;]+\z/, '')                 # Trailing punc

  count = (m = stripped.match(/^((?:(?:\d{1,3},?)+)?(?:\.\d+)?)\s+/)) && m[1]
  raise ::Fixes::UnparseableExtent.new("No leading count") unless count

  count.gsub!(/,/, '') # Commas are bad practice
  measurement = m.post_match.strip
  if ::Fixes::CANONICAL_EXTENT_MAPPINGS.key? measurement.downcase
    measurement = ::Fixes::CANONICAL_EXTENT_MAPPINGS[measurement.downcase]
  end
  raise Fixes::UnparseableExtent.new("Unlawful measurement") unless ::Fixes::CANONICAL_EXTENTS.include? measurement

  extent.content = "#{count} #{measurement}"
  return true

rescue Fixes::UnparseableExtent => e
  if extent.parent.parent.parent.name == 'archdesc'
    if extent.parent.first_element_child == extent
      extent.add_previous_sibling(<<-FRAGMENT.strip_heredoc + "\n")
        <extent>1 collection</extent>
      FRAGMENT
    end
  else # If we're not at collection level, demote to physdesc
    extent.name = 'physdesc'
    pd = extent.parent
    pd.add_previous_sibling extent
    pd.remove
  end
  return false
end

class ::Fixes
  class UnparseableExtent < StandardError
    # Custom error used to exit parse_extent
  end
end

# Silence const redef warnings if reloading - THIS IS BAD AND I FEEL BAD ABOUT IT
warn_level = $VERBOSE
$VERBOSE = nil
::Fixes::EXTENT_APPROX_RE = /\A(circa|ca\.?|approximately|approx\.?)\s*/i

::Fixes::CANONICAL_EXTENT_MAPPINGS = {
  '3.5" floppy disks' => 'floppy disks (three-and-one-half inch)',
  '33 1/3 rpm record' => 'long-playing records',
  '33 1/3 rpm records' => 'long-playing records',
  '45 rpm record' => '45 rpm records',
  '45 rpm recording' => '45 rpm records',
  '5 1/4" diskettes' => 'floppy disks (five-and-one-quarter inch)',
  '5" floppy disk' => 'floppy disks (five-and-one-quarter inch)',
  '5" floppy disks' => 'floppy disks (five-and-one-quarter inch)',
  '78 rpm record' => '78 rpm records',
  '78 rpm recordings' => '78 rpm records',
  '78 rpm records' => '78 rpm records',
  'analog audio cassette' => 'audiocassettes',
  'audicassette' => 'audiocassettes',
  'audio cassette' => 'audiocassettes',
  'audio cassette tape' => 'audiocassettes',
  'audio cassette tapes' => 'audiocassettes',
  'audio files' => 'digital audio files',
  'audio tape' => 'audiotapes',
  'audio tape recording' => 'audiotapes',
  'audio tapes' => 'audiotapes',
  'audiocassette' => 'audiocassettes',
  'audiocassettes' => 'audiocassettes',
  'audiotape' => 'audiotapes',
  'audiotape reel' => 'audiotape reels',
  'audiotape reels' => 'audiotape reels',
  'audiotapes' => 'audiotapes',
  'box' => 'boxes',
  'boxes' => 'boxes',
  'c.f' => 'cubic feet',
  'cassette tape' => 'audiocassettes',
  'cassette tapes' => 'audiocassettes',
  'cassette-sized recordings' => 'audiocassettes',
  'cd-r' => 'CD-Rs',
  'cd-rom' => 'CD-ROMs',
  'cd-roms' => 'CD-ROMs',
  'cd-rs' => 'CD-Rs',
  'collection' => 'collection',
  'compact disc' => 'compact discs',
  'compact discs' => 'compact discs',
  'compact disk' => 'compact discs',
  'compact disks' => 'compact discs',
  'computer file' => 'files (digital files)',
  'cubic feet' => 'cubic feet',
  'cubic foot' => 'cubic feet',
  'cubic ft' => 'cubic feet',
  'dat' => 'digital audio tapes',
  'digital audio files' => 'digital audio files',
  'digital audio tapes' => 'digital audio tapes',
  'digital image' => 'digital images',
  'digital images' => 'digital images',
  'digital tapes' => 'digital audio tapes',
  'document box' => 'document boxes',
  'document boxes' => 'document boxes',
  'dvd' => 'DVDs',
  'dvd-r' => 'DVDs (DVD-R)',
  'dvd-rs' => 'DVDs (DVD-R)',
  'dvds' => 'DVDs',
  'film negatives' => 'negatives (photographs)',
  'film reel' => 'film reels',
  'film reels' => 'film reels',
  'floppy disk' => 'floppy disks',
  'folder' => 'folders',
  'folders' => 'folders',
  'gigabyte' => 'gigabytes',
  'gigabytes' => 'gigabytes',
  'glass negative' => 'glass plate negatives',
  'glass negatives' => 'glass plate negatives',
  'hollinger boxes' => 'document boxes',
  'image' => 'images',
  'images' => 'images',
  'item' => 'items',
  'items' => 'items',
  'l' => 'leaves',
  'leaf' => 'leaves',
  'leaves' => 'leaves',
  'linear feet' => 'linear feet',
  'linear foot' => 'linear feet',
  'linear ft' => 'linear feet',
  'long-playing record' => 'long-playing records',
  'long-playing records' => 'long-playing records',
  'lp recordings' => 'long-playing records',
  'magnetic discs' => 'magnetic disks',
  'microcassette' => 'microcassettes',
  'micro-cassette' => 'microcassettes',
  'micro-cassettes' => 'microcassettes',
  'microfiches' => 'microfiche',
  'microfilm reel' => 'microfilm reels',
  'microfilm reels' => 'microfilm reels',
  'motion pictures' => 'motion pictures (visual works)',
  'negative' => 'negatives (photographs)',
  'negatives' => 'negatives (photographs)',
  'object' => 'objects',
  'objects' => 'objects',
  'p' => 'pages',
  'page' => 'pages',
  'pages' => 'pages',
  'Paige box' => 'record cartons',
  'Paige boxes' => 'record cartons',
  'panoramic photograph' => 'panoramic photographs',
  'pg' => 'pages',
  'pgs' => 'pages',
  'phonograph record' => 'phonograph records',
  'phonograph records' => 'phonograph records',
  'photo' => 'photographs',
  'photo print' => 'photographic prints',
  'photo prints' => 'photographic prints',
  'photograph' => 'photographs',
  'photograph album' => 'photograph albums',
  'photograph albums' => 'photograph albums',
  'photographic print' => 'photographic prints',
  'photographic prints' => 'photographic prints',
  'photographs' => 'photographs',
  'photomechanical reproduction' => 'photomechanical prints',
  'photomechanical reproductions' => 'photomechanical prints',
  'photoprints' => 'photographic prints',
  'photos' => 'photographs',
  'positive microfilm reels' => 'microfilm reels',
  'poster' => 'posters',
  'posters' => 'posters',
  'pp' => 'pages',
  'record carton' => 'record cartons',
  'record cartons' => 'record cartons',
  'reel-to-reel audio tape' => 'audiotape reels',
  'reel-to-reel audio tapes' => 'audiotape reels',
  'reel-to-reel tapes' => 'audiotape reels',
  'scrapbook' => 'scrapbooks',
  'sheet' => 'sheets',
  'sheets' => 'sheets',
  'u-matic videocassettes' => 'videocassettes (U-matic)',
  'v' => 'volumes',
  'vhs tape' => 'videocassettes (VHS)',
  'vhs videocassettes' => 'videocassettes (VHS)',
  'videcocassette' => 'videocassettes',
  'video recording' => 'video recordings',
  'videocassette' => 'videocassettes',
  'videocassettes' => 'videocassettes',
  'videotape' => 'videotapes',
  'videotapes' => 'videotapes',
  'vol' => 'volumes',
  'vols' => 'volumes',
  'vols' => 'volumes',
  'volume' => 'volumes',
  'volumes' => 'volumes',
  'zip disk' => 'zip disks',
  'zip disks' => 'zip disks'
}

Fixes::CANONICAL_EXTENTS = Fixes::CANONICAL_EXTENT_MAPPINGS.values.uniq

$VERBOSE = warn_level # Unsilence warnings
