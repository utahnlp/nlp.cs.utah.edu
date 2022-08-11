require 'bibtex'
require 'json'
require 'set'
require 'citeproc'
require 'csl/styles'

require_relative '../_plugins/papers'

bib_metadata_file = '../_data/bib_metadata.json'
bib_dir = "../_data/bibs/*.bib"
# bib_dir = "./*.bib"

bib_metadata = JSON.load(File.read(bib_metadata_file))


papers = Papers.glob(bib_metadata, bib_dir)


for paper in papers do

  File.open("by-year/" + paper.year + ".bib", "a") { |f|
    f.write paper.bib_entry(true)
    f.write "\n"
  }


end

