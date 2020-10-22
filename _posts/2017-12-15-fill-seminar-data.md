---
layout: page
title: "First Utah Science Day"
date: 2017-01-13 16:31
mathjax : true
categories: news
---

Read me to learn how to fill in seminar data 
 <!--more-->¬

# Overview

We use the following data structure to organize our seminar info. Most recent seminar information will be shown on the front page of our website. 
- `key`: just like the `key` for a publication, this is a key for a talk, tutorial, presentation. A `/seminars/<key>.pdf` according to the talk also suggested to put into the corresponding path. 
- `title`: The title of the talk, seminar presentation.
- `presenter`: The name of the presenter, in future, we can post our nlp, ml seminar talk info here to attract other people to attend.
- `from_org`: The organization of the presenter.¬
- `year`: An integer value for the year value
- `month`: An integer value for the month value 
- `day`: An interger value for the day value 
- `time`: formated as 11:50AM - 01:10PM¬
- `address`: A string, such as MEB 3147¬
- `keynote`: The path to the keynote file , `/seminars/<key>.pdf`
- `abstract`: A brief and attractive abstract 

# Add Seminar

## Get Access to the repo
https://gitlab.flux.utah.edu/nlpml/nlp.cs.utah.edu

## Make a yml file according to the existed example
<code>
cd _data/seminars/
# think about a key for your seminar, it will also used for your keynote file or
seperated post.
cp 2018-01-01-readme.yml yyyy-mm-dd-<key>.yml 
### edit your file with any editor you like, then all is done.
</code>

### Attach your keynote.

You attach to any martieral to this seminar, such as your slides.
You have two choices when you want to share more than one file.

- zip them into one file
- write a new post as in our research blog, link the url to the `keynote` field.
To find the link to your post, the post should follow the link format as 
the permalink setting in our _config.yml file.
```/blog/:year/:month/:day/:title/```

### Test and Deploy

Please first test it on your local setting, by `jekyll serve` and then check it
in local url. Pay attention ot the "baseurl" setting in the _config.yml.
Your local url to browe it will be "https://127.0.0.1:4000/{baseurl}"


