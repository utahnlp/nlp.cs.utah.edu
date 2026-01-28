require 'bibtex'
require 'citeproc'
require 'csl/styles'
require 'json'
require 'date'

module UtahNLP
  class Publication
    attr_reader :entry, :key, :year, :date, :type, :links, :award

    def initialize(bib_entry)
      @entry = bib_entry
      @key = bib_entry.key
      @year = bib_entry['year'].to_s
      month = bib_entry['month'] ? bib_entry['month'].to_s : "jan"
      @date = Date.parse("#{month} #{@year}") rescue Date.parse("jan #{@year}")
      @type = bib_entry.type.to_s
      @links = parse_links(bib_entry)
      @award = bib_entry['award']&.to_s
    end

    def title
      @entry.title.to_s.gsub(/[{}]/, '')
    end

    def authors
      @entry.author.to_s
    end

    def citation
      @citation ||= generate_citation
    end

    def to_liquid
      {
        'key' => @key,
        'title' => title,
        'authors' => authors,
        'year' => @year,
        'citation' => citation,
        'bibtex' => @entry.to_s,
        'links' => @links,
        'award' => @award
      }
    end

    private

    def parse_links(entry)
      links = []
      if entry.has_field?(:paper)
        raw_url = entry[:paper].to_s.strip
        if raw_url.match?(/^http/)
          if raw_url.downcase.end_with?('.pdf')
            links << { 'name' => 'PDF', 'url' => raw_url, 'icon' => 'fa-file-pdf' }
          else
            links << { 'name' => 'Link', 'url' => raw_url, 'icon' => 'fa-external-link-alt' }
          end
        else
          clean_filename = raw_url.sub(/^pdfs\//, '')
          final_url = "/assets/pdfs/#{clean_filename}"
          links << { 'name' => 'PDF', 'url' => final_url, 'icon' => 'fa-file-pdf' }
        end
      elsif entry.has_field?(:url)
        links << { 'name' => 'Link', 'url' => entry[:url].to_s, 'icon' => 'fa-external-link-alt' }
      end
      links
    end

    def generate_citation
      cp = CiteProc::Processor.new(style: 'association-for-computational-linguistics', format: 'html')
      cp.import([@entry.to_citeproc])
      citation = cp.render(:bibliography, id: @entry.key).first
      citation.gsub(/[{}]/, '')
    end
  end

  class PublicationGenerator
    def self.process(site)
      puts "Processing Publications..."
      publications = []
      Dir.glob("_data/bibs/*.bib").each do |bib_file|
        bib_file_content = BibTeX.open(bib_file)
        bib_file_content.each do |bib_entry|
          next if bib_entry.comment?
          publications << Publication.new(bib_entry)
        end
      end
      publications.sort_by! { |publication| publication.date }.reverse!
      publications_by_year = publications.group_by { |publication| publication.year }
      site.data['publications'] = {
        'all' => publications,
        'by_year' => publications_by_year,
        'years' => publications_by_year.keys.sort.reverse
      }
      puts "Loaded #{publications.length} publications."
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  UtahNLP::PublicationGenerator.process(site)
end