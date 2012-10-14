module ArtifactsHelper
  def temportal_facet_path(params, low, high)
    artifacts_path(params.update(low_date: low, high_date: high))
  end

  def temporal_facet_menu_item(params, low, high, text=nil)
    text = "#{low} &ndash; #{high}".html_safe unless text.present?
    link_to text, temportal_facet_path(params, low, high)
  end
end
