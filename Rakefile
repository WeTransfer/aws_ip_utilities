require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

desc 'Update the version.rb file with the sync token and the minor version based on modification date'
task :update_version_tokens, [:sync_token, :modification_date] do |_task, args|
  version_specifier = args.modification_date.strftime("%Y%m%d")
  version_file_contents = File.read(__dir__  + '/lib/aws_ip_utilities/version.rb')
  version_file_contents.gsub!(/(\d+\.\d+\.)(\d+)/, '\1%s' % version_specifier)
  version_file_contents.gsub!(/SYNC_TOKEN.+$/, 'SYNC_TOKEN = "%s"' % args.sync_token)
  File.open(__dir__  + '/lib/aws_ip_utilities/version.rb', 'wb') do |f|
    f << version_file_contents
  end
end

desc 'Download the IP ranges from AWS and update the version of the gem'
task :download_and_bump_version do
  $stderr.puts "Checking if ip-ranges.json needs an update"
  require 'open-uri'
  require 'json'
  uri = 'https://ip-ranges.amazonaws.com/ip-ranges.json'
  open(uri) do |f|
    raise "Unexpected status #{f.status.inspect}" unless f.status.first == "200"
    parsed = JSON.parse(f.read)
    cached = JSON.parse(File.read(__dir__  + '/lib/aws_ip_utilities/ip-ranges.json')) rescue nil

    #break if parsed.fetch('syncToken') == cached.fetch('syncToken')

    sync_token = parsed.fetch('syncToken')
    last_modified = Time.parse(parsed.fetch('createDate'))
    File.open(__dir__  + '/lib/aws_ip_utilities/ip-ranges.json', 'wb') do |fo|
      fo << JSON.pretty_generate(parsed)
    end
    Rake::Task["update_version_tokens"].invoke(sync_token, last_modified)
  end
end

task :default => :spec
task :release_with_ip_data => [:download_and_bump_version, :release]
