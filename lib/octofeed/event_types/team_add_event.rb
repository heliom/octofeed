module OctoFeed
  class TeamAddEvent < OctoFeed::Event

    def initialize(json)
      super json

      @object = {
        :team => json['payload']['team']['name'],
        :user => json['payload']['user']['login']
      }
    end

    def print
      link = %(<a href="https://github.com/#{@actor[:username]}">#{@object[:team]}</a>)
      super({
        :title => "#{gh_user_link @actor[:username]} added #{gh_link @object[:user]} to #{link}"
      })
    end

  end
end
