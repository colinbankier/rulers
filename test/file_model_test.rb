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
			"submitter" => "test submitter",
			"quote" => "test quote",
			"attribution" => "test attribution"
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

	def test_should_find_by_attr
		hash = {
			"submitter" => "a person",
			"quote" => "some words",
			"attribution" => "old fogie"
		}
		FileModel.create(hash)	

		quote_by_submitter = FileModel.find_all_by_submitter("a person").first
		assert_quote_attributes(quote_by_submitter, hash)
	end


	private

	def assert_quote_attributes(quote, hash)
		hash.keys.each { |key|
			assert quote[key] == hash[key]
		}
	end

	def relative_path(filename)
		File.join(BASE_DIR, filename)
	end

end