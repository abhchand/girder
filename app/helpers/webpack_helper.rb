module WebpackHelper
  def javascript_pack_tag(name, options = {})
    pack = manifest[name.to_s + '.js']
    return unless pack

    javascript_include_tag(pack, options)
  end

  def stylesheet_pack_tag(name, options = {})
    pack = manifest[name.to_s + '.css']
    return unless pack

    stylesheet_link_tag(pack, options)
  end

  def image_tag(name, options = {})
    tag('img', options.merge(src: image_path(name)))
  end

  # Note: overrides ActionView's `image_path` helper
  # https://apidock.com/rails/ActionView/Helpers/AssetTagHelper/image_path
  def image_path(name)
    WEBPACK_IMAGE_URL_PREFIX.join(name).to_s
  end

  def manifest
    @manifest ||= JSON.parse(WEBPACK_MANIFEST_FILE.read)
  end
end
