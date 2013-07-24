require "multi_json"

module Rulers
	module Model
		class FileModel
			@@base_dir = Dir.pwd

			def self.base_dir=(dir)
				@@base_dir = dir
			end

			def self.base_dir()
				@@base_dir
			end

			def self.actual_path(filename)
				File.join(@@base_dir, filename)
			end

			def initialize(filename)
				@filename = filename

				basename = File.split(filename)[-1]
				@id = File.basename(basename, ".json").to_i

				obj = File.read(FileModel.actual_path(filename))
				@hash = MultiJson.load(obj)
			end

			def [](name)
				@hash[name.to_s]
			end

			def self.find(id)
				begin
					FileModel.new("db/quotes/#{id}.json")
				rescue
					return nil
				end
			end

			def self.all
				files = Dir["db/quotes/*.json"]
				files.map { |f| FileModel.new f }
			end

			def self.create(attrs)
				hash = {}
				hash["submitter"] = attrs["submitter"] || ""
				hash["quote"] = attrs["quote"] || ""
				hash["attribution"] = attrs["attribution"] || ""

				files = Dir["db/quotes/*.json"]
				names = files.map { |f| f.split("/")[-1] }
				highest = names.map { |b| b[0...-5].to_i }.max
				highest = 0 if not highest
				id = highest + 1

				File.open(FileModel.actual_path("db/quotes/#{id}.json"), "w") do |f|
					f.write <<TEMPLATE
{
	"submitter": "#{hash["submitter"]}",
	"quote": "#{hash["quote"]}",
	"attribution": "#{hash["attribution"]}"
}
TEMPLATE
				end

				FileModel.new "db/quotes/#{id}.json"
			end

		end
	end
end