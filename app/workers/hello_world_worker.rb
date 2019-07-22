class HelloWorldWorker
  include Sidekiq::Worker

  def perform
    puts "Hello World! It is currently: #{Time.now}"
  end
end
