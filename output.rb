class Output

	def initialize(this_domain, keyboard_layout, check_popularity, resolve_domains, show_invalid)
		@domain = this_domain
		@keyboard_layout = keyboard_layout
		@check_popularity = check_popularity
		@resolve_domains = resolve_domains
		@show_invalid = show_invalid
	end

	def hostnames_to_process
	end

	def header
	end

end

class OutputHuman < Output
	def header
		s =  "\n"
		s += "URLCrazy Domain Report\n"
		s += "Domain".ljust(10) +": #{@domain.domain}\n"
		s += "Keyboard".ljust(10) +": #{@keyboard_layout}\n"
		s += "At".ljust(10) +": #{Time.now}\n"
		puts_output s
	end


	def hostnames_to_process
		"# Please wait. #{@domain.typos.size} hostnames to process\n\n"
	end


	def table
		# output
		columns=Array.new
		widths=Array.new

	    headings=["Typo Type","Typo Domain","Valid","Pop","IP","Country","NameServer","MailServer"]
	
		( 0..headings.size - 1 ).each {|c| columns[c] = Array.new }

		# make report
		@domain.typos.each {|typo|
				columns[0] << typo.type.to_s
				columns[1] << typo.name.to_s
				columns[2] << typo.valid_name.to_s
				columns[3] << (@check_popularity == true ? typo.popularity.to_s : "?")				
				columns[4] << (@resolve_domains == true ? typo.resolved_a.to_s : "?" )

				columns[5] << if @resolve_domains == true
					if !typo.country_a.nil? and typo.country_a.any?
						"#{typo.country_a.last} (#{typo.country_a.first})"
					else
						""
					end
				else
					"?"
				end

				columns[6] << (@resolve_domains == true ? typo.resolved_ns.to_s : "?" )
				columns[7] << (@resolve_domains == true ? typo.resolved_mx.to_s : "?" )				
				#columns[7] << typo.extension.to_s
		}

		# trim unneeded columns
		unless @show_invalid
			headings -= ["Valid"] 
			columns[2] = nil
		end
		unless @check_popularity
			headings -= ["Pop"]
			columns[3] = nil
		end
		unless @resolve_domains
			headings -= ["IP"] 
			headings -= ["NameServer"] 
			headings -= ["MailServer"]
			columns[4] =nil
			columns[5] =nil
			columns[6] =nil
			columns[7] =nil
		end
		headings.compact!
		columns.compact!

		# print report columns
		columns.each_with_index {|column,i|
			widths[i]=((column.map {|row| row.nil? ? 0 : row.length } << headings[i].length).compact.sort[-1].to_i) + 2
			print_output headings[i].colorize(color: :blue, mode: :bold)
			print_output " " * (widths[i] - headings[i].length)
		}

		puts_output
		puts_output (widths.map {|w| "-" * w}.join).colorize(:blue)

		# print rows
		columns[0].each_with_index {|row,i|

			columns.each_with_index {|col,j|


				if row == "Original"
					print_output columns[j][i].colorize(color: :green, mode: :bold)
				else

					if i.even?
						print_output columns[j][i].colorize(mode: :bold)
					else
						print_output columns[j][i]
					end
				end
				print_output " " * (widths[j]-columns[j][i].length)
			}

			#puts
			#pp i			
			#pp columns[i].first
			#pp row


			puts_output
		}
		puts_output

	end
end

class OutputCSV < Output
	def table
		# output

	    headings = ["Typo Type","Typo","Valid","Pop","DNS-A","Country","CountryCode","DNS-NS","DNS-MX","Extn"]

		csv_string = CSV.new("", col_sep: ',', headers: true, force_quotes: true )

 		csv_string << headings
	
		# make report
		@domain.typos.each do |typo|
				csv_string << [typo.type.to_s,
								typo.name.to_s,
								typo.valid_name.to_s,
								typo.popularity.to_s,
								typo.resolved_a.to_s,
								(typo.country_a ? typo.country_a.last : ""),
								(typo.country_a ? typo.country_a.first : ""),
								typo.resolved_ns.to_s,
								typo.resolved_mx.to_s,
								typo.extension.to_s]
		end
		puts_output csv_string.string
	end
end

class OutputJSON < Output

	def table
		hash = { domain:@domain.domain,
							extension:@domain.extension, 
							tld:@domain.tld, 
							typos:( 
								@domain.typos.map do |typo| 
								{ 
									type:typo.type,
									name:typo.name, 
									valid_name:typo.valid_name,
									popularity:typo.popularity,
									resolved_a:typo.resolved_a,
									resolved_ns:typo.resolved_ns,
									resolved_mx:typo.resolved_mx,
									country:(typo.country_a ? typo.country_a.last : nil),
									country_code:(typo.country_a ? typo.country_a.first : nil),
	#							  registered_name:typo.registered_name,
	#								tld:typo.tld,
									extension:typo.extension, 
								} 
							end)  
						}

		puts_output hash.to_json
	end

end
