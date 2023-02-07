class UserPresenter < ApplicationPresenter
  include WebpackHelper

  # Returns a Hash representation of the `avatar` attachment, containing various
  # URLs for accessing ActiveStorage representations.
  #
  # For an image, this returns:
  #
  #     avatar: {
  #       type: 'image',
  #       url: {
  #         original: '...',
  #         thumb: '...',
  #         ...
  #       }
  #     }
  #
  def avatar
    urls = {
      original: url_for(user.avatar.attached? ? user.avatar : blank_avatar_path)
    }

    each_variant do |variant, transformations|
      v =
        if user.avatar.attached?
          user.avatar.variant(transformations)
        else
          blank_avatar_path(size: variant)
        end

      urls[variant] = url_for(v)
    end

    { type: 'image', url: urls }
  end

  def roles
    model.roles.map(&:name).sort
  end

  private

  def blank_avatar_path(size: nil)
    return image_path('blank-avatar.jpg') if size.nil?

    image_path("blank-avatar-#{size}.jpg")
  end

  def each_variant(&block)
    User::AVATAR_SIZES.each do |variant, transformations|
      yield(variant, transformations)
    end
  end

  def url_for(arg)
    Rails.application.routes.url_helpers.url_for(arg)
  end

  def user
    @model
  end
end
