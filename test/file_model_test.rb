require "test_helper"

class FileModelTest < Test::Unit::TestCase
	include Rulers::Model

	def setup
		delete_db
	end

	def teardown
		delete_db
	end

	def delete_db
		files = Dir[File.join(BASE_DIR, "db/quotes/*.json")]
		files.each { |f|  File.delete(f) }
	end

	def test_should_save_and_load_new
		hash = {
			"submitter" => "test submitter",
			"quote" => "test quote",
			"attribution" => "test attribution"
		}
		FileModel.create(MultiJson.dump(hash))
		assert File.exists?(File.join(BASE_DIR, 
			"db/quotes/1.json"))
	end

end