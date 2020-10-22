require 'pp'

class Citable
  attr_accessor :key, :title, :url, :about, :papers
  
  def initialize(info)
    @key = info['key']
    @title = info['title']
    @url= info['url']
    @about = info['about']
    @papers= info['papers'] || []
  end

  def paper_list(known_papers, known_people, site)
    output = []
    output << %(<h4>Cite With :</h4>)
    output << '<ul>'
    papers.each do |p|
      if known_papers[p]
        paper = known_papers[p]
        output << '<li>'
        output << paper.to_html(known_people, site)
        output << '</li>'
      else
        output << %(<li> #{p} </li>)
      end 
    end
    output << '</ul>'
    output
  end

  def to_html(pubs, people, site)
    
    normalizedURL = url.match(/^http/)? url :       site['baseurl'] + url
    base =  %(
       <a href="#{normalizedURL}"><strong> #{title} </strong></a>.
       <br>
  <div id="about_#{key}" >
  <blockquote>
  <p>#{about}</p>
  </blockquote>
  </div>
    )
    base + '<div>' + paper_list(pubs, people, site).join(" ") + '</div>'
  end

end 
