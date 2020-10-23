module Jekyll
  require 'pp'
  
  class SoftwaresTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
    end

    def render (context)
      processed_data = context['site']['data']['processed']
      softwares = processed_data['software']
      pubs = processed_data['pubs']
      people = processed_data['people']
      output = []
      output << '<ul>'
      softwares.sort_by { |h| -h.key }.each do |software|
        output << %(<li> #{software.to_html(pubs, people, context['site'])}</li>)
      end
      output << '</ul>'
      output 
    end 
  end 
  
end

Liquid::Template.register_tag('make_softwares', Jekyll::SoftwaresTag)
