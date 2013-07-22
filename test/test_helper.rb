require "rack/test"
require "test/unit"

# Load Rulers first
this_dir = File.join(File.dirname(__FILE__), "../lib")
$LOAD_PATH.unshift File.expand_path(this_dir)

require "rulers"