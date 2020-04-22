# coding: utf-8

class CommonMisspellings
#pp CommonMisspellings.misspelling("zebra")
# wich->which, witch

# ENABLE_REVERSE_MISPELLING allows the reverse,
# which -> wich

# should work - accension->accession, ascension

# need to read this in a relative location
# needs to be "installable"

	$ENABLE_REVERSE_MISPELLING = true 

	@@file_contents=File.readlines($LOAD_PATH.first + "/common-misspellings.txt").delete_if { |line| line =~ /^#/ or line =~ /^[ ]*$/ }.join

	def self.dictionary
		setup unless defined? @@dictionary
		@@dictionary
	end

	def self.misspelling(w)
		setup unless defined? @@dictionary
		@@dictionary[w]
	end

	private

	def self.setup
		@@dictionary={}
		
		words_hash = @@file_contents.split("\n").map do |line| 
			line.downcase!
			y = line.split("->")
			[y[1],y[0]]
		end

		words_hash.map do |words,misspelling|
			words.split(',').each do |word|
				word.strip!
				@@dictionary[word] = misspelling
				# need to expand this into a matrix
				# 
				# wich->which, witch

				# which->wich
				# which->witch
				@@dictionary[misspelling] = word if $ENABLE_REVERSE_MISPELLING

				
				
			end
		end

	end
end
