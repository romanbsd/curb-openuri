# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{curb-openuri}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Roman Shterenzon"]
  s.date = %q{2009-02-18}
  s.description = %q{open-uri drop-in replacement that uses curb}
  s.email = %q{romanbsd@yahoo.com}
  s.files = ["VERSION.yml", "lib/curb_openuri.rb", "lib/curl_agent.rb", "spec/curb_openuri_spec.rb", "spec/spec_helper.rb", "spec/curl_agent_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/romanbsd/curb-openuri}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{open-uri drop-in replacement that uses curb}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<curb>, [">= 0.1.4"])
    else
      s.add_dependency(%q<curb>, [">= 0.1.4"])
    end
  else
    s.add_dependency(%q<curb>, [">= 0.1.4"])
  end
end
