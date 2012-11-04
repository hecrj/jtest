module Jtest
  module Commands
    class Update < Thor::Group
      include Thor::Actions

      desc "Downloads the samples for every problem in the current working directory"
      argument :ids, :optional => true, :default => ["all"],
      :type => :array, :desc => "The problems ids to update, if not provided all problems are updated"
      class_option :lang, :type => :string, :aliases => '-l', :desc => "Language of the problem",
        :default => 'en'
      class_option :prefix, :type => :string, :aliases => '-p', :desc => "Prefix of the problem",
        :default => 'P'

      def select_problems
        @problems = Problem.select(ids, options)
      end

      def update_problems
        @problems.each do |problem|
          say_status :connecting, "Getting info about problem #{problem.id}..."
          problem.retrieve_info

          unless problem.exists?
            say_status :not_found, problem.id, :red
            next
          end

          say_status :found, problem.title, :green

          create_samples(problem)
        end
      end

      private
      def create_samples(problem)
        problem.samples.each_with_index do |sample, index|
          create_file "#{problem.dirname}/sample#{index+1}.dat", sample[0]
          create_file "#{problem.dirname}/sample#{index+1}.out", sample[1]
        end
      end
    end
  end
end
