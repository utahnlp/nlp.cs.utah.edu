This repository contains the source for building the `nlp.cs.utah.edu`
website. The website is constructed using `jekyll` by populating a collection of
templates with data.


# How to use it?

## Almost markdown and plain text

This website is built using [`jekll`](https://jekyllrb.com) framework.  To use
this website, you only need to know some markdown
usage(https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet), or if
you want, mathjax is added for it to support latex research or review
writing. 

If there are issues, etc, please create a github issue.

## Directory structure

Here's a high level overview of the important files and directories that are
used for constructing the website.


### Internal components and templates

* `config.yml`: The configuration file listing jekyll options

* `_plugins`: Any ruby code that can be used to define jekyll plugins and generally construct website elements

* `_layouts`: The HTML layouts defined with the liquid templating language

* `_includes`: Snippets of HTML that can be included within markdown pages or in layouts. Two files that may need to be occasionally updated are:

  * `_includes/nav.html`: The contents of the navbar at the top of all pages
  * `_includes/footer.html`: The footer at the bottom of all pages
  
* `_data`: Structured data that is used to construct website elements. This includes information about people, papers, courses, datasets etc. The contents of this folder will be most frequently updated.


### External facing elements

* `img`: Any images that are used in the site

* `assets`: Where CSS and Javascript code for the website is stored. (The current instance of the website is built with Bootstrap

* `index.md`: The home of the website, corresponding to https://nlp.cs.utah.edu.

* `publications/index.md`: The publications page of the website, corresponding to https://nlp.cs.utah.edu/publications. All the details about publications are obtained from the bib files in `_data/bibs`. Any paper pdfs will be canonically stored in `publications/pdfs`.

* `people/index.md`: The people page of the website, corresponding to https://nlp.cs.utah.edu/people. The details about people are obtained from `_data/people` (details below).

* `courses/index.md`: The courses page of the website, corresponding to https://nlp.cs.utah.edu/courses.

* `datasets/index.md`: The datasets page of the website, corresponding to https://nlp.cs.utah.edu/datasets.


## Deploy

The website is hosted on the CS department server. To deploy, run the following
on the command line:

```
bash publish.sh [your-cs-shell-id]
```

## Data Description

The data for populating templates is in the directory `_data`. Its
contents are:


### `_data/people` 

All the people affiliated with the group. This contains the following
files:
- `faculty.yml`
- `grads.yml`
- `undergrads.yml`
- `alumni.yml`
   
Each file contains a list of people, each with the following fields:
- `key`: A sitewide unique identifier for the person. This
  identifier is used to refer to this person across the website.
- `first_name`: The first name
- `last_name`: The last name
- `website`: The person's website. If not provided, then a webpage
  for this person is created at `nlp.cs.utah.edu/people/<key>`,
  where `<key>` is the person's identifier from above.
- `email`: The email address
- `photo`: A link to a photograph of this person. If not provided
  then this points to `/img/unknown.jpg`. For profile photo, please manually rescale to roughly 250x320.
- `research_interests`: A short description or a comma separated
  list of research interests for this person
- `degree`: For students only. What degree are they working towards.
- `advisor`: For students only. Who is the advisor. Currently,
  this can be one of `svivek` or `riloff`.
- `thesis`: For alumni. If this person wrote a thesis, then the
  title of the thesis.
- `thesis_url`: For alumni. If this person wrote a thesis, then a
  pointer to the thesis document.
- `first_position`: For alumni. The first position after graduation.
- `current_position`: For alumni. Where are they currently?
- `graduated_year`: For alumni. When did this person graduate?

Among these fields, only the key and name fields are required. All
other fields can be empty. 


### `_data/bibs`

Contains all publications in `.bib` files. Any bib entry in any `.bib` file in
this directory will show up in on [[https://nlp.cs.utah.edu/publications]]. The
bib entries are grouped by year for convenience.

The bib entries are standard bibtex, with two required and one optional extra
field:

* `tags`: A comma separated list of tags
* `paper`: A pointer to the pdf of the file. The convention is that all pdfs are
  placed in the `publications/pdfs` directory, and this entry looks like
  `pdfs/filename.pdf`.
* `award` (optional): Any extra information about the paper identifying awards
  or recognition that it got. This will highlighted on the website.

There is a helper script `_scripts/check_bibs.rb` that can help validate the bib entries. To use it, run `ruby check_bibs.rb`. It will show any errors in the bib files.

### `_data/seminars`

*currently not shown on the website*

We use the following data structure to organize our seminar info. Most recent seminar information will be shown on the front page of our website. 
- `key`: just like the `key` for a publication, this is a key for a talk, tutorial, presentation. A `/seminars/<key>.pdf` according to the talk also suggested to put into the corresponding path. 
- `title`: The title of the talk, seminar presentation.
- `presenter`: The name of the presenter, in future, we can post our nlp, ml seminar talk info here to attract other people to attend.
- `from_org`: The organization of the presenter.
- `year`: An integer value for the year value
- `month`: An integer value for the month value 
- `day`: An interger value for the day value 
- `time`: formated as 11:50AM - 01:10PM¬
- `address`: A string, such as MEB 3147¬
- `keynote`: The path to the keynote file , `/seminars/<key>.pdf`
- `abstract`: A brief and attractive abstract 

### `softwares`,`data`, semi-structured entities

*currently not shown on the website*

Besides the above entities are managed with `yml` data files, all other information such as news , research blog post, software , data,  and course, usually they contain various rich information, and not easily formated into a unified structure. Especially for software and data, we encourage to use more rich form, such as jekyll post or some external wiki page. Hence, we offer a simple set of data fields, only when those data fields can be joined with our people and publications data.

It has a structured data template in `_data\softwares`. The fields for structured part in our system are as follows:
- `key` : the key of the software, such as CoreNLP
- `titile`: such as "Stanford NLP", a name for the software. 
- `url`: The url of the software, it can be some post page in our system, or any existed project wiki page on github. 
- `about`: A brief description for the software
- `paper`: related papers when citing for the software. 

For others, we also propose the same policy as softwares, we can either create a post for them or just use the external pages.  

### "_posts" for all content entities, especially for news, or any page with rich request 

"news", "courses", and the previous `software` and `data` components, will benefit from rich unstructured informations. We use the same "_post" features in jekyll as a unified framework to support all the concent , by organized by their `post.categories` as `news`, `courses`,`software` , `data` or any research blog topic categories.

## Compiling and testing

To compile the project, you need `jekyll` on your machine. See
[the official jekyll website](http://jekyllrb.com) to see how to
install it. With jekyll in place, you can compile and test locally
by running (in the root directory of the project):

`jekyll serve` 

This will compile the project and launch a local web server where you
can browse through the generated website.

# Contribution Guidlines


*To be updated*

### Comments and Issues for Each part

Previously, with Tao, Tianyu, Annie, we have some brain-storm on this website, also collect some feedback from Ellen and Vivek. All the the previous ideas are listed in the following list with their current status and future plans. 


#### Courses
    Add our seminars.
    "Other possibly useful courses" could have data mining? narratives? Basically, it will tell potential graduate students we have nice courses here :)
	
	Yes. Still needs volumnteers to add those data. And we also support the seminar in our website, we keep use that to share our seminar information with others





## Common Issues

1. invalid yml format
<pre>
jekyll 3.6.0 | Error:  no implicit conversion of String into Integer
</pre>

Keep in mind that, yml is wired format, which require a space after the colon
":". 

