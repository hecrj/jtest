require "htmlentities"
require "jtest/problem"

module Jtest
  module Commands
    class Find < Thor::Group
      include Thor::Actions

      desc "Finds all the problems that match with the given name"
      
      argument :name, :type => :string, :desc => "A problem name to match"

      def get_problems
        say_status :working, "Trying to find problems that match: #{name}", :yellow
        @problems = Problem.find(name)
      end

      def show_problems
        coder = HTMLEntities.new
        @problems.each do |problem|
          say_status problem[0], coder.decode(problem[1]), :blue
        end

        if @problems.empty?
          say_status :not_found, "0 matches found :(", :red
        else
          say_status :found,
            "#{@problems.size} match#{'es' if @problems.size != 1} found!",
            :green
        end
      end
    end
  end
end
