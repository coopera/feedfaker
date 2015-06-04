require 'thread'
require 'rest-client'

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
    t = Thread.new do
      loop do
        RestClient.post(@url, { status: 'opened' }, :'X-Github-Event' => 'issue')
        sleep(5)
      end
    end
  end
end