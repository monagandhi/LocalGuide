# Rewrite asset path in production

if Rails.env.production?
  tag_helper = ActionView::Helpers::AssetTagHelper::AssetPaths
  tag_helper.send(:include, AssetPathPrefixer)
  tag_helper.send(:alias_method_chain, :rewrite_asset_path, :serviceizer)

  tag_helper = Sprockets::Helpers::RailsHelper::AssetPaths
  tag_helper.send(:include, AssetPathPrefixer)
  tag_helper.send(:alias_method_chain, :rewrite_asset_path, :serviceizer)
end
