RSpec.configure do |config|
  SimpleCov.minimum_coverage(80) unless config.files_to_run.one?
end
