class Person
    attr_accessor :group, :key, :first_name, :last_name, :website, :email, :photo, :degree, :advisor, :graduated_year

    def initialize(group, person_information)
        @group = group
        @key = person_information['key']
        @first_name = person_information['first_name']
        @last_name = person_information['last_name']
        @website = person_information['website']
        @email = person_information['email']
        @photo = person_information['photo']
        @degree = person_information['degree']
        @advisor = person_information['advisor']
        @graduated_year = person_information['graduated_year']
    end

    def full_name
        "#{@first_name} #{@last_name}"
    end

    def degree_type
        return "Faculty" if @degree == "Faculty"
        return "Doctoral" if @degree == "PhD"
        return "Masters" if @degree == "MS"
        return "Undergraduate" if ["BS", "BA"].include?(@degree)
        "Other"
    end

    def website_url
        return "#" if @website.nil? || @website.empty?
        return @website if @website.match(/^http/)
        "#"
    end

    def wrap_with_weblink(content)
        url = website_url
        return content if url == "#"
        %(<a href='#{url}' class="text-decoration-none text-dark">#{content}</a>)
    end

    def to_liquid
        {
            'key' => @key,
            'full_name' => full_name,
            'photo' => @photo,
            'degree' => @degree,
        }
    end
end
