require 'helper'

class TestJtest < Test::Unit::TestCase
	def setup
		@jtest = Jtest.new
	end

	should "create a problem with its samples" do
		@jtest.new("P93774_en")

		assert(Dir.exists?("P93774_Fractal_pictures"))
	end
end
