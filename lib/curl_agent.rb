require 'rubygems'
require 'stringio'
require 'curb'

class CurlAgent
  def initialize(url)
    @curl = Curl::Easy.new(url)
    # Defaults
    @curl.headers['User-Agent'] = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.0.4) Gecko/2008102920 Firefox/3.0.4'
    @curl.follow_location = true
    @curl.max_redirects = 2
    @curl.enable_cookies = true
    @curl.connect_timeout = 5
    @curl.timeout = 30
  end

  # Return the charset of the page
  def charset
    return '' unless @curl.content_type
    @curl.content_type.match(/charset\s*=\s*([a-zA-Z0-9-]+)/ni) ? $1.downcase : ''
  end

  # Proxy all calls to Curl::Easy instance
  def respond_to?(symbol)
    @curl.respond_to?(symbol)
  end

  # Proxy all calls to Curl::Easy instance
  def method_missing(symbol, *args)
    @curl.send(symbol, *args)
  end

  # One stop shop
  def self.open(name, *rest, &block)
    mode, perm, rest = scan_open_optional_arguments(*rest)
    options = rest.shift if !rest.empty? && Hash === rest.first
    raise ArgumentError.new("extra arguments") if !rest.empty?

    unless mode == nil || mode == 'r' || mode == 'rb' || mode == File::RDONLY
      raise ArgumentError.new("invalid access mode #{mode} (resource is read only.)")
    end

    agent = CurlAgent.new(name)

    options ||= {}
    options.each {|k, v|
      # Strings will be passed as headers, as in original open-uri
      next unless k.is_a? Symbol
      agent.send("#{k}=".intern, v)
      options.delete(k)
    }
    # All that's left should be considered headers
    agent.headers.merge!(options)

    agent.perform
    io = StringIO.new(agent.body_str)
    if block
      block.call(io)
    else
      io
    end
  end

  def self.scan_open_optional_arguments(*rest) # :nodoc:
    if !rest.empty? && (String === rest.first || Integer === rest.first)
      mode = rest.shift
      if !rest.empty? && Integer === rest.first
        perm = rest.shift
      end
    end
    return mode, perm, rest
  end
end
