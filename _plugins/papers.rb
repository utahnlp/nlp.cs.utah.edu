require 'bibtex'
require 'json'

require_relative 'paper'
require_relative 'bib_cleaner'

class Papers

  @bibs = []
  
  def self.glob_site(site)
    if @bibs.length > 0 then
      return @bibs
    end

    base = site.source

    bib_metadata_file = File.join(base, '_data', 'bib_metadata.json')
    bib_metadata = JSON.load(File.read(bib_metadata_file))

    bibdir = File.join(base, '_data', 'bibs', '*.bib')

    Papers.glob(bib_metadata, bibdir)
  end

  def self.glob(bib_metadata, bibdir)
    bb = []

    Dir[bibdir].each { |bibtex_file|
      bibs_in_file = BibTeX.open(bibtex_file)
      bibs_in_file.each { |bib|
        BibCleaner.new(bib).fix_entry(bb)
        paper = PaperHelper.new(bib, bib_metadata)
        paper.validate
        bb << paper          
      }
    }
    
    
    @bibs = bb.sort_by {|b| ([-b.month_year.to_time.to_i, b.key.to_s, b.title.to_s])}
    return @bibs
  end
end
