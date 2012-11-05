require 'helper'

class TestProblem < Test::Unit::TestCase
	def setup
		
	end

	should "retrieve problem information correctly" do
		problem = Jtest::Problem.new("93774") # Fractal pictures
		problem.retrieve_info
		
		assert problem.exists?
		assert_equal("P93774_en: Fractal pictures", problem.title)
	end

	should "if an invalid problem id is given" do
		problem = Jtest::Problem.new("Chunky_bacon")

		assert !problem.exists?
	end
end
