require "open-uri"
require "openssl"

module Jtest
  class Problem
    URL = "https://www.jutge.org/problems/"
    REGEXPS = {
      :title       => /<title>Jutge :: Problem (.+?)<\/title>/,
      :samples     => /<pre.+?>(.+?)<\/pre>/m,
      :dir_id      => /[0-9]+/,
      :invalid_url => "Wrong URL."
    }
    DEFAULT_OPTIONS = {:lang => 'en', :prefix => 'P', :dirname => nil}

    attr_reader :id
    attr_reader :title
    attr_reader :samples
    attr_reader :dirname

    def initialize(id, options = {})
      options = DEFAULT_OPTIONS.merge(options)

      @id = options[:prefix] + id.to_s + '_' + options[:lang]
      @title = nil
      @samples = []
      @dirname = options[:dirname]
    end

    def connect
      url = URL + @id
      @source = open(url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
    end

    def exists?
      connect if @source.nil?

      not @source.include? REGEXPS[:invalid_url]
    end

    def retrieve_info
      connect

      return false unless exists?

      @title = @source.scan(REGEXPS[:title])[0][0]
      @samples = @source.scan(REGEXPS[:samples]).flatten.each_slice(2).to_a
      @dirname = @title.gsub(/_(.+?)\:/, '').gsub(/\s/, '_') if @dirname.nil?

      return true
    end

    class << self
      def select(ids, options = {})
        options = DEFAULT_OPTIONS.merge(options)
        dirs = dirs_match(ids)

        problems = []
        dirs.each do |dir|
          REGEXPS[:dir_id].match(dir) do |match|
            options[:dirname] = dir
            problems << Problem.new(match, options) unless match.nil?
          end
        end

        return problems
      end

      def find(name)
        list_entry = /
        <td.+?>                       # Before problem id
          (P[0-9]+)                   # Capture problem id
        <\/.+?td>                     # After problem id
        \n                            # Line break
        \s+?                          # Possible whitespaces
        <td.+?>                       # Before problem title
          (                           # Capture problem title
            [^<>]*?                   # All characters except HTML tags
              #{Regexp.quote(name)}   # Match the given name
            [^<>]*?                   # Same as before
          )                           # End capture
        <\/.+?td>/x                   # After problem title

        source = open(URL, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read
        problems = source.scan(list_entry).flatten.each_slice(2).to_a

        return problems
      end

      private
      def dirs_match(ids)
        if ids == ["all"]
          dirs = Dir["[PX]*_*"]
        else
          dirs = []
          ids.each { |id| dirs += Dir["#{id}*"] }
        end

        return dirs
      end
    end
  end
end
