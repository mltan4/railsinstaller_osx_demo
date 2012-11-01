scheduler = Rufus::Scheduler.start_new

scheduler.every("1m") do
  puts("testing 1")
  ItemsController.new.close_expired_bids
  puts("testing 2")
end