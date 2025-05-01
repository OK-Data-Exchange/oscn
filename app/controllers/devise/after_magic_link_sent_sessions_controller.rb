class Devise::AfterMagicLinkSentSessionsController < Devise::Passwordless::SessionsController
  def after_magic_link_sent_path_for(*args)
    user = args[0]
    "/passwordless_sent?user[email]=#{user.email}"
  end
end