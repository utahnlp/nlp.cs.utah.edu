---
layout: default
title: Publications
should_include_js: True
js_file: "/assets/js/pubs.js"
---

{% assign pubs = site.data.processed.pubs %}

<div class = "row">


  <input class="form-control" id="search-input" type="text" placeholder="Search.."/>
  <div>
    <a href="{{ "/assets/utahnlp.bib" | prepend:site.baseurl }}">
      BibTeX file with all UtahNLP  papers
    </a>
  </div>

  <div id="papers">

    {% for year in pubs.years %}

    <h3> {{ year }} </h3>

    <ul>

      {% for paper in  pubs.by_year[year] %}

      <li>
        <div id="{{paper.key}}">
          <p>
            {{paper.citation}}
            <a href="{{paper.link}}">[link to paper]</a>
            
            <a data-toggle="collapse"
               href="#bib-{{paper.key}}"
               role="button"
               aria-expanded="false"
               aria-controls="bib-{{paper.key}}">
              [bib entry]
            </a>
            {% if paper.has_award %}
                <br/>
                <span class="text-capitalize">
                   <strong><em><mark>{{paper.award_info}}</mark></em></strong>
                </span>
            {% endif %}
            <div class="collapse" id="bib-{{paper.key}}">
              <pre><code>{{paper.bib}}</code></pre>
            </div>

          </p>
        </div>
      </li>

      {% endfor %}
      
    </ul>
    {% endfor %}
    
  </div>
</div>
