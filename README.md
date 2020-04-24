[![License](https://img.shields.io/badge/license-Restricted-blue.svg)](https://raw.githubusercontent.com/urbanadventurer/urlcrazy/master/README.md) ![Stable Release](https://img.shields.io/badge/stable_release-0.6-blue.svg) [![Repositories](https://repology.org/badge/tiny-repos/urlcrazy.svg)](https://repology.org/project/urlcrazy/versions)

# URLCrazy

URLCrazy is an OSINT tool to generate and test domain typos or variations to detect or perform typo squatting, URL hijacking, phishing, and corporate espionage.

Homepage:  https://www.morningstarsecurity.com/research/urlcrazy


## Use Cases
* Detect typo squatters profiting from typos on your domain name
* Protect your brand by registering popular typos
* Identify typo domain names that will receive traffic intended for another domain
* Conduct phishing attacks during a penetration test

## Features
* Generates 15 types of domain variants
* Knows over 8000 common misspellings
* Supports bit flipping attacks
* Multiple keyboard layouts (qwerty, azerty, qwertz, dvorak)
* Checks if a domain variant is valid
* Test if domain variants are in use
* Estimate popularity of a domain variant


## Installation

### Install from a package manager

If you are using Kali Linux, Ubuntu or Debian use:

`$ sudo apt install urlcrazy`


### Install latest release

Visit https://github.com/urbanadventurer/urlcrazy/releases


### Install current development version

Be aware the latest development version may not be stable.

`$ git clone https://github.com/urbanadventurer/urlcrazy.git`


### Install Ruby

URLCrazy has been tested with Ruby versions 2.4 and 2.6.

If you are using Ubuntu or Debian use:

`$ sudo apt install ruby`


### Install Dependencies

`$ bundle`


## Usage

![urlcrazy-usage](https://user-images.githubusercontent.com/101783/80223861-ecb94e80-8659-11ea-9a28-1fa59a4dfbb9.gif)


### Simple Usage

`$ urlcrazy domain.com`

### With popularity estimate

`$ urlcrazy -p domain.com`

### Commandline Usage

```
Usage: ./urlcrazy [options] domain

Options
-k, --keyboard=LAYOUT  Options are: qwerty, azerty, qwertz, dvorak (default: qwerty)
-p, --popularity       Check domain popularity with Google
-r, --no-resolve       Do not resolve DNS
-i, --show-invalid     Show invalid domain names
-f, --format=TYPE      Human readable or CSV (default: human readable)
-o, --output=FILE      Output file
-n, --nocolor          Disable colour
-h, --help             This help
-v, --version          Print version information. This version is 0.7
```

## Types of Domain Variations Supported

### Character Omission
These typos are created by leaving out a letter of the domain name, one letter at a time. For example, www.goole.com and www.gogle.com

### Character Repeat
These typos are created by repeating a letter of the domain name. For example, www.ggoogle.com and www.gooogle.com

### Adjacent Character Swap
These typos are created by swapping the order of adjacent letters in the domain name. For example, www.googel.com and www.ogogle.com

### Adjacent Character Replacement
These typos are created by replacing each letter of the domain name with letters to the immediate left and right on the keyboard. For example, www.googke.com and www.goohle.com

### Double Character Replacement
These typos are created by replacing identical, consecutive letters of the domain name with letters to the immediate left and right on the keyboard. For example, www.gppgle.com and www.giigle.com

### Adjacent Character Insertion
These typos are created by inserting letters to the immediate left and right on the keyboard of each letter. For example, www.googhle.com and www.goopgle.com

### Missing Dot
These typos are created by omitting a dot from the domainname. For example, wwwgoogle.com and www.googlecom

### Strip Dashes
These typos are created by omitting a dash from the domainname. For example, www.domain-name.com becomes www.domainname.com

### Singular or Pluralise
These typos are created by making a singular domain plural and vice versa. For example, www.google.com becomes www.googles.com and www.games.co.nz becomes www.game.co.nz

### Common Misspellings
Over 8000 common misspellings from Wikipedia. For example, www.youtube.com becomes www.youtub.com and www.abseil.com becomes www.absail.com

### Vowel Swapping
Swap vowels within the domain name except for the first letter. For example, www.google.com becomes www.gaagle.com.

### Homophones
Over 450 sets of words that sound the same when spoken. For example, www.base.com becomes www.bass.com.

### Bit Flipping
Each letter in a domain name is an 8bit character. The character is substituted with the set of valid characters that can be made after a single bit flip. For example, facebook.com becomes bacebook.com, dacebook.com, faaebook.com,fabebook.com,facabook.com, etc.

### Homoglyphs
One or more characters that look similar to another character but are different are called homogylphs. An example is that the lower case l looks similar to the numeral one, e.g. l vs 1. For example, google.com becomes goog1e.com.

### Wrong Top Level Domain
For example, www.trademe.co.nz becomes www.trademe.co.nz and www.google.com becomes www.google.org
Uses the 19 most common top level domains.

### Wrong Second Level Domain
Uses an alternate, valid second level domain for the top level domain.
For example, www.trademe.co.nz becomes www.trademe.ac.nz and www.trademe.iwi.nz


## Supported Keyboard Layouts

Keyboard layouts supported are:

* QWERTY
* AZERTY
* QWERTZ
* DVORAK

## Is the domain valid?

URLCrazy has a database of valid top level and second level domains. This information has been compiled from Wikipedia and domain registrars. We know whether a domain is valid by checking if it matches toplevel and second level domains. For example, www.trademe.co.bz is a valid domain in Belize which allows any second level domain registrations but www.trademe.xo.nz isn't because xo.nz isn't an allowed second level domain in New Zealand.


## Popularity Estimate

URLCrazy pioneered the technique of estimating the relative popularity of a typo from search engine results data. By measuring how many times a typo appears in webpages, we can estimate how popular that typo will be made when users type in a URL.

The inherent limitation of this technique, is that a typo for one domain, can be a legitimate domain in its own right. For example, googles.com is a typo of google.com but it also a legitimate domain.

For example, consider the following typos for google.com.

| Count. | Typo         |
| ------ | ------------ |
| 25424  | gogle.com    |
| 24031  | googel.com   |
| 22490  | gooogle.com  |
| 19172  | googles.com  |
| 19148  | goole.com    |
| 18855  | googl.com    |
| 17842  | ggoogle.com  |


## Known Issues

### Macos File Descriptor Limit
If DNS resolution fails under Macos it could be due to the small default file descriptor limit.

To display the current file descriptor limit use:

`$ ulimit -a`

To increase the file descriptor limit use:

`$ ulimit -n 10000`


## URLCrazy Appearances

### Kali Linux
URLCrazy was a default tool in BackTrack 5, and later Kali Linux.
https://tools.kali.org/information-gathering/urlcrazy

### The Browser Hacker's Handbook
Authored by Wade Alcorn, Christian Frichot, and Michele Orru.

URLCrazy is included in Chapter 2 of this seminal work on the topic.

### PTES Technical Guidelines
Penetration Testing Execution Standard (PTES) is a standard designed to provide a common language and scope for performing penetration testing (i.e. Security evaluations). URLCrazy is included in the Tools Required section.

http://www.pentest-standard.org/index.php/PTES_Technical_Guidelines


## See Also

URLCrazy was first published in 2009, and for many years was the most advanced opensource tool for studying typosquatting. Since then multiple other tools have been developed by the infosec community.

### DNSTwist

DNSTwist is developed by Marcin Ulikowski and first published in 2015. DNSTwist had a significant feature overlap with URLCrazy at the time, and introduced many new features.

Language: Python

https://github.com/elceef/dnstwist

### URLInsane

URLInsane was developed by Rangertaha in 2018 and claims to match the features of URLCrazy and DNSTwist.

Language: Go

https://github.com/cybint/urlinsane

### DomainFuzz

DomainFuzz was developed by monkeym4sterin 2017.
Language: Node.JS

https://github.com/monkeym4ster/DomainFuzz


## Authors and Acknowledgement

- Authored by Andrew Horton (urbanadventurer).
- Thanks to Ruby on Rails for Inflector which allows plural and singular permutations.
- Thanks to Wikipedia for the set of common misspellings, homophones, and homoglyphs.
- Thanks to software77.net for their IP to country database

## Community

If you have any questions, comments or concerns regarding URLCrazy, please consult the documentation prior to contacting one of the developers. Your feedback is always welcome.


## License

Copyright Andrew Horton, 2012-2020. You have permission to use and distribute this software. You do not have permission to distribute modified versions without permission. You do not have permission to use this as part of a commercial service unless it forms part of a penetration testing service. For example a commercial service that provides domain protection for clients must obtain a license first. Email me if you require a license.

