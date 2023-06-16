class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  helper_method :namespace_url

  class MissingSubject < StandardError
  end

  private

  def send_mail(opts = {})
    raise MissingSubject if @subject.blank?

    # NOTE: Devise mailers inherit from their own mailer class
    # (`Devise::Mailer`). It defines its own `mail()` metho with its own
    # header options, controlled by devise (the `mail()` method is used in
    # `Devise::Mailers::Helpers`, which is included from the base class).
    #
    # While Devise has its own configuration for defining `from` and `reply_to`,
    # it will respect any action mailer defaults with higher priority.
    #
    # We take advantage of that and use `EMAIL_FROM` and `EMAIL_REPLY_TO` to
    # consistent set these fields both here and as default action mailer
    # configs, so that this is consistent for devise and non-devise mailers.

    mail(
      {
        to: @recipient,
        from: @from || ENV['EMAIL_FROM'],
        reply_to: @from || ENV['EMAIL_REPLY_TO'],
        subject: @subject,
        content_type: 'text/html',
        template_path: [
          # See config/initializers/devise_mailers.rb which defines similar
          # configuration for Devise mailers
          'mailers/shared',
          "mailers/#{mailer_class_name}"
        ]
      }.merge(opts)
    )
  end

  def mailer_class_name
    self.class.to_s.underscore
  end
end
