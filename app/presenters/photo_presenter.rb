class PhotoPresenter < ApplicationPresenter
  def photo_grid_props
    { id: synthetic_id, takenAt: taken_at.strftime('%Y:%m:%d %H:%M:%S') }
  end
end
