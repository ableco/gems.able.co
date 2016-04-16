desc "Runs ablecop automatted code review on CircleCI"
namespace :ablecop do
  desc "Run code analysis for the current commit / pull request on CircleCI"
  task :run_on_circleci do
    abort("Github access token is missing") unless ENV["GITHUB_ACCESS_TOKEN"].present?

    Pronto::GemNames.new.to_a.each { |gem_name| require "pronto/#{gem_name}" }

    # If CircleCI includes the pull request information, run the code analysis on the
    # branch for the pull request.
    if ENV["CI_PULL_REQUEST"].present?
      ENV["PULL_REQUEST_ID"] = ENV["CI_PULL_REQUEST"].match("[0-9]+$").to_s
      abort("Pull Request ID is missing") unless ENV["PULL_REQUEST_ID"].present?

      formatter = Pronto::Formatter::GithubPullRequestFormatter.new
      messages = Pronto.run("origin/master", ".", formatter)

      if messages.any?
        post_status("error", "Pronto found #{messages.size} #{messages.size > 1 ? 'issues' : 'issue'}.")
      else
        post_status("success", "Your code meets our standards.")
      end
    # If CircleCI does not include the pull request information, run the
    # code analysis on the current commit.
    else
      formatter = Pronto::Formatter::GithubFormatter.new
      Pronto.run("origin/master", ".", formatter)
    end
  end
end

def post_status(state, message)
  repo = "ableco/core.able.co"
  sha = ENV["CIRCLE_SHA1"]

  options = {
    context: "pronto",
    target_url: ENV["CIRCLE_BUILD_URL"],
    description: message
  }

  Octokit.access_token = ENV["GITHUB_ACCESS_TOKEN"]
  Octokit.create_status(repo, sha, state, options)
end
