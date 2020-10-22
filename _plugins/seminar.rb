require 'pp'

class Seminar
  attr_accessor :key, :title, :presenter, :year, :month, :day, :time, :address, :keynote, :abstract, :from_org
  
  def initialize(info)
    @key = info['key']
    @title = info['title']
    @presenter= info['presenter']
    @from_org= info['from_org']
    @year= info['year'].to_i
    @month= info['month'].to_i
    @day= info['day'].to_i
    @time= info['time']
    @address = info['address']
    @keynote= info['keynote']
    @abstract = info['abstract']
  end

  def to_html(site)
   keynote_url = site['baseurl'] + keynote
   %(
       <a href="#{keynote_url}"><strong> #{title} </strong></a>.
       <br>
       <strong>#{presenter}</strong> from #{from_org}
       at #{address} #{time} #{month}-#{day}-#{year}.
       <a href="#abs_#{key}" data-toggle="collapse" data-target="#abs_#{key}">Abstract</a>
  <div id="abs_#{key}" class="collapse">
  <blockquote>
  <p>#{abstract}</p>
  </blockquote>
  </div> 
    )
  end

end 
