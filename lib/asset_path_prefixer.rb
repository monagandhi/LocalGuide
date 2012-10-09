module AssetPathPrefixer

  private

  def rewrite_asset_path_with_serviceizer(source, asset_path, options = {})
    rewrite_asset_path_without_serviceizer("/assets/#{source}", asset_path, options)
  end

end