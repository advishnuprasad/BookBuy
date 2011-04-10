require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.cron("5 * * * * *") do
  Enrichedtitle.scan
end 
