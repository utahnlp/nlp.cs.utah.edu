module Jekyll
  require 'pp'
  
  class DatasetsTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
    end

    def render (context)
      processed_data = context['site']['data']['processed']
      site = context['site']
      datasets = processed_data['datasets']
      pubs = processed_data['pubs']
      people = processed_data['people']
      output = []
      output << '<ul>'
      datasets.each do |dataset|
        output << %(<li> #{dataset.to_html(pubs, people, site)}</li>)
      end
      output << '</ul>'
      output 
    end 
  end 
  
end

Liquid::Template.register_tag('make_datasets', Jekyll::DatasetsTag)
