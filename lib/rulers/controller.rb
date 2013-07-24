require 'erubis'
require 'rulers/file_model'
require_relative 'version'

module Rulers
	class Controller
      include Rulers::Model
	  	def initialize(env)
	  		@env = env
	  	end

	  	def env
	  		@env["RULERS_VERSION"] = VERSION
	  		@env
	  	end

	  	def render(view_name, locals = {})
	  		filename = File.join "app", "views",
	  			controller_name, "#{view_name}.html.erb"
  			template = File.read filename
  			eruby = Erubis::Eruby.new(template)
  			view_locals = locals.merge(:env => env).merge(get_controller_locals)
  			eruby.result view_locals
  		end

  		def get_controller_locals()
  			locals = {}
  			self.instance_variables.each do |var|
  				locals[var.to_s.sub('@', '').to_sym] = self.instance_variable_get var
			end
			locals 
  		end

  		def controller_name
  			klass = self.class
  			klass = klass.to_s.gsub /Controller$/, ""
  			Rulers.to_underscore klass
  		end
  	end
end