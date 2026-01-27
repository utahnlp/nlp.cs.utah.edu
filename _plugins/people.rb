module Jekyll
    class PeopleTag < Liquid::Tag
        def initialize(tag_name, params, tokens)
            super
            attributes = {}
            params.scan(Liquid::TagAttributes) do |key, value|
                attributes[key] = value
            end
            @key = attributes['who']
            @degree = attributes["degree"]
        end

        def render_current(people_information, site)
            output = []
            output << '<div class="row g-4">'
            people_information.each do |person_information|
                degree_label = person_information.degree && person_information.degree != "Faculty" ? "<div class='text-muted small fst-italic'>#{person_information.degree} Student</div>" : ""
                photo_directory = person_information.photo ? person_information.photo : "/assets/images/profile/blank.png"
                if person_information.website_url != "#"
                    photo_html = %(<a href="#{person_information.website_url}"><img class="img-fluid rounded shadow-sm" src="#{photo_directory}" alt="#{person_information.full_name}" style="width: 100%; aspect-ratio: 1/1.2; object-fit: cover; object-position: top;"></a>)
                else
                    photo_html = %(<img class="img-fluid rounded shadow-sm" src="#{photo_directory}" alt="#{person_information.full_name}" style="width: 100%; aspect-ratio: 1/1.2; object-fit: cover; object-position: top;">)
                end
                output << %(
          <div class="col-6 col-sm-4 col-md-3 col-lg-2 text-center">
          <div class="mb-2">
          #{photo_html}
          </div>
          <div class="fw-bold">#{person_information.wrap_with_weblink(person_information.full_name)}</div>
            #{degree_label}
            </div>
        )
            end
            output << '</div>'
            output.join
        end

        def render_alumni(people_information_many, site)
            people_information_grouped = people_information_many.group_by { |person_information| person_information.degree_type }
            output = []
            ["Faculty", "Doctoral", "Masters", "Undergraduate"].each do |group|
                people_information = people_information_grouped[group]
                people_information.sort_by! { |person_information| -(person_information.graduated_year.to_i || 0) }
                title = case group
                        when "Faculty" then "Former Faculty"
                        when "Doctoral" then "Doctoral Alumni"
                        when "Masters" then "Master's Alumni"
                        when "Undergraduate" then "Bachelor's Alumni"
                        end
                output << "<h5 class='mt-4 mb-3 text-secondary'>#{title}</h5>"
                output << '<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 row-cols-xl-4 g-2 mb-4">'
                people_information.each do |person_information|
                    degree_year = person_information.graduated_year ? "'#{person_information.graduated_year.to_s[-2..-1]}" : ""
                    display_info = "#{person_information.degree} #{degree_year}"
                    link_start = ""
                    link_end = ""
                    if person_information.website_url && person_information.website_url != "#"
                        link_start = %(<a href="#{person_information.website_url}" class="text-decoration-none text-reset">)
                        link_end = "</a>"
                    end
                    output << %(
                        <div class="col">
                            #{link_start}
                            <div class="h-100 px-3 py-2 border rounded bg-white d-flex justify-content-between align-items-center hover-shadow">
                                <div class="fw-bold text-truncate me-2">
                                    #{person_information.full_name}
                                </div>
                                <div class="small text-muted text-nowrap">#{display_info}</div>
                            </div>
                            #{link_end}
                        </div>
                    )
                end
                output << '</div>'
            end
            output.join
        end

        def render(context)
            site = context['site']
            people = site.data['processed']['people']
            filtered_people = []
            people.each do |key, person|
                if person.group == @key
                    if @key == "graduates"
                        if @degree == person.degree
                            filtered_people << person
                        end
                    else
                        filtered_people << person
                    end
                end
            end
            filtered_people = filtered_people.sort { |x, y| x.last_name <=> y.last_name }
            if filtered_people.length > 0
                if @key == 'alumni'
                    render_alumni(filtered_people, site)
                else
                    render_current(filtered_people, site)
                end
            else
                ""
            end
        end
    end
end

Liquid::Template.register_tag('make_people', Jekyll::PeopleTag)
