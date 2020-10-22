module Jekyll
  require 'pp'
  
  class SeminarsTag < Liquid::Tag
    def initialize(tag_name, topK, tokens)
      super
      @topK=topK.to_i
    end

    def render (context)
      processed_data = context['site']['data']['processed']
      seminars= processed_data['seminars']
      grouped = seminars.group_by { |s| s.year }
      if @topK > 0
        output = []
        output << '<ul>'
        semsInFirstTwoYear = Hash[grouped.sort_by{|k,v| k.to_i }.reverse[0..1]].values.flatten
        sortedSems = semsInFirstTwoYear.sort_by { |s| [ s.year.to_i, s.month.to_i, s.day.to_i ] }.reverse
        topKInt = @topK.to_i
        sortedSems.first(topKInt).each do |seminar|
            output << %(<li> #{seminar.to_html(context['site'])}</li>)
        end
        output << '</ul>'
        output
      else
        output = []
        grouped.sort_by{|k,v| k}.reverse.each do |year, seminars_by_year|
          output << %(<h4>#{year}</h4>)
          output << '<ul>'
          seminars_by_year.sort! { |x,y| y.month <=> x.month }
          seminars_by_year.each do |seminar|
            output << %(<li> #{seminar.to_html(context['site'])}</li>)
          end
          output << '</ul>'
        end
        output 
      end
    end 
  end 
  
end

Liquid::Template.register_tag('make_seminars', Jekyll::SeminarsTag)
