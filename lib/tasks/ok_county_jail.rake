namespace :ok_county_jail do
  desc 'Import data from current jail'
  task import_pdf: [:environment] do
    link = 'https://www.okcountydc.net/_files/ugd/413d25_a5e2f3d02e394e909a16bc4cd3c84a5a.pdf'
    Importers::OkCountyJail::Pdf.perform(link)
  end
end
