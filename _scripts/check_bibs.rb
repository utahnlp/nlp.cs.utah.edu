require 'bibtex'
require 'json'
require 'set'
require 'citeproc'
require 'csl/styles'


ROOT="../"
require_relative ROOT + '_plugins/papers'



bib_metadata_file = ROOT + '_data/bib_metadata.json'
bib_dir = ROOT + "_data/bibs/*.bib"
# bib_dir = "./*.bib"

bib_metadata = JSON.load(File.read(bib_metadata_file))


papers = Papers.glob(bib_metadata, bib_dir)

@errors = []

by_year = "by-year/"
Dir.mkdir(by_year) unless File.exists?(by_year)

for paper in papers do
  f = by_year + paper.year + ".bib"
  File.delete(f) if File.exist?(f)
end


for paper in papers do

  File.open(by_year + paper.year + ".bib", "a") { |f|
    f.write paper.bib_entry(true)
    f.write "\n"
  }

  filename = ROOT + "publications/" + paper.paper_link
  if not paper.paper_link.start_with? "http" then
    if not File.exist? (filename) then
      @errors << "\tFile " + filename + " not found"
    end    
  end



end


@errors.each{ |e| print(e + "\n") }
