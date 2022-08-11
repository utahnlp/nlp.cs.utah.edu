require 'bibtex'
require 'date'
require 'citeproc'
require 'csl/styles'

require_relative 'bib_checker'

class PaperHelper
  def initialize(bib_entry, bib_metadata)

    if not bib_entry.is_a?(BibTeX::Entry)
      raise("Invalid type. Found " + bib_entry.class.to_s)
    end
    
    @entry = bib_entry
    @bib_metadata = bib_metadata
    @meta = bib_metadata[@entry.type.to_s]
    @tags = @entry["tags"].split(/, */).map{ |t| t.strip }
    @liquid = {}
  end

  def validate
    checker = BibChecker.new(@entry)
    checker.validate(@bib_metadata)
  end

  def key
    @entry.key
  end

  def title
    @entry.title.gsub(/[{}]/, '')
  end

  def authors
    @entry.author.map { |a| a.strip }
  end

  def tags
    @tags
  end

  def venue
    result = []
    venue_fields = @meta['venue']
    type = @entry.type.to_s

    for field in venue_fields do
      if @entry[field].nil? then
        next
      end
      value = @entry[field].to_s

      if field == 'volume' then
        value = 'volume ' + value
      end
      
      if type == 'techreport' and field == 'institution' then
        value = value + " Technical Report"
      end

      if type == 'phdthesis' and (field == 'institution' or field == 'school') then
        value = value + " PhD thesis"
      end

      if type == 'msthesis' and  (field == 'institution' or field == 'school') then
        value = value + " MS thesis"
      end
      
      if value.strip().length > 0 then
        result << value.strip()        
      end
    end

    result.join(", ")
  end

  def year
    @entry['year'].to_s
  end

  def month_year
    if @entry['month'].nil? then
      Date.strptime(@entry['year'], "%Y")
    else
      Date.strptime(@entry['month'].to_str + " " + @entry['year'], "%b %Y")
    end
  end



  def bib_entry(all_keys=false)
    output = BibTeX::Entry.new
    output.type = @entry.type
    output.key = @entry.key
    for k in @meta['required'] do
      if k.class == Array then
        for e in k do
          if not @entry[e].nil?  and @entry[e].to_s.strip().length > 0 then
            output[e] = @entry[e]
          end
        end
      else
        if @entry[k].to_s.strip().length > 0 then
          output[k] = @entry[k]        
        end
      end
    end
    
    if all_keys then
      output["tags"] = tags.join(",")
      output["paper"] = paper_link
      for optional_key in ["award"] do
        if not @entry[optional_key].nil? then
          output[optional_key] = @entry[optional_key]
        end
      end      
    end
    
    return output.to_s
  end

  def paper_link
    @entry["paper"].to_s
  end

  def paper_link=(link)
    @entry["paper"] = link
  end
  
  def is_unpublished
    k = @entry.key.to_s
    k == "misc" or k == "techreport" or k == "unpublished"
  end

  def is_thesis
    k = @entry.key.to_s
    k == "phdthesis" or k == "mastersthesis"
  end

  def citation_html
    style = "association-for-computational-linguistics"
    # style = "chicago-author-date"
    citation_processor = CiteProc::Processor.new style: style, format: 'html'
    citation_processor.import [@entry.to_citeproc]
    bibliography = citation_processor.render :bibliography, id: key

    b = bibliography[0].gsub(/[{}]/, "")
    b

  end


  def has_award?
    not @entry["award"].nil?
  end

  def award_info
    @entry["award"]
  end
  
  
  def to_liquid
    if @liquid.length == 0 then
      @liquid = {
        'key' => key,
        'citation' => citation_html,
        'bib' => bib_entry,
        'link' => paper_link,
        'has_award' => has_award?,
        'award_info' => award_info
      }
    end
    @liquid
    
  end
end

