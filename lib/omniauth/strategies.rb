module OmniAuth
  module Strategies

    class GitHubPublic < GitHub
      def name
        :github_public
      end
    end

    class GitHubPrivate < GitHub
      def name
        :github_private
      end
    end

  end
end
