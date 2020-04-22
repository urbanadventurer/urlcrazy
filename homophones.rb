class Homophones
	@@homophones=File.readlines($LOAD_PATH.first + "/homophones.txt").delete_if { |line| line =~ /^#/ or line =~ /^[ ]*$/ }.join

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
