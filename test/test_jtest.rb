require 'helper'

class TestJtest < Test::Unit::TestCase
	def setup
		@jtest = Jtest::CLI.new
	end

	should "create a problem with its samples" do
		@jtest.new("93774")

		assert(Dir.exists?("P93774_Fractal_pictures"))

    @jtest.remove_file("P93774_Fractal_pictures")
	end
end
