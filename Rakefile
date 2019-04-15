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

desc 'Create PR for new IPs'
task :create_pull_request do
  diff = `git diff lib aws_ip_utilities/ip-ranges.json`
  if diff.length == 0
    warn 'No changes so no need to update the gem'
    exit
  end

  branch_name = "update-up-ranges-#{Date.today.iso8601}"
  branch = `git checkout -b #{branch_name}`

  add = `git add lib aws_ip_utilities/ip-ranges.json`
  commit_message = "Updating ip ranges from AWS on #{Date.today}"
  commit = `git commit -m '#{commit_message}'`

  # We push to the travis_github origin
  push = `git push travis_github #{branch_name}`

  client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'))

  # GitHub's REST API v3 considers every pull request an issue, but not every issue is a pull request.
  # Pull Requests endpoint doens't support filtering on label.
  open_ip_range_pr = client.issues("WeTransfer/aws_ip_utilities", {labels: 'automated-ip-updates'})

  if open_ip_range_pr.any?
    open_ip_range_pr.each do |issue|
      # Don't close pull requests if a user added a commit to the PR
      next if client.pull_request_commits("WeTransfer/aws_ip_utilities", issue.number).size > 1
      client.close_pull_request("WeTransfer/aws_ip_utilities", issue.number)
    end
  end

  pr = client.create_pull_request("WeTransfer/aws_ip_utilities", "master", branch_name, commit_message, commit_message)

  client.add_labels_to_an_issue("WeTransfer/aws_ip_utilities", pr.number, ['automated-ip-updates'])
end

desc 'Create PR for new IPs'
task :push_new_ips_to_master do
  diff = `git diff lib aws_ip_utilities/ip-ranges.json`
  if diff.length == 0
    warn 'No changes so no need to update the gem'
    exit
  end

  branch = `git checkout master`

  add = `git add lib aws_ip_utilities/ip-ranges.json`
  commit_message = "Updating ip ranges from AWS on #{Date.today}"
  commit = `git commit -m '#{commit_message}'`

  # We push to the travis_github origin
  push = `git push travis_github #{branch_name}`

  client = Octokit::Client.new(access_token: ENV.fetch('GITHUB_TOKEN'))
end


RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:rubocop)
task default: [:spec, :rubocop]
