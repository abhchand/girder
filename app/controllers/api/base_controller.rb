class Api::BaseController < ApplicationController
  # See: https://stackoverflow.com/a/42804099/2490003
  skip_forgery_protection

  before_action :ensure_json_request

  private

  def user
    @user ||=
      begin
        # Order matters here. For nested resources there may be another
        # resource identified by `:id`
        #
        # e.g. /users/:user_id/foo/:id
        #
        # This method won't work in general if User is a nested child resource
        id = params[:user_id] || params[:id]

        User
          .find_by_synthetic_id(id)
          .tap do |user|
            if user.nil?
              raise(
                ActiveRecord::RecordNotFound,
                "Couldn't find User with 'id'=#{id}"
              )
            end
          end
      end
  end

  def has_next_page?(total)
    default = Api::Response::PaginationLinksService::PAGE_SIZE

    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || default).to_i

    page < (total.to_f / per_page).ceil
  end

  def paginate(collection)
    default = Api::Response::PaginationLinksService::PAGE_SIZE

    collection.paginate(
      page: params[:page],
      per_page: params[:per_page] || default
    )
  end

  def pagination_links(collection)
    service =
      Api::Response::PaginationLinksService.new(
        collection,
        request.url,
        request.query_parameters
      )

    { self: request.url, next: service.next_url, last: service.last_url }
  end
end
