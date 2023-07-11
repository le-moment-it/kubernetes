# Docs: https://terraspace.cloud/docs/config/reference/
Terraspace.configure do |config|
    config.logger.level = :info
    config.build.cache_dir = ":ENV/:BUILD_DIR"
    config.allow.envs = [ "dev" ]
    config.test_framework = "rspec"
    config.all.concurrency = 5
    config.all.exit_on_fail.plan = false
    config.all.exit_on_fail.up = true
  end