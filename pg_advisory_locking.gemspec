
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pg_advisory_locking/version"

Gem::Specification.new do |spec|
  spec.name          = "pg_advisory_locking"
  spec.version       = PgAdvisoryLocking::VERSION
  spec.authors       = ["Roger Campos"]
  spec.email         = ["roger@rogercampos.com"]

  spec.summary       = %q{Simple Postgres advisory locking wrapper for ActiveRecord}
  spec.description   = %q{Simple Postgres advisory locking wrapper for ActiveRecord}
  spec.homepage      = "https://github.com/rogercampos/pg_advisory_locking"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 5.0"
  spec.add_dependency "pg"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
