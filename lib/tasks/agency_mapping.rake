namespace :import do
  desc 'Import Oklahoma List Statutes'
  task agency_mapping: :environment do
    file = File.read('lib/agencies_mapped.csv')
    data = CSV.parse(file, headers: true)

    # TODO: Change to pull from S3 file or directly from site with file
    bar = ProgressBar.new(data.count)

    data.each do |row|
      bar.increment!
      pp = ParentParty.find_or_create_by(name: row['mapped_name'])
      begin
        Party.find_by(oscn_id: row['oscn_id']).update(parent_party_id: pp.id)
      rescue StandardError
        next
      end
    end
  end
end
