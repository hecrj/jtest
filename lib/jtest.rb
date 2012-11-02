#!/usr/bin/ruby

require "open-uri"
require "openssl"

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class JTest
	def initialize
		@problem_url = "https://www.jutge.org/problems/"
		@problem_title = /<title>Jutge :: Problem (.+?)<\/title>/
		@problem_samples = /<pre.+?>(.+?)<\/pre>/m
	end

	def new(pid)
		puts "Trying to find info about the problem: #{pid}"

		url = @problem_url + pid
		puts "Connecting to #{url}"
		source = open(url).read

		title = source.scan(@problem_title)[0][0]
		samples = source.scan(@problem_samples)

		puts "Creating new problem: #{title}"
		create(title, samples)
	end

	private
	def create(title, samples)
		title.gsub!(/_(.+?)\:/, '')
		title.gsub!(/\s/, '_')
		
		if Dir.exists?(title)
			Dir.glob("#{title}/*.{dat,out}") do |f|
				File.delete(f)
			end
		else
			Dir.mkdir(title)
			File.new("#{title}/main.cc", 'w')
		end

		samples.each_with_index do |sample, key|
			id = (key / 2) + 1
			name = "sample" + id.to_s

			if(key % 2 == 0)
				name += ".dat"
			else
				name += ".out"
			end

			File.open("#{title}/#{name}", 'w') do |f|
				f.write(sample[0])
			end
		end
	end
end
