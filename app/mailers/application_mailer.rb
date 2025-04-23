class ApplicationMailer < ActionMailer::Base
  default from: 'evictions@mail.okdataexchange.org'
  layout 'mailer'
end
