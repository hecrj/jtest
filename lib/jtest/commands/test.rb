module Jtest
  module Commands
    class Test < Thor::Group
      include Thor::Actions

      desc "Performs tests for all the problems on the current working directory"
      argument :ids, :optional => true, :default => ["all"],
      :type => :array, :desc => "The problems ids to test, if not provided all problems are tested"
      

      def select_problem_dirs
        @problems = Problem.select(ids)
      end

      def perform_tests
        @counter = { :failed => 0, :missing => 0, :wrong => 0, :passed => 0 }

        @problems.each do |problem|
          next unless File.directory?(problem.dirname)
          
          say_status :testing, "Running tests on #{problem.dirname}...", :blue
          Dir.chdir(problem.dirname) { perform_test(problem.dirname) }
        end
        
        colors = { :failed => :magenta, :missing => :yellow, :wrong => :red, :passed => :green }
        summary(colors)
      end

      private
      def perform_test(dir)
        unless File.exists?('Makefile')
          say_status :missing, "#{dir}/Makefile", :magenta
          return
        end

        samples = Dir["sample*.dat"].collect { |x| x.chomp('.dat') }
        samples.sort!

        if samples.empty?
          say_status :nosamples, "#{dir}/", :blue
          return
        end
        
        say_status :compile, "make test", :blue
        compiled = system("make test")

        unless compiled
          result :failed, "make test", :red
          return
        end

        samples.each do |sample|
          say_status :running, "#{dir}/#{sample}.dat", :blue
          execution = system("./test < #{sample}.dat > #{sample}_test.out")

          unless execution
            result :failed, "#{dir}/#{sample}.dat", :magenta
            next
          end

          unless File.exists?("#{sample}.out")
            result :missing, "#{dir}/#{sample}.out", :yellow
            next
          end

          if FileUtils.cmp("#{sample}.out", "#{sample}_test.out")
            result :passed, "#{dir}/#{sample}.out", :green
            remove_file "#{dir}/#{sample}_test.out", :verbose => false
          else
            result :wrong, "#{dir}/#{sample}.out", :red
          end
        end

        remove_file "#{dir}/test", :verbose => false
      end

      def result(type, msg, color)
        say_status type, msg, color
        @counter[type] += 1
      end

      def summary(colors)
        say "-" * terminal_width

        total = 0
        @counter.each do |key, value|
          say_status key, value, colors[key]
          total += value
        end

        say_status :total, total, :blue
        say "-" * terminal_width
        say_status :perfect, "All tests passed correctly!", :green  if @counter[:passed] == total
      end
    end
  end
end