require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rubocop/rake_task'

desc 'Update the version.rb file with the sync token and the minor version based on modification date'
task :update_version_tokens, [:sync_token] do |_task, args|
  version_specifier = args.sync_token
  version_file_contents = File.read(__dir__ + '/lib/aws_ip_utilities/version.rb')
  version_file_contents.gsub!(/(\d+\.\d+\.)(\d+)/, '\1%s' % version_specifier)
  version_file_contents.gsub!(/SYNC_TOKEN.+$/, 'SYNC_TOKEN = "%s"' % version_specifier)
  File.open(__dir__ + '/lib/aws_ip_utilities/version.rb', 'wb') do |f|
    f << version_file_contents
  end
end

desc 'Download the IP ranges from AWS and update the version of the gem'
task :download_and_bump_version do
  warn "Checking if ip-ranges.json needs an update"
  require 'open-uri'
  require 'json'
  uri = 'https://ip-ranges.amazonaws.com/ip-ranges.json'
  open(uri) do |f|
    raise "Unexpected status #{f.status.inspect}" unless f.status.first == "200"
    parsed = JSON.parse(f.read)
    cached = JSON.parse(File.read(__dir__ + '/lib/aws_ip_utilities/ip-ranges.json'))

    if parsed.fetch('syncToken') == cached.fetch('syncToken')
      warn "ip-ranges.json is up to date, no need to bump version"
      break
    end

    sync_token = parsed.fetch('syncToken')
    File.open(__dir__ + '/lib/aws_ip_utilities/ip-ranges.json', 'wb') do |fo|
      fo << JSON.pretty_generate(parsed)
    end
    Rake::Task["update_version_tokens"].invoke(sync_token)
  end
end
task release_with_ip_data: [:download_and_bump_version, :release]

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)
task default: [:spec, :rubocop]
