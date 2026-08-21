Jekyll::Hooks.register :site, :post_read do |site| 
    people = {}
    ['faculty', 'postdocs', 'doctoral', 'masters', 'undergraduates', 'alumni'].each do |group|
        site.data['people'][group].each do |person_information|
            person = Person.new(group, person_information)
            people[person.key] = person
        end
    end
    site.data['processed'] = {}
    site.data['processed']['people'] = people 
end
