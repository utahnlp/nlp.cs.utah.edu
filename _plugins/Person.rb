# All information about a person
class Person

  attr_accessor :key, :first_name, :last_name, :photo, :website, :interests, :degree, :group
  def initialize(group, array)
    @group = group
    @key = array['key']
    @first_name = array['first_name']
    @last_name = array['last_name']
    @photo = array['photo'] || "/img/profile/unknown.png"
    @website = if group == 'alumni'
                 array['website'] || ''
               else 
                 array['website'] || ("/people/" + @key)
               end
    @interests = array['research_interests']
    @first_position = array['first_position']
    @current_position = array['current_position']
    @advisor = array['advisor']
    @degree = array['degree']
    @thesis = array['thesis']
    @thesis_url = array['thesis_url']

    @pubs = []
    @graduated_year = array['graduated_year']
  end

  def full_name
    first_name + " " + last_name
  end

  def status
    if key == 'alumni'
      "Alumnus"
    elsif degree == 'Ph.D.' or degree == "PhD" or degree == "MS"
      "Graduate Student"
    elsif degree == "BS"
      "Undergraduate Researcher"
    end 
  end 

def degree_type
  if degree == "Ph.D." or degree == "PhD"
    "Doctoral"
  elsif degree == "MS"
    "Masters"
  elsif degree == "BS" or degree == "BA"
    "Undergraduate"
  end
end

  def wrap_with_weblink(content, site)
    # Do we really want to link to alumni whose websites we don't know?
    if @group == 'alumni' and website == ''
      content
    else 
      if website.match(/^http/)
        %(<a href='#{website}'>#{content}</a>)
      else 
        website_url = site['baseurl']+ website
        %(<a href='#{website_url}'>#{content}</a>)
      end 
    end
  end

  def pubs(site)

    if @pubs.length == 0
      for p in site.data['processed']['pubs']['all'] do
        for a in p.authors do
          if a == "#{last_name}, #{first_name}"
            @pubs << p
            break
          end
        end
      end
    end
    @pubs
  end

  def photo_html(img_class, site)
    photo_url = site['baseurl'] + photo
    %(<img class="#{img_class}" src="#{photo_url}" alt="#{full_name}">)
  end

  def alumni_photo_html(img_class, site)
    photo_url = site['baseurl'] + photo
    %(<img class="#{img_class}" src="#{photo_url}" alt="#{full_name}" style="width:10%">)
  end

  def advisor_names(site)
    faculty = site['data']['processed']['people']['faculty']
    
    output = []
    @advisor.split(%r{,\s*}).each do |a|
      output << faculty[a].full_name 
    end
    output.join(' ')
  end

  # Some functions that are only applicable to alumni
  def first_position_after_graduation
    if @group == 'alumni'
      if [nil, 0, ''].include?(@first_position)
        ''
      else
        # %(<li><i>First position after graduation</i>: #{@first_position}</li>)
        @first_position
      end
    else
      ''
    end
  end
  
  def current_position
    if @group == 'alumni'
      if [nil, 0, ''].include?(@current_position)
        ''
      else
        # %(<li><i>Current position</i>: #{@current_position}</li>)
        @current_position
      end
    else
      ''
    end
  end

  def thesis
    if @group == 'alumni'
      if @thesis
        if @thesis_url
          %(<li><i>Thesis</i>: <a href ="#{@thesis_url}">#{@thesis}</a></li>)
        else 
          %(<li><i>Thesis</i>: #{@thesis}</li>)
        end
        
      else
        ''
      end 
    else
      ''
    end
  end

  def graduation_info
    if @graduated_year 
      @degree + ", " + @graduated_year.to_s
    else
      @degree
    end 
  end

  def graduated_year
    @graduated_year
  end
  
end



