module Jekyll
  require 'pp'
  
  class PublicationsTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
    end

    def render (context)
      processed_data = context['site']['data']['processed']
      pubs_map = processed_data['pubs']
      pubs = pubs_map.values
      output = []
      topic_pubs = pubs.flat_map do |p|
        p.topics.map{|t| [t, p]}
      end
      grouped_topics = topic_pubs.group_by{|x| x.first}
      output<< '<div class="row">'
      output<< '<div id="paperTags">'
      output<< '<ul>'
      grouped_topics.each do |topic, pubs|
        output<< %(<li data-count="#{pubs.length}">#{topic}</li>)
      end
      output << '</ul>'
      output << '</div>'
      output << '</div>'

      people = processed_data['people']
      grouped = pubs.group_by { |p| p.year }.sort_by{|k,v| -k}

      output<< '<div class="row">'
      output << '<div class="papers">'
      grouped.each do |year, pubs_by_year|
        output << %(<h4>#{year}</h4>)
        output << '<ul>'
        pubs_by_year.sort! { |x,y| y.month <=> x.month }
        
        pubs_by_year.each do |pub|
          output << %(<li data-tags="#{pub.topics.join(",")}"> #{pub.to_html(people, context['site'])}</li>)
        end
        output << '</ul>'
      end
      output << '</div>'
      output << '</div>'
      output 
    end 
  end 
  
end

Liquid::Template.register_tag('make_pubs', Jekyll::PublicationsTag)
