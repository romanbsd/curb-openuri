require 'curl_agent'

module Kernel
  private
  alias open_uri_original_open open # :nodoc:

  # makes possible to open various resources including URIs.
  # If the first argument respond to `open' method,
  # the method is called with the rest arguments.
  #
  # If the first argument is a string which begins with xxx://,
  # it is parsed by URI.parse.  If the parsed object respond to `open' method,
  # the method is called with the rest arguments.
  #
  # Otherwise original open is called.
  #
  # Since open-uri.rb provides URI::HTTP#open, URI::HTTPS#open and
  # URI::FTP#open,
  # Kernel[#.]open can accepts such URIs and strings which begins with
  # http://, https:// and ftp://.
  # In these case, the opened file object is extended by OpenURI::Meta.
  def open(name, *rest, &block) # :doc:
    if name.respond_to?(:open)
      name.open(*rest, &block)
    elsif name.respond_to?(:to_s) && %r{\A(ftp|https?)://} =~ name
      CurlAgent.open(name, *rest, &block)
    else
      open_uri_original_open(name, *rest, &block)
    end
  end
  module_function :open
end
