require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new

scheduler.cron("15 * * * * *") do
  Enrichedtitle.scan
end 
