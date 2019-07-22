Sidekiq.configure_server do |_config|
  schedule_file = 'config/schedule.yml'

  if File.exists?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file))
  end
end

Sidekiq.options[:poll_interval] = 1