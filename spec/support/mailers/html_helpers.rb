module Mailers
  module HtmlHelpers
    def mail_body
      unless respond_to?(:mail)
        raise "Yo, I'm looking for an object called `mail`, but didn't find it"
      end
      @email_body ||= Capybara::Node::Simple.new(mail.body.encoded)
    end
  end
end
