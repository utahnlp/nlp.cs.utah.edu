# These hooks run right after Jekyll reads the site data, but before
# it generates anything. This would be a good place to pre-process
# data about people, papers, bibliography etc

Jekyll::Hooks.register :site, :post_read do |site|
  require 'pp'
  require 'pathname'
  require 'bibtex'

  # All the processed data will be stored here
  site.data['processed'] = {}

  # First load all information about people in the group and group
  # them
  people = site.data['people']
  people_info = {}

  groups = ['faculty', 'grads', 'undergrads', 'alumni']
  groups.each do |group|
    all = people[group] || []
    list = all.map { |p| Person.new(group, p) }

    list.each do |p|
      if people_info[p.key]
        raise "Duplicate person key: " + p.key
      else
        people_info[p.key] = p
      end
    end
  end

  site.data['processed']['people_groups'] = groups
  site.data['processed']['people'] = people_info

  # Next load all seminars
  seminars = site.data['seminars']
  seminars_info = []
  seminars.each do |key, seminar|
    seminar = Seminar.new(seminar)
    seminars_info << seminar
  end

  site.data['processed']['seminars'] = seminars_info

  # Next load all bibtex entries, here we just hard card the bibtex paths
  bibtex_entries = BibTeX.open(site.source + "/publications/" + 'publications.bib')

  # Next load all publications
  publications = site.data['publications']
  pub_info = {}
  publications.each do |key, pub|
    bibtex = bibtex_entries[key]
    paper = Paper.new(pub, bibtex)
    paper.known_authors(people_info).each do |a|
      people_info[a].pubs << paper
    end

    paper_path = Pathname.new(site.source + "/publications/" + key + ".pdf")
    if not paper_path.exist?
      puts "The pdf for " + key + " not found at " + paper_path.to_s
    end 
    
    pub_info[paper.key] = paper
  end

  site.data['processed']['pubs'] = pub_info

  # load softwares
  softwares = site.data['software']
  softwares_info = []
  softwares.each do |key, s|
    software = Citable.new(s)
    softwares_info << software
  end

  site.data['processed']['software'] = softwares_info

  # load datasets
  datasets = site.data['datasets']
  datasets_info = []
  datasets.each do |key, s|
    dataset = Citable.new(s)
    datasets_info << dataset
  end

  site.data['processed']['datasets'] = datasets_info

end
