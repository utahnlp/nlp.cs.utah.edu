require 'pp'

class Paper
  attr_accessor :key, :authors, :title, :venue, :year, :month, :paper_url, :extra_info, :bibtex, :topics
  
  def initialize(info, bibtex)
    @key = info['key']
    @authors = info['authors']
    @title = info['title']
    @venue = info['venue']
    @year = info['year'].to_i
    @month = info['month'].to_i
    @paper_url = info['paper_url']
    @highlights = info['highlights']
    @topics = info['topics'] || []
    @bibtex = bibtex
  end

  def author_list(known_people, site)
    as = authors.map { |a|
      if known_people[a]
        person = known_people[a]
        person.wrap_with_weblink(person.full_name, site)
      else
        a
      end 
    }

    if as.size == 1
      as.first
    else
      start = as.first as.size - 1
      last = as.last
      start.join(", ") + " and " + last
    end
  end

  def known_authors(people)
    authors.select { |a| people[a] }
  end

  def topics_html(site)
    tops = @topics.map { |t|
      %(<li><small><mark>#{t}</mark></small></li>)
    }.join(" ")

    %(<ul class="list-inline">#{tops}</ul>)
  end

  def to_html(people, site)
    normalizedURL = paper_url.match(/^http/)? paper_url : site['baseurl'] + paper_url
    base = %(
       <a href="#{normalizedURL}"><strong> #{title} </strong></a>. #{author_list(people, site)}.
       <br>
       #{venue}. #{year}. <a href="#bib_#{key}" data-toggle="collapse" date-target="#bib_#{key}">BibTex</a>
  <div id="bib_#{key}" class="collapse">
  <pre>#{bibtex}</pre>
  </div> 
    )

    tops =  %(<span> #{topics_html(site)} </span>)

    if @highlights
      h = %(<br> <span class="text-info"><strong>#{@highlights}</strong></span>)
      "<p>" + base +  h + tops + "</p>"
    else
      "<p>" + base + tops +  "</p>"
    end
  end
end 
