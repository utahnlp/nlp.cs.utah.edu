
class BibCleaner
  def initialize(entry)
    @entry = entry
#    print(@entry)
  end


  def fix_key(all_bibs)
    first_author = @entry.author[0].last.downcase
    year = @entry.year.to_s
    title_tokens = @entry.title.to_s.sub("{", "").sub("}", "").split

    if ['a', 'the', 'an'].include? title_tokens[0].downcase then
      title = title_tokens[1].downcase
      next_id = 2
    else
      title = title_tokens[0].downcase
      next_id = 1
    end

    while title.length - title.count("-") < 6 do
      title = title  + "-" + title_tokens[next_id].downcase
      next_id = next_id + 1
    end

    chars = "abcdefghijklmnopqrstuvqxyz".split("")
    keys = Set.new all_bibs.map {|b| b.key}
    keys.delete @entry.key

    key = first_author + year + title
    fixed_key = key.gsub(/[^0-9A-Za-z-]/, '')
    id = -1
    while keys.include? fixed_key
      id = id + 1
      fixed_key = key + chars[id]
    end
    if @entry.key != fixed_key then
      puts("Fixing entry key from " + @entry.key + " to " + fixed_key)
    end
    @entry.key = fixed_key
  end

  def cleanup_types
    if @entry.type == :conference
      @entry.type = :inproceedings
    end
  end

  def fix_entry(all_bibs)
    fix_key(all_bibs)
    cleanup_types
  end

  def copy_if_not_nil(entry, other, fields, is_required)
    found_some_field = false

    if fields.instance_of? String
      my_fields = [fields]
    elsif fields.instance_of? Array
      my_fields = fields
    else
      raise StandardError, "Invalid argument " + fields.to_s + ". Expecting string or array"
    end

    my_fields.each { |field|
      if not entry[field].nil? then
        found_some_field = true
        other[field] = entry[field]
      end
    }

    if is_required and (not found_some_field) then
      puts entry.to_s
      raise StandardError, "Required field " +  fields.to_s + " missing"
    end
  end
  
  def make_bibentry(bib_metadata)
    type = @entry.type
    required = bib_metadata[type.to_s]['required']
    optional = bib_metadata[type.to_s]['optional']
    e = BibTeX::Entry.new

    e.type = type
    e.key = @entry.key

    required.each { |r|
      copy_if_not_nil(@entry, e, r, true)
    }

    optional.each { |o|
      copy_if_not_nil(@entry, e, o, false)
    }
    return e
  end
end
