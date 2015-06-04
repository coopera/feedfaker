require 'thread'
require 'rest-client'
require "erb"

class GHFaker
  def self.emails(user)
    Config['gh']['logins'].each do |login|
      return { emails: login['emails'], verified: true } if login['name'] == user
    end

    return []
  end

  def initialize(teamtracker_url, gh_url)
    @url = teamtracker_url + gh_url
  end

  def start
    Thread.abort_on_exception = true

    loop do
      puts make_issue
      #RestClient.post(@url, make_issue, :'X-Github-Event' => 'issue')
      sleep(5)
    end
  end

  private

  def random_issue_title
    'Found bug at ' + %w(model view controller).sample
  end

  def make_issue
    locals = { 
      action: %w(closed opened).sample, 
      title: random_issue_title,
      created_at: DateTime.now,
      body: "",
      number: (1..100).to_a.sample,
      user: {
        id: 1,
        login: "#{Config['gh']['logins'].map { |x| x['name'] }.sample}",
        avatar_url: 'http://placekitten.com/g/200/300'
      },
      repository: {
        id: 1,
        full_name: "#{Config['gh']['organization']}/#{Config['projects'].sample}"
      }
    }

    ERB.new(File.read('payloads/issue.json.erb'), nil, "%").result(binding)
  end

  def make_user
  end
end

=begin

CommitCommentEvent
CreateEvent
DeleteEvent
DeploymentEvent
DeploymentStatusEvent
DownloadEvent
FollowEvent
ForkEvent
ForkApplyEvent
GistEvent
GollumEvent
IssueCommentEvent
IssuesEvent
MemberEvent
MembershipEvent
PageBuildEvent
PublicEvent
PullRequestEvent
PullRequestReviewCommentEvent
PushEvent
ReleaseEvent
RepositoryEvent
StatusEvent
TeamAddEvent
WatchEvent

=end
