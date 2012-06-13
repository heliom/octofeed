# Custom strategies extending Github
# This way we can use 2 apps with the same base strategy
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
