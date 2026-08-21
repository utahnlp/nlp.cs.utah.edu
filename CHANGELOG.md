# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org).

## - 2026-08-21

### Added
- New 2026 cohort of students/postdocs.
- New group pictures from spring 2026.
- Added 2026 bibliography.
- README instructions for running website locally.
- Started changelog (this document).

### Changed
- Carousel
    - Renamed pictures using dates from Slack #hangout page. Carousel is now reverse chronological (most recent first). 
    - Carousel pictures are now slightly smaller (650px height to 550px height) to avoid crowding screens.
    - Moved welcome message above carousel.
- People
    - Moved students according to degree changes (e.g. undergrad -> masters, doctoral -> alumni).
    - Separated students from `graduates.yml` into `postdocs.yml`, `doctoral.yml`, and `masters.yml` for clarity.
    - Changed people page to use custom 7-column format rather than 6, to fit more pictures in each row.
    - Moved postdocs next to faculty on people page to effectively use space. Maintains vertical alignment on smaller screens.
- Publications
    - Consolidated pre-2015 publications into single .bib file. They now correspond to a single "pre-2015" tab in the year navigator on the left.
    - Adjusted offset when clicking on year navigator to include year heading.

### Removed
- Removed old pictures that don't contain multiple active lab members (excluding faculty). This is necessary to make space for more recent group pictures. They are now in [assets/images/old_carousel](assets/images/old_carousel).
