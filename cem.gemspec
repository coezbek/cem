
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cem/version"

Gem::Specification.new do |spec|
  spec.name          = "cem"
  spec.version       = Cem::VERSION
  spec.authors       = ["Christopher Özbek"]
  spec.email         = ["christopher@oezbek.org"]

  spec.summary       = %q{Cem = Christopher's Common Helper Gem for Ruby.}
  spec.description   = %q{Christopher's Gem = My little helpers which I use in many projects.}
  spec.homepage      = "https://github.com/coezbek/cem"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/coezbek/cem"
    spec.metadata["changelog_uri"] = "https://github.com/coezbek/cem/README.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1" # Was   1.17
  spec.add_development_dependency "rake", "~> 13.0"   # Was: 10.0
  spec.add_development_dependency "rspec", "~> 3.0"
  
  # Flammarion is not a runtime dependency, but rather optional
  # spec.add_runtime_dependency 'flammarion', '~> 0.3'
  spec.add_runtime_dependency "progress_bar", "~> 1.3"
end
