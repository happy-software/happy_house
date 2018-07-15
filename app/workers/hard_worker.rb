class HardWorker
  include Sidekiq::Worker

  def perform(name, count)
    count.times { |c| p "#{c}:#{name} says hello world!" }
  end
end
