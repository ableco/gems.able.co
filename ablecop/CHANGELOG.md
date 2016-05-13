# AbleCop Changelog

## 0.3.0

- Set up [rails_best_practices](https://github.com/railsbp/rails_best_practices) and its [Pronto runner](https://github.com/mmozuras/pronto-rails_best_practices).
- Refactored Rails generator to easily be able to copy files to different destinations on a project.

## 0.2.0

- Refactored Rails generator so that we only add filenames to the project's `.gitignore` file only once (instead of once per file that needs to be added).
- Added the [octokit](https://github.com/octokit/octokit.rb) gem as a dependency.
- Added a post-install message with information on how to set up AbleCop locally and on CircleCI.
- Minor gemspec cleanup:
  - Do not include any executable scripts in the gem.
  - Added summary and description.
- Upgraded Rubocop (0.40.0) and Brakeman (3.3.0) gems to their latest versions and updated the default configuration files where necessary.

## 0.1.0 (Initial release)

- Set up [Rubocop](https://github.com/bbatsov/rubocop), [fasterer](https://github.com/DamirSvrtan/fasterer), [Brakeman](https://github.com/presidentbeef/brakeman) and [scss-lint](https://github.com/brigade/scss-lint) libraries.
- Set up [Pronto](https://github.com/mmozuras/pronto) and runners for [Rubocop](https://github.com/mmozuras/pronto-rubocop), [fasterer](https://github.com/mmozuras/pronto-fasterer), [Brakeman](https://github.com/mmozuras/pronto-brakeman), [Pronto::RailsSchema](https://github.com/raimondasv/pronto-rails_schema) and [scss-lint](https://github.com/mmozuras/pronto-scss).
- Added a Rails generator to copy default configuration files and include the files in the project's `.gitignore` file.
- Allow a project using the gem to override the default configuration files.
