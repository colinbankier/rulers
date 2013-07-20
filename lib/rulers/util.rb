module Rulers
	self.to_underscore(string)
		string.gsub(/::/, '/').
		gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
		gsub(/([a-z\d])([A-Z])/, '\1\2').
		tr("-", "_").
		downcase
	end
end