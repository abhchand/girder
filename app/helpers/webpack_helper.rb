module WebpackHelper
  def javascript_pack_tag(name, options = {})
    pack = manifest["#{name}.js"]
    return unless pack

    javascript_include_tag(pack, options)
  end

  def stylesheet_pack_tag(name, options = {})
    pack = manifest["#{name}.css"]
    return unless pack

    stylesheet_link_tag(pack, options)
  end

  # NOTE: overrides ActionView's `image_path` helper
  # https://apidock.com/rails/ActionView/Helpers/AssetTagHelper/image_path
  def image_path(name)
    WEBPACK_IMAGE_URL_PREFIX.join(name).to_s
  end

  def manifest
    @manifest ||= JSON.parse(WEBPACK_MANIFEST_FILE.read)
  end
end
