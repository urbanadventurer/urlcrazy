class Homophones
	@@homophones=File.readlines(File.expand_path(File.join(File.dirname(__FILE__), "homophones.txt"))).delete_if { |line| line =~ /^#/ or line =~ /^[ ]*$/ }.join

	def self.dictionary
		setup unless defined? @@dictionary
		@@dictionary
	end

	private

	def self.setup
		@@word_sets = @@homophones.each_line.map { |x| x.downcase.strip.split(",") }
		@@dictionary = {};
		@@word_sets.each { |set| set.each {|word| @@dictionary[word] = set  } }
	end
end
