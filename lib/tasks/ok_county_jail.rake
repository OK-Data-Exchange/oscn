namespace :ok_county_jail do
  desc 'Import data from current jail'
  task import_pdf: [:environment] do
    Importers::OkCountyJail::Pdf.perform
  end
end
