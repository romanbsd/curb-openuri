require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "curb-openuri"
    s.summary = %Q{open-uri drop-in replacement that uses curb}
    s.email = 'romanbsd@yahoo.com'
    s.homepage = "http://github.com/romanbsd/curb-openuri"
    s.description = s.summary
    s.authors = ["Roman Shterenzon"]
    s.add_dependency('curb', '>=0.1.4')
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = 'curb-openuri'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.libs << 'lib' << 'spec'
  t.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |t|
  t.libs << 'lib' << 'spec'
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
end

task :default => :spec
