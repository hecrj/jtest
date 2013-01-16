require "jtest/problem"

module Jtest
  module Commands
    class New < Thor::Group
      include Thor::Actions

      desc "Creates a workspace to solve problem with the given id"
      
      argument :id, :type => :numeric, :desc => "The problem identifier"
      class_option :lang, :type => :string, :aliases => '-l', :desc => "Language of the problem",
        :default => 'en'
      class_option :prefix, :type => :string, :aliases => '-p', :desc => "Prefix of the problem",
        :default => 'P'

      def get_problem_info
        @problem = Problem.new(id, options)

        say_status :connecting, "Getting info about problem #{@problem.id}...", :yellow
        @problem.retrieve_info
        
        raise "Problem #{@problem.id} not found :(" unless @problem.exists?
        
        say_status :found, @problem.title, :green
      end

      def create_workspace
        say_status :working, "Creating workspace for #{@problem.title}", :yellow

        empty_directory @problem.dirname

        @problem.samples.each_with_index do |sample, index|
          create_file "#{@problem.dirname}/sample#{index+1}.dat", sample[0]
          create_file "#{@problem.dirname}/sample#{index+1}.out", sample[1]
        end
      end
    end
  end
end
