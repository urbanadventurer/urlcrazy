class Typo
  attr_accessor :type, :name, :valid_name, :tld, :extension, :registered_name, :popularity, :resolved_a, :resolved_mx, :resolved_ns, :country_a
  
  def get_resolved(task: Async::Task.current)
    @resolved_a = ""
    @resolved_mx = ""
    @resolved_ns = ""
    return if !@valid_name

    unless defined? @@resolver # Global Resolver
      $logger.debug "create resolver"
      # Create resolver with proper configuration
      @@resolver = Async::DNS::Resolver.new(ASYNC_DNS_SERVERS, timeout: 60)
    end
    
    # Use standard resolv as fallback if needed
    # resolver = Resolv::DNS.new(nameserver: DNS_SERVERS)
    # resolver.timeouts = [10, 30, 60]

    task.async do |subtask|
      begin
        addresses = @@resolver.query(@name, Resolv::DNS::Resource::IN::A)

        if addresses && addresses.answer && addresses.answer.first
          @resolved_a = addresses.answer.first.last.address.to_s
        end

        if @resolved_a && !@resolved_a.empty?
          @country_a = Countrylookup.ip2cc(@resolved_a)
        end

      rescue StandardError => e
        $logger.error "# Resolve A failure for #{@name}. #{e}"
        # Try standard Resolv as fallback
        begin
          std_resolver = Resolv::DNS.new
          std_resolver.timeouts = [5, 10, 15]
          @resolved_a = std_resolver.getaddress(@name).to_s
          @country_a = Countrylookup.ip2cc(@resolved_a) if @resolved_a && !@resolved_a.empty?
        rescue StandardError => e2
          $logger.debug "# Fallback resolve failure for #{@name}. #{e2}"
        end
      end
    end

    task.async do |subtask|
      begin
        addresses = @@resolver.query(@name, Resolv::DNS::Resource::IN::MX)

        if addresses && addresses.answer && addresses.answer.first
          @resolved_mx = addresses.answer.first.last.exchange.to_s
        end

      rescue StandardError => e
        $logger.error "# Resolve MX failure for #{@name}. #{e}"
        # Try standard Resolv as fallback
        begin
          std_resolver = Resolv::DNS.new
          std_resolver.getresources(@name, Resolv::DNS::Resource::IN::MX).each do |mx|
            @resolved_mx = mx.exchange.to_s
            break
          end
        rescue StandardError => e2
          $logger.debug "# Fallback MX resolve failure for #{@name}. #{e2}"
        end
      end
    end

    task.async do |subtask|
      begin           
        addresses = @@resolver.query(@name, Resolv::DNS::Resource::IN::NS)
        if addresses && addresses.answer && addresses.answer.first
          @resolved_ns = addresses.answer.first.last.name.to_s
        end

      rescue StandardError => e
        $logger.error "# Resolve NS failure for #{@name}. #{e}"
        # Try standard Resolv as fallback
        begin
          std_resolver = Resolv::DNS.new
          std_resolver.getresources(@name, Resolv::DNS::Resource::IN::NS).each do |ns|
            @resolved_ns = ns.name.to_s
            break
          end
        rescue StandardError => e2
          $logger.debug "# Fallback NS resolve failure for #{@name}. #{e2}"
        end
      end
    end

  end
  
  def get_popularity_google(task: Async::Task.current)
    # Google confuses dots for commas and spaces
    return "" if !@valid_name

    task.async do
      begin
        internet = Async::HTTP::Internet.new
        headers = [['User-Agent', 'Opera/9.20 (Windows NT 6.0; U; en)']]
        response = internet.get("https://www.google.com/search?q=%22#{@name}%22", headers)
        body = response.read
        @popularity = body.scan(/About ([\d,]+)/).flatten.first.delete(",").to_i
      rescue StandardError => e
        $logger.error "# Google popularity check failed for #{@name}: #{e.message}"
        @popularity = 0
      ensure
        response&.close
        internet&.close
      end
    end
  end

  def get_popularity_bing(task: Async::Task.current)
    return "" if !@valid_name

    task.async do
      begin
        internet = Async::HTTP::Internet.new
        headers = [['User-Agent', 'Wget/1.19.4 (linux-gnu)']]
        response = internet.get("https://www.bing.com/search?q=%22#{@name}%22&qs=n&first=10&FORM=PERE&setlang=en-us&setmkt=", headers)
        body = response.read
        r = body.scan(/<span class="sb_count">([^<]+)/).flatten.first
        if r
          @popularity = r.encode(Encoding.find('ASCII'), invalid: :replace, undef: :replace, replace: "").split[2]
        end
      rescue StandardError => e
        $logger.error "# Bing popularity check failed for #{@name}: #{e.message}"
        @popularity = nil
      ensure
        response&.close
        internet&.close
      end
    end
  end


end
