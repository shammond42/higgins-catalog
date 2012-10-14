module ArtifactsHelper
  def temportal_facet_path(params, low, high)
    artifacts_path(params.update(low_date: low, high_date: high))
  end

  def temporal_facet_menu_item(params, low, high, text=nil)
    text = "#{low} &ndash; #{high}".html_safe unless text.present?
    link_to text, temportal_facet_path(params, low, high)
  end

  def display_fields
    [
      {field: 'accession_number', label: 'Accession Number'},
      {field: 'origin', label: 'Origin'},
      {field: 'prob_date', label: 'Probable Date'},
      {field: 'artist', label: 'Artist'},
      {field: 'school_period', label: 'School/Period'},
      {field: 'materials', label: 'Materials'},
      {field: 'measure', label: 'Measure'},
      {field: 'weight', label: 'Weight'}
    ]
  end
end
