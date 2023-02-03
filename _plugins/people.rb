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
          <div class="col-lg-2 col-md-3 col-xs-4 thumb">
        #{person.wrap_with_weblink(person.photo_html('img-responsive img-rounded', site), site)}
            <center><b>#{person.wrap_with_weblink(person.full_name, site)}</b></center>            
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
      grouped = alumni.group_by {|p| p.degree}

      degrees = ["Ph.D.", "MS", "BS"]

      output = []
      degrees.each do |degree|

        people = grouped[degree]

        people.sort_by! { |a|
          if a.graduated_year
            - a.graduated_year
          else
            print("Unknown graduation year for ", a.to_s, "\n")
            0 # why would we not have a graduation year for a person?
          end
        }

        output << (if degree == 'Ph.D.'
                   '<h4>Doctoral Students</h4>'
                  elsif  degree == 'MS'
                    '<h4>Masters Students</h4>'
                  elsif degree == 'BS'
                    '<h4>Undergrauate Researchers</h4>'
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
          <strong>#{person.wrap_with_weblink(person.full_name, site)}</strong>, #{person.graduation_info}#{first}#{current}. 
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
    data = people.select { |key, p| p.group == @key }.map { |key, p| p }
    sorted = data.sort { |x,y| x.last_name <=> y.last_name }

    if sorted.length > 0
      if @key == 'faculty'
        output = ["<h2>Faculty</h2>"]
      elsif @key == "grads"
        output = ["<h2>Current graduate students</h2>"]
      elsif @key == "undergrads"
        output = ["<h2>Current undergraduate researchers</h2>"]
      elsif @key == "alumni"
        output = ["<h2>Alumni</h2>"]
      else
        raise "Invalid group: #{@key}"
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
