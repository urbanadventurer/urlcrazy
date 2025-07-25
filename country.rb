class Countrylookup
# This is borrowed from WhatWeb

# Lookup code developed by Matthias Wachter for rubyquiz.com and used with permission.
# Local IPv4 addresses are represented as ZZ according to an ISO convention.

# How to Update Database
# ----------------------
# rm plugins/country-ips.dat plugins/IpToCountry.csv
# wget software77.net/geo-ip/?DL=1 -O plugins/IpToCountry.csv.gz
# gzip -d plugins/IpToCountry.csv.gz

def Countrylookup.startup
# ok, set up @rfile. open once.
folder=File.expand_path(File.dirname(__FILE__))	
country_db = folder + "/country-ips.dat"

if File.exist?(country_db)
  @rfile=File.open(country_db,"rb")
else
  if File.exist?(folder + "/IpToCountry.csv")
		# pack that file & do it once
   last_start=nil
   last_end=nil
   last_country=nil
   File.open(folder + "/country-ips.dat","wb") do |wfile|
    IO.foreach(folder + "/IpToCountry.csv") do |line|
      next if line[0..0] =="#"
      next if !(line =~ /^"/ )
      s,e,d1,d2,co=line.delete!("\"").split(",")
      s,e = s.to_i,e.to_i
      if !last_start
						# initialize with first entry
						last_start,last_end,last_country = s,e,co
					else
						if s==last_end+1 and co==last_country
							# squeeze if successive ranges have zero gap
							last_end=e
						else
							# append last entry, remember new one
							wfile << [last_start,last_end,last_country].pack("NNa2")
							last_start,last_end,last_country = s,e,co
						end
					end
				end
				# print last entry
				if last_start
					wfile << [last_start,last_end,last_country].pack("NNa2")
				end
			end
			# open the DB now
			@rfile=File.open(country_db,"rb")
		else
      raise "Aborting: Cannot find country database."
    end
  end

  f = folder + "/country-codes.txt"
  @ccnames={};
  File.open(f,"r:UTF-8").readlines.each do |line|
    x=line.split(",");
    @ccnames[x[1]] = x[0]
  end
end


def Countrylookup.ip2cc(ip)
  found=[]

  $semaphore_countrylookup.synchronize do

    if @rfile and ip and ip =~ /^([0-9]{1,3}\.){3}[0-9]{1,3}$/
      @rfile.seek(0,IO::SEEK_END)
      record_max=@rfile.pos/10-1

	    # build a 4-char string representation of IP address
	    # in network byte order so it can be a string compare below
	    ipstr= ip.split(".").map {|x| x.to_i.chr}.join

	    # low/high water marks initialized
	    low,high=0,record_max
	    while true
	      mid=(low+high)/2       # binary search median
	      @rfile.seek(10*mid)     # one record is 10 byte, seek to position
	      str=@rfile.read(8)      # for range matching, we need only 8 bytes
	      # at comparison, values are big endian, i.e. packed("N")
	      if ipstr>=str[0,4]     # is this IP not below the current range?
		      if ipstr<=str[4,4]   # is this IP not above the current range?
      		  #puts  # a perfect match, voila!
      		  cc=@rfile.read(2)
            found = [cc,@ccnames[cc]]
            break
          else
      		  low=mid+1          # binary search: raise lower limit
      		end
        else
        	high=mid-1           # binary search: reduce upper limit
        end
	      if low>high            # no entries left? nothing found		
  			#m << {:string=>"No country"}	
        break
        end
      end
    end
  end
  found
end

end

