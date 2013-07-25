require "multi_json"

module Rulers
	module Model
		class FileModel
			attr_reader :id
			@@base_dir = Dir.pwd

			def self.base_dir=(dir)
				@@base_dir = dir
			end

			def self.base_dir()
				@@base_dir
			end

			def initialize(filename)
				@filename = filename

				basename = File.split(filename)[-1]
				@id = File.basename(basename, ".json").to_i
				filepath = filename.start_with?("/") ? filename : self.class.relative_path(filename)
				obj = File.read(filepath)
				@hash = MultiJson.load(obj)
			end

			def self.relative_path(filename)
				File.join(@@base_dir, filename)
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
				files = Dir[relative_path("db/quotes/*.json")]
				files.map { |f| FileModel.new f }
			end

			def self.create(attrs)
				hash = {}
				hash["submitter"] = attrs["submitter"] || ""
				hash["quote"] = attrs["quote"] || ""
				hash["attribution"] = attrs["attribution"] || ""
				files = Dir[relative_path("db/quotes/*.json")]
				names = files.map { |f| f.split("/")[-1] }
				highest = names.map { |b| b[0...-5].to_i }.max
				highest = 0 if not highest
				id = highest + 1

				write_to_file(id, hash)
				FileModel.new "db/quotes/#{id}.json"
			end

			def update(attrs)
				@hash["submitter"] = attrs["submitter"] if attrs["submitter"] 
				@hash["quote"] = attrs["quote"] if attrs["quote"]
				@hash["attribution"] = attrs["attribution"] if attrs["attribution"]
			end

			def save!
				self.class.write_to_file(@id, @hash)
			end

			def self.write_to_file(id, hash)
				File.open(relative_path("db/quotes/#{id}.json"), "w") do |f|
					f.write <<TEMPLATE
{
	"submitter": "#{hash["submitter"]}",
	"quote": "#{hash["quote"]}",
	"attribution": "#{hash["attribution"]}"
}
TEMPLATE
				end
			end

			def self.method_missing(name, *args, &block)
				puts "Method missing #{name}"
				if name =~ /^find_all_by_(.*)/
					find_all_by($1, *args)
				else
					super(name, *args, &block)
				end
			end

			def self.find_all_by(field, value)
				puts "Finding all #{field} #{value}"
				puts all.to_s
				all.select { |quote| 
					puts "#{field}, #{value}, #{quote[field]}, #{quote[field] == value}"
					quote[field] == value 
				}
			end

			def respond_to_missing?(name, include_private = false)
				name.start_with?('find_all_by_') || super
			end
		end
	end
end