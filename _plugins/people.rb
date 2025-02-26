# coding: utf-8
# A liquid tag called make_people to generate the contents of the
# people page. 

module Jekyll
  require 'pp'
  class PeopleTag < Liquid::Tag
    def initialize(tag_name, params, tokens)
      attributes = {}

      # Parse parameters
      params.scan(Liquid::TagAttributes) do |key, value|
        attributes[key] = value
      end

      @key = attributes['who']
      @degree = attributes["degree"]

    end

    # Current members of the group are rendered with photographs, etc
    # Now we manually split into rows, 6 in a row.
    def render_current(list, site)
      output = []
      list.each_with_index do |person, i|
        if i % 6 == 0
            output << '<div class="row">'
        end

        output << %(
          <div class="col-lg-2 col-md-3 col-xs-4">
        #{person.wrap_with_weblink(person.photo_html('img-responsive img-rounded', site), site)}
            <center>#{person.wrap_with_weblink(person.full_name, site)}</center>
            </div>
        )
        if (i+1) % 6 == 0 || i == list.length - 1
          output << '</div>'
        end
      end
      output
    end

    # Alumni are rendered as a list, with pointers to where they went
    # after graduation and where they are now
    def render_alumni(alumni, site)
      grouped = alumni.group_by {|p| p.degree_type}

      degree_types = ["Faculty", "Doctoral", "Masters", "Undergraduate"]

      output = []
      degree_types.each do |degree|

        people = grouped[degree]

        people.sort_by! { |a|
          if a.graduated_year
            - a.graduated_year
          else
            print("Unknown graduation year for ", a.full_name, "\n")
            0 # why would we not have a graduation year for a person?
          end
        }

        output << (if degree == "Faculty"
                   '<h4>Faculty</h4>'
                  elsif  degree == 'Doctoral'
                    '<h4>Doctoral Students</h4>'
                  elsif  degree == 'Masters'
                    '<h4>Masters Researchers</h4>'
                  elsif degree == "Undergraduate"
                    '<h4>Undergraduate Researchers</h4>'
                   end)       

        output << '<ul>'
        people.each do |person|
          first = ''
          if person.first_position_after_graduation != ""
            first = " → " +  person.first_position_after_graduation
          end
          current = ''
          if person.current_position != '' and person.current_position != person.first_position_after_graduation
            current = ' → ' + person.current_position
          end
          
          person_html = %(
          <li>
          <strong>#{person.wrap_with_weblink(person.full_name, site)}</strong>, #{person.graduation_info}#{first}#{current} 
              <ul class='list-unstyled'>
          #{person.thesis}

              </ul>
          </li>
          )

          output << person_html
        end
        output << '</ul>'
    end
    output 
  end

  def render(context)
    people = context['site']['data']['processed']['people']

    data = []
    people.each { |key, p|
      if p.group == @key
        if @key == "grads"
          if @degree == p.degree
            data << p            
          end
        else
          data << p
        end

      end
    }
    
    sorted = data.sort { |x,y| x.last_name <=> y.last_name }

    if sorted.length > 0
      if @key == 'faculty'
        output = ["<h2>Faculty</h2>"]
      elsif @key == "grads" and @degree == "Ph.D."
        output = ["<h2>Current doctoral students</h2>"]
      elsif @key == "grads" and @degree == "MS"
        output = ["<h2>Current masters students</h2>"]        
      elsif @key == "undergrads"
        output = ["<h2>Current undergraduate researchers</h2>"]
      elsif @key == "alumni"
        output = ["<h2>Former Members</h2>"]
      else
        raise "Invalid group: #{@key} and degree #{@degree}"
      end
      if @key == 'alumni'
        output << render_alumni(sorted, context['site'])
      else
        output << render_current(sorted, context['site'])
      end
      output
    else
      ""
    end
    

  end
end
end


Liquid::Template.register_tag('make_people', Jekyll::PeopleTag)
