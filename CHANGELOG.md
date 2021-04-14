New in Version 0.7.3 (14 April 2021)

🛠 Minor update with some bug fixes and improvements to the README.md.

## Bug Fixes
* Fixed #3 (Invalid domain name against ".co" domain) by updating the .co (Colombia) record to permit 2nd level registration
* Added Gemfile.lock to the .gitignore.

## Misc
* Updated README with minor modifications including adding emojis. Thanks to @MatthewFlannery for a minor edit.
* Added .gitignore to repo

New in Version 0.7.2 (5 January 2021)

## Bug Fixes
* Fixed #6 bug where output to a file didn't work

## Misc
* Check gem dependencies are installed, and show a message if they are not


New in Version 0.7.1 (26 April 2020)

## Features
* Added --debug to show debugging output for development

## Bug Fixes
* No longer requires pry gem unless debugging
* Checks for a low ulimit and shows a warning

## Misc
* Fixed typo in README
* Updated Installation instructions


New in Version 0.7 (24 April 2020)

## Features
* Now checks all country and International TLDs
* Now checks all country SLDs
* Added insert dashes Typo
* Event-driven asynchronous DNS resolution with Async (https://github.com/socketry/async)
* Added JSON output

## Bug Fixes
* Fixed non-threadsafe bug with Country IP address lookups
* Fixed PATH issue when executing from a current working directory outside the URLCrazy folders
* Fixed popularity scan. Now uses Bing.com search engine results count.

## Misc
* Updated Common Misspellings
* Updated Homophones
* Updated Country Database
* Fixed whitespace indendation
* Updated ASCII banner colours
* Updated README

  
New in Version 0.6 (September 2017)

## Background
Version 0.6 is a major release and may break compatibility with previous versions.

This version has taken a few years to be released. Source-code for version 0.6 was first posted to GitHub in September 2016. Unfortunately for users, this development version was incomplete as it was missing some crucial files. It was not until April 2020, that version 0.6 was repackaged and made available for use.

## Features
* Added ASCII banners
* Colorized output
* Increased DNS performance by using asynchronous DNS resolution
* Included fast public DNS servers from Google, VeriSign and Level3
* Added NameServer to output
* Added IP to country support

## Bug Fixes
* Fixed CSV output bug
* Fixed bug with - warning: duplicated key at line 89 ignored: "2nd_level_registration"

## Misc
* Changed to MarkDown format for README and CHANGELOG
* Added bundler support
* Updated TAB/spacing
* Updated common misspellings list 
* Updated Country Database (April, 2020)


New in Version 0.5 (15 July 2012)

## Features
* CSV output
* Output files
* Double character replacement typos
* Homoglyphs - used https://en.wikipedia.org/wiki/Homoglyph

## Misc
* Support for Ruby 1.9.1
* No longer checks domain popularity by default
* Updated some text
* Updated common misspellings from http://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings/For_machines


New in Version 0.4 (13 September 2011)

* Bitflipping domains
* Homophone domains (Words that sound the same)
* Vowel swap Typos

