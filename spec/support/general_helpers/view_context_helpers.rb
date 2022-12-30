module GeneralHelpers
  # Build a `view_context`. Attempts to replicate the method of the same name
  # available inside a controller, building a context the same way a controller
  # would
  def view_context
    @view_context ||=
      begin
        # Build a lookup context based off the configured view paths
        # See: https://github.com/rails/rails/blob/v6.1.7/actionview/lib/action_view/lookup_context.rb#L235
        lookup_context =
          ActionView::LookupContext.new(ActionController::Base.view_paths)

        # Build a view context with no assigns, and a "nil" controller
        # See: https://github.com/rails/rails/blob/v6.1.7/actionview/lib/action_view/base.rb#L230
        ActionView::Base.new(lookup_context, {}, nil)
      end
  end
end
