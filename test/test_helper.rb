require "rack/test"
require "test/unit"

# Load Rulers first
this_dir = File.join(File.dirname(__FILE__), "../lib")
$LOAD_PATH.unshift File.expand_path(this_dir)

require "rulers"

BASE_DIR = File.join(Dir.pwd, "test/test_app")
Rulers::Model::FileModel.base_dir = BASE_DIR