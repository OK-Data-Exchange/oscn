require 'rufus-scheduler'

scheduler = Rufus::Scheduler::singleton

# todo: move these to scenic (currently only in schema.rb)
def refresh_roster_views
  views_to_refresh = %w[
    roster_cases_materialized
    court_case_party_counts
    roster_parties_materialized
    roster_people_materialized2
    roster_people_with_id
    roster_people_merged
    roster_people_merged_dlms
    roster_people_merged_doc_numbers
    roster_people_merged_parties
    roster_people_details
    roster_people_details_merged
  ]
  views_to_refresh.each do |view|
    ActiveRecord::Base.connection.execute("refresh materialized view #{view}")
  end
  print('views refreshed')
end

# refresh_roster_views # refresh views on boot in case server was sleeping

scheduler.every '1d' do
  refresh_roster_views
end

