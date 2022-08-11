require 'uri'

class BibChecker
  def initialize(entry)
    @entry = entry
    @errors = []
  end

  def validate(bib_metadata)
    required = bib_metadata[@entry.type.to_s]['required']
    extras = ['tags', 'year']

    valid = true
    valid = valid && verify_fields_existence(required)
    valid = valid && verify_fields_existence(extras)
    valid = valid && verify_authors
    valid = valid && verify_has_venue(bib_metadata[@entry.type.to_s]["venue"])

    if @errors.length > 0 then
      puts("Checking " + @entry.key.to_s)
      @errors.each { |e| puts(e) }
    end
    
    return valid
  end

  def verify_fields_existence(fields)
    valid = true

    fields.each {|e|
      if e.class == Array then
        found_one = false
        e.each { |item|
          if not @entry[item].nil? then
            found_one = true
            break
          end
        }
        if not found_one then
          @errors << ["\tError: Missing at least one of " + e]
          valid = false
        end
      else
        if @entry[e].nil? then
          @errors << ["\tError: Missing " + e]
          valid = false
        else
          # @errors << [@entry[e]]
        end
      end
    }
    return valid
  end

  def verify_file_present(file)
    if not File.exist?(file) then
      @errors << ["\tFile " + file + " not found"]
      return false
    else
      return true
    end
  end

  def verify_authors
    # ensure that there is at least one author
    if @entry.authors.length == 0 then
      @errros << ["\tError: No authors found!"]
    end
  end


  def verify_has_venue(venue_fields)
    # Ensures that at least one venue field is available
    found_venue = false
    @entry.field_names.each { |f|
      if venue_fields.include? f.to_s then
        found_venue = true
      end
    }

    if not found_venue then
      @errors << ["\tError: No venue fields found. Expecting one of " + venue_fields.join(", ") +", found ", @entry.field_names.join(", ")]
    end
    return found_venue
  end
  
end
