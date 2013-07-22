require_relative "test_helper"

class TestController < Rulers::Controller
	def index
		@instance_var = "Here!"
		"Hello!"
	end
end

class TestApp < Rulers::Application
	def get_controller_and_action(env)
		[TestController, "index"]
	end
end

class RulersAppTest < Test::Unit::TestCase
	include Rack::Test::Methods

	def app
		TestApp.new
	end

	def test_request
		get "/"

		assert last_response.ok?
		body = last_response.body
		assert body["Hello"]
	end

	def test_get_controller_instance_variables
		controller = TestController.new({})
		controller.index
		instance_variables = controller.get_controller_locals()
		assert instance_variables[:instance_var] == "Here!", instance_variables.to_s
	end
end