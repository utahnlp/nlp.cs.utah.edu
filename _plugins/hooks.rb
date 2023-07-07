# These hooks run right after Jekyll reads the site data, but before
# it generates anything. This would be a good place to pre-process
# data about people, papers, bibliography etc

Jekyll::Hooks.register :site, :post_read do |site|
  require 'pp'
  require 'pathname'
  require 'bibtex'
  require 'tqdm'

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
      if p.degree == "PhD"
        p.degree = "Ph.D."
      end
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

  # Next, load all the bibtex entries.
  
  bib_metadata_file = site.source + "/_data/bib_metadata.json"
  bib_dir = site.source + "/_data/bibs/*.bib"

  bib_metadata = JSON.load(File.read(bib_metadata_file))  
  papers = Papers.glob(bib_metadata, bib_dir)
  papers = papers.sort_by { |p|
    [-p.month_year.to_time.to_i, p.key, p.title]
  }

  pub_data = {}
  pub_data["all"] = papers

  grouped_papers = papers.group_by { |p| p.year }

  pub_data["by_year"] = grouped_papers
  pub_data["years"] = grouped_papers.keys.sort_by { |year| -year.to_i }

  # create a combined bib file in the publications direcotry

  File.open(site.source + "/assets/utahnlp.bib", "w") { |b| 
    for paper in papers do
      b.write paper.bib_entry (false)
      b.write "\n"
    end
  }

  site.data['processed']['pubs'] = pub_data  

  # load software
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
