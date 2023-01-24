require 'rails_helper'

RSpec.describe ApplicationMailer do
  describe '#send_mail' do
    let(:user) { create(:user) }
    let(:mailer) { ApplicationMailer.send(:new) }

    it 'delivers the email' do
      mailer.instance_variable_set(:@recipient, user.email)
      mailer.instance_variable_set(:@subject, 'test')

      expect(mailer).to receive(:mail)
      mailer.send(:send_mail)
    end

    describe 'no subject is set' do
      it 'raises an error' do
        mailer.instance_variable_set(:@recipient, user.email)
        mailer.instance_variable_set(:@subject, '')

        expect { mailer.send(:send_mail) }.to raise_error(
          ApplicationMailer::MissingSubject
        )
      end
    end
  end
end
