module OctoFeed
  class MemberEvent < OctoFeed::Event

    def initialize(json)
      super json

      @object = {
        :action => json['payload']['action'],
        :id => json['payload']['member']['id'],
        :username => json['payload']['member']['login'],
        :avatar => json['payload']['member']['avatar_url']
      }
    end

    def print
      super({
        :title => "#{gh_user_link @actor[:username]} #{@object[:action]} #{gh_link @object[:username]} to #{gh_link @repo[:name]}"
      })
    end

  end
end
