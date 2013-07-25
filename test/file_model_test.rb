require "test_helper"

class FileModelTest < Test::Unit::TestCase
	include Rulers::Model

	def setup
		delete_db
	end

	def teardown
		# delete_db
	end

	def delete_db
		files = Dir[relative_path("db/quotes/*.json")]
		files.each { |f|  File.delete(f) }
	end

	def test_should_save_new
		hash = {
			"submitter" => "test submitter like a person",
			"quote" => "test quote like some words",
			"attribution" => "test attribution like who dun it"
		}
		FileModel.create(hash)
		assert_has_content("db/quotes/1.json", hash)
	end

	def assert_has_content(filename, hash)
		absolute_path = relative_path(filename)
		assert File.exists?(absolute_path)
		obj = File.read(absolute_path)
		loaded = MultiJson.load(obj)
		assert hash == loaded, "Hash not equal: #{hash}, #{loaded}"
	end

	def test_should_update_existing
		hash = {
			"submitter" => "test submitter",
			"quote" => "test quote",
			"attribution" => "test attribution"
		}
		quote = FileModel.create(hash)
		update_params = {
			"quote" => "updated quote",
			"attribution" => "updated attribution"
		}
		quote.update(update_params)
		quote.save!
		expected_content = {
			"submitter" => "test submitter",
			"quote" => "updated quote",
			"attribution" => "updated attribution"
		}
		assert_has_content("db/quotes/#{quote.id}.json", expected_content)
	end

	def relative_path(filename)
		File.join(BASE_DIR, filename)
	end

end