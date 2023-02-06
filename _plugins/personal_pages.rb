module Jekyll

  require 'pp'
  
  class PersonPage < Page
    def initialize(site, base, dir, person)
      @person = person
      @base = base 
      @dir = dir 
      @name = 'index.html'
      @site = site 

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'person.html')

      self.data['title'] = person.full_name
      self.data['full_name'] = person.full_name
      self.data['status'] = person.status
      self.data['photo'] = person.photo
      self.data['pubs'] = person.pubs(site)
      self.data['interests'] = person.interests
    end
  end


  class PersonPageGenerator < Generator
    safe true
    def generate(site)
      if site.layouts.key? 'person'
        dir = site.config['personal_pages_dir'] || 'people'

        people =  site.data['processed']['people']

        people.each do |key, person|
          person_dir = File.join(dir, key)
          if person.website == "/people/" + key 
            site.pages << PersonPage.new(site, site.source, person_dir, person)
          end
        end
      end
    end
  end
  
end
