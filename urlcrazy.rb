#!/usr/bin/env ruby
require 'getoptlong'
require 'singleton'
require 'inflector.rb'
require 'tld.rb'
require 'pp'
require 'socket'
require 'net/http'

$VERSION="0.2"

=begin
Title:          UrlCrazy Readme
Version:        0.2
Description:    UrlCrazy is for the study of domainname typos / url hijacking.
Release Date:   March 2009
Author:         horton.nz{at-nospam}gmail, Andrew Horton (urbanadventurer)
Primary-site:   code.google.com/p/urlcrazy
Platforms:      Linux, Anything with Ruby
Copying-policy: BSD

Read the README file

TO DO:
new typo - repeating characters

new typo - wrong tld.
anything to .com,  anything like .org.nz to .co.nz or .org.au to .com.au

new typo - common misspellings
vowel swap, phonetic spelling

new typo - subtitution of doublecharacters. google => giigle

show only unique typos

sort results with valid domains 1st

confirm popularity results - -  compare popularity vs. AOL search histories

make gui that shows :

domain __________________ GO

domainname 	typo-type 	typo		popularity	tld	valid  	resolves	whois
yahoo.com	missing-dot	yahoocom	149,000		-	n	-		AVAILABLE
dog.co.uk	pluralize	dogs.co.uk	45,000		.co.uk	y	210.2.4.5 [UK]	?

cache/	save results in mysql or text files

let ppl register domains from the gui version

* A common misspelling, or foreign language spelling, of the intended site: exemple.com
phonetic misspelling. OPERATOR vs OPERATAR
	http://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings/For_machines
	
	double letter -> single letter, vice versa
	ili => il
	c => s
	vowel swap (never start of word)
	y + > ie
	ei = > ie
	

* A different top-level domain: example.org
.com or .co versions. whitehouse.com instead of whitehouse.gov

maybe use http://whois.rubyforge.org/rdoc/ for whois info
maybe use maxmind geoip for countries of IPs -- maybe not as useful coz that's just where it's hosted

Similar but not related are domains that look the same but are different. change l for 1 etc

what this provides that strider doesn't?
shows potential domain typo popularity
shows available domain typos that aren't hijacked -- no whois yet
focused on finding typos more than discovering sites using typos to serve ads
discovers more classes of typos

crashes on some short inputs
=end

class Keyboard
def initialize()
	@rows=["1234567890-","qwertyuiop","asdfghjkl","zxcvbnm"]
end

def key_left(char)
 r=row(char)
 return nil if r.nil?
 return nil if r.index(char)==0  # already far left
 r[r.index(char)-1].nil? ? nil : "%c" % r[r.index(char)-1]
end

def key_right(char)
 r=row(char)
 return nil if r.nil?
 return nil if r.index(char)==r.length-1  # already far right
 r[r.index(char)+1].nil? ? nil : "%c" % r[r.index(char)+1]
end

def row(char)
 #returns keyboard. eg. qwertyuiop  or nil if not found
 r=@rows.map {|k| k if k.include?(char) }.compact.to_s
 r.empty? ? nil : r
end
end



class Typo
attr_accessor :type, :name, :valid_name, :resolved, :tld, :extension, :registered_name

def resolved
	return "" if !@valid_name
	begin 
		r=IPSocket.getaddress(@name)
		return r
	rescue
		return ""
	end
end

def popularity
	# cuil.com is good.
	# google confuses dots for commas and spaces

	return "" if !@valid_name
	begin
		results=Net::HTTP.get URI.parse("http://www.cuil.com/search?q=%22#{@name}%22")
		r=results.scan(/[0-9,]* results for/).to_s.split(" ")[0].delete(",").to_i
	rescue
		return 0
	end
	return r
end

end


class Domainname
attr_accessor :domain, :registered_name, :tld, :extension,:valid, :typos

def initialize(s)
	@domain=s
	@registered_name=TLD.new.registered_name(@domain)
	@tld=TLD.new.tld(@domain)
	@extension=TLD.new.extension(@domain)
	@valid=TLD.new.valid_domain?(@domain)
	@typos=Array.new
end

def create_typos
	self.character_omission.sort.uniq.each {|c|
		t=Typo.new
		t.type ="Character Omission"
		t.name=c
		@typos<<t
	}
	
	self.character_swap.sort.uniq.each {|c|
		t=Typo.new
		t.type ="Character Swap"
		t.name=c
		@typos<<t
	}
	self.character_replacement.sort.uniq.each {|c|
		t=Typo.new
		t.type ="Character Replacement"
		t.name=c
		@typos<<t
	}
	self.character_insertion.sort.uniq.each {|c|
		t=Typo.new
		t.type ="Character Insertion"
		t.name=c
		@typos<<t
	}

	self.missingdot.sort.uniq.each {|c|
		t=Typo.new
		t.type ="Missing Dot"
		t.name=c
		@typos<<t
	}
	
	self.stripdashes.sort.uniq.each {|c|
		t=Typo.new
		t.type ="Strip Dashes"
		t.name=c
		@typos<<t
	}

	self.singular_or_pluralise.sort.uniq.each {|c|
		t=Typo.new
		t.type ="Singular or Pluralise"
		t.name=c
		@typos<<t
	}

	tld=TLD.new
	@typos.each {|t|
		t.valid_name = tld.valid_domain?(t.name)
		t.tld = tld.tld(t.name)
		t.registered_name = tld.registered_name(t.name)
		t.extension = tld.extension(t.name)
	}

