module ArtifactsHelper
  def format_artifact_name(artifact)
    textilize(artifact.std_term).gsub(/<\/?p>/,'').html_safe
  end

  def temporal_facet_menu_item(params, low, high, text=nil, default_menu_item=false)
    text = "#{low} &ndash; #{high}".html_safe unless text.present?
    if params[:high_date].present? && params[:high_date].to_i == high
      return "#{text}<i class=\"icon-ok\"></i>".html_safe
    else
      return %Q(<a class="date-filter-link" data-high="#{high}" data-low="#{low}">#{text}</a>).html_safe
    end
  end

  def display_fields
    [
      {field: 'accession_number', label: 'Accession Number'},
      {field: 'origin_with_date', label: 'Origin'},
      {field: 'artist', label: 'Artist'},
      {field: 'school_period', label: 'School/Period'},
      {field: 'materials', label: 'Materials'},
      {field: 'measure', label: 'Measure'},
      {field: 'weight', label: 'Weight'}
    ]
  end

  def gallery_width_class(image_count)
    image_count > 10 ? 'span1' : 'span2'
  end

  def return_link
    link_text, return_path = if request.referrer == root_url
      ['Return to Homepage', root_path]
    else
      ['Return to Search', artifacts_path(session[:search_params])]
    end

    link_to link_text, return_path, class: 'btn btn-inverse', style: 'margin-top: 10px;'
  end
end
