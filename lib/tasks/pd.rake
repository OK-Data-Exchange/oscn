namespace :pd do
  desc 'Scape and parse'
  task booking: [:environment] do
    Importers::Pd::Booking.perform(test_json)
  end

  task offense: [:environment] do
    Importers::Pd::Offense.perform(test_json)
  end

  task :import_recent, [:start, :finish] => [:environment] do |_t, args|
    puts "running PD import_recent"
    after_date = Time.now - 4.week
    Importers::Pd::Booking.from_aws_after(after_date)
    Importers::Pd::Offense.from_aws_after(after_date)
    # Importers::Pd::Booking.iterate_aws(args[:start].to_i)
    # Importers::Pd::Offense.iterate_aws(args[:start].to_i, args[:finish].to_i)
  end
end