end


def character_omission
	(0..@domain.length-2).map {|i|	@domain[0..i].to_s + @domain[i+2..@domain.length] }
end

def character_swap
	(0..@domain.length-2).map {|i|
		d=@domain.split(//) #split string to chars
		d[i],d[i+1]=d[i+1],d[i] # swap array elements
		d.join #
	}
end

def character_replacement
kb=Keyboard.new
list=Array.new
(0..@domain.length-1).each {|i|

	keyleft=kb.key_left(@domain[i..i])
	if !keyleft.nil?
		x=@domain.dup
		x[i]=keyleft
		list << x
	
	end

	keyright=kb.key_right(@domain[i..i])
	if !keyright.nil?
		x=@domain.dup
		x[i]=keyright
		list << x
	end
}
list
end

def character_insertion
kb=Keyboard.new
list=Array.new
(0..@domain.length-1).each {|i|
	keyleft=kb.key_left(@domain[i..i])
	if !keyleft.nil?
		list << @domain[0..i] + keyleft + @domain[i+1..-1]
	
	end

	list << @domain[0..i] + @domain[i..i] + @domain[i+1..-1]

	keyright=kb.key_right(@domain[i..i])
	if !keyright.nil?
		list << @domain[0..i] + keyright + @domain[i+1..-1]
	end
}
list
end



def missingdot
	list=Array.new
	# first add www to the domain like wwwyahoo.com
	list << "www"+@domain
	dotindex=0
        while dotindex=@domain.index(".",dotindex+1) do
		domain_array=@domain.split(//)
		domain_array.delete_at(dotindex)
		list << domain_array.join
	end
	# if a domain doesn't have an extension, add .com like a webbrowser does
	list.each {|d| d<<".com" if !d.include?(".") }
end


def stripdashes
	@domain.delete("-")
end


def singular_or_pluralise
	list= Array.new
	list << ActiveSupport::Inflector.singularize(@registered_name)+"."+@extension.to_s
	list << ActiveSupport::Inflector.pluralize(@registered_name)+"."+@extension.to_s
	list.delete(@domain)
	list
end

end


def usage 
print "Usage: #{$0} [options] domainname
urlcrazy generates and tests domainname typo permutations to study typo squatting / url hijacking.

Typo types :
Character Omission, Adjacent Character Swap, Adjacent Character Replacement, Adjacent Character Insertion, Missing Dot, Strip Dashes, Singular or Pluralise.

Options
 -p, --no-popularity	Do not check popularity (default : check)
 -r, --no-resolve	Do not resolve domain names (default : check) 
 -V, --version   	Print version information. This version is #{$VERSION}

Submit bugs to Andrew Horton (urbanadventurer) at http://code.google.com/p/urlcrazy/

"

end


# -----------------------------------------------------------------
check_popularity=true
resolve_domains=true

 opts = GetoptLong.new(
      [ '--help', '-h', GetoptLong::NO_ARGUMENT ],
      [ '--no-resolve','-r', GetoptLong::NO_ARGUMENT ],
      [ '--no-popularity','-p', GetoptLong::NO_ARGUMENT ],
      [ '-V','--version', GetoptLong::NO_ARGUMENT ]
    )
 opts.each do |opt, arg|
    case opt
        when '--help'
                usage
                exit
        when '--no-resolve','-r'
                resolve_domains=false 
        when '--no-popularity','-p'
                check_popularity=false 
        when '-V','--version'
                puts $VERSION; exit
    end
 end

if ARGV.length < 1
        usage
        exit
end



d=Domainname.new(ARGV[0].downcase)
abort "Aborting. Invalid domainname." unless d.valid == true
puts "#Please wait ... generating typo's for #{d.domain}"

d.create_typos

columns=Array.new
widths=Array.new
headings=Array.new
(0..6).each {|c| columns[c]=Array.new }

headings[0]="Domain"
headings[1]="Typo Type"
headings[2]="Typo"
headings[3]="Valid?"
headings[4]="sld.tld"
headings[5]="Popularity"
headings[6]="IP"

d.typos.each {|typo|
	columns[0] << d.domain.to_s
	columns[1] << typo.type.to_s
	columns[2] << typo.name.to_s
	columns[3] << (typo.valid_name ? 'y' : 'n')
	columns[4] << typo.extension.to_s
	columns[5] << (check_popularity == true ? typo.popularity.to_s : "?")
	columns[6] << (resolve_domains == true ? typo.resolved.to_s : "?" )
}

columns.each_with_index {|column,i|
	widths[i]=((column.map {|row| row.nil? ? 0 : row.length } << headings[i].length).compact.sort[-1].to_i) + 4
	print headings[i]
	print " " * (widths[i] - headings[i].length)
}
print "\n"

columns[0].each_with_index {|row,i|
	columns.each_with_index {|col,j|
		print columns[j][i]
		print " " * (widths[j]-columns[j][i].length)
	}
	print "\n"
}

