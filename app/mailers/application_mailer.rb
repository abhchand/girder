class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  helper_method :namespace_url

  class MissingSubject < StandardError
  end

  private

  def send_mail(opts = {})
    raise MissingSubject if @subject.blank?

    mail(
      {
        to: @recipient,
        from: @from || ENV['EMAIL_FROM'],
        reply_to: @from || ENV['EMAIL_FROM'],
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
