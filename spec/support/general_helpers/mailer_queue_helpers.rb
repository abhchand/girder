module GeneralHelpers
  # When a mailer is enqueued with `#deliver_later`, it generates an
  # ActionMailer job (which implements the ActiveJob interface).
  #
  # To be able to enqueue this job onto Sidekiq, it has to be further wrapper
  # in a Sidekiq Job Wrapper that will enqueue it with keys that sidekiq
  # expects, like `jid`, `retry`, etc...
  #
  # For example, here's the result of calling
  #
  #   > Devise::Mailer.confirmation_instructions(
  #       User.find(108),
  #       'pU8s2syM1pYN523Ap2ix',
  #       {}
  #     ).deliver_later
  #
  #   > Sidekiq::Worker.jobs
  #   => [
  #     {
  #       "class"=>"ActiveJob::QueueAdapters::SidekiqAdapter::JobWrapper",
  #       "wrapped"=>"ActionMailer::MailDeliveryJob",
  #       "queue"=>"mailers",
  #       "args"=>
  #         [{
  #           "job_class"=>"ActionMailer::MailDeliveryJob",
  #           "job_id"=>"17464385-ed14-4490-ab10-a0770870c169",
  #           "provider_job_id"=>nil,
  #           "queue_name"=>"mailers",
  #           "priority"=>nil,
  #           "arguments"=>[
  #             "Devise::Mailer",
  #             "confirmation_instructions",
  #             "deliver_now",
  #             {
  #               "args"=>[
  #                 {"_aj_globalid"=>"gid://familyties/User/108"},
  #                 "pU8s2syM1pYN523Ap2ix",
  #                 {"_aj_symbol_keys"=>[]}
  #               ],
  #               "_aj_ruby2_keywords"=>["args"]
  #             }
  #           ],
  #           "executions"=>0,
  #           "exception_executions"=>{},
  #           "locale"=>"en",
  #           "timezone"=>"UTC",
  #           "enqueued_at"=>"2023-05-31T15:31:34Z"
  #         }],
  #       "retry"=>true,
  #       "jid"=>"0c6ebfceee4cddc9ccd557b4",
  #       "created_at"=>1685547094.2727168,
  #       "enqueued_at"=>1685547094.2728298
  #     }
  #   ]
  #
  # This nested structure can be inconvenient for testing, so the below
  # method deserializes this information and produces a simple hash that
  # can be used for testing
  #
  #   expect do
  #     post :create, params: params
  #   end.to change { enqueued_mailers.count }.by(1)
  #
  #   email = enqueued_mailers.last
  #   expect(email[:klass]).to eq(Devise::Mailer)
  #   expect(email[:mailer_name]).to eq(:confirmation_instructions)
  #   expect(email[:args][:record]).to eq(User.last)
  def enqueued_mailers
    Sidekiq::Worker
      .jobs
      .map do |job|
        # `Sidekiq:Worker.jobs` returns all jobs. We only want to filter on those
        # in our action_mailer queue
        queue_name =
          Rails.application.config.action_mailer.deliver_later_queue_name
        next unless job['queue'] == queue_name.to_s

        mailer_klass, mailer_name, _method_name, args =
          ActiveJob::Arguments.deserialize(job['args'][0]['arguments'])

        mailer_klass = mailer_klass.constantize
        params =
          mailer_klass.instance_method(mailer_name).parameters.map { |p| p[1] }

        args = args[:args]

        enqueued_at = Time.zone.at(job['enqueued_at']) if job['enqueued_at']
        at = Time.zone.at(job['at']) if job['at']

        {
          klass: mailer_klass,
          mailer_name: mailer_name.to_sym,
          args: Hash[params.zip(args)],
          enqueued_at: enqueued_at,
          at: at
        }
      end
      .compact
  end

  def mailer_queue
    if Sidekiq::Extensions::DelayedMailer.jobs.any?
      ActiveSupport::Deprecation.warn(<<~EOM)
        Stop using `.delay` and switch to `.deliver_later`
      EOM
    end

    Sidekiq::Extensions::DelayedMailer.jobs.map do |job|
      # rubocop:disable Security/YAMLLoad
      klass, method_name, args = YAML.unsafe_load(job['args'].first)
      # rubocop:enable Security/YAMLLoad
      method_name = args.shift if method_name == :send

      params = klass.instance_method(method_name).parameters.map { |p| p[1] }

      at = nil
      at = Time.zone.at(job['at']) if job['at']

      {
        klass: klass,
        method: method_name,
        args: Hash[params.zip(args)],
        at: at
      }
    end
  end

  def mailer_names
    mailer_queue.map { |mq| mq[:method] }
  end

  def clear_mailer_queue
    Sidekiq::Extensions::DelayedMailer.clear
  end
end
