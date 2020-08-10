class Artifact < ActiveRecord::Base
  # include Tire::Model::Search
  # include Tire::Model::Callbacks

  validates_presence_of :accession_number
  validates_uniqueness_of :accession_number

  has_many :artifact_images
  belongs_to :key_image, class_name: "ArtifactImage"
  has_many :questions, -> { order('created_at desc') }

  scope :quality_entries, -> { where('comments is not null and description is not null and exists
    (select 1 from artifact_images where artifacts.id = artifact_id)').order(:accession_number) }

  # Elasticsearch Indexing Configuration
  # mapping do
  #   indexes :id, type: 'integer'
  #   indexes :accession_number, index: 'not_analyzed'
  #   indexes :std_term, boost: 10
  #   indexes :category_synonyms, boost: 5
  #   indexes :artist
  #   indexes :school_period
  #   indexes :materials
  #   indexes :measure
  #   indexes :weight
  #   indexes :comments
  #   indexes :description
  #   indexes :label_text
  #   indexes :bibliography
  #   indexes :published_refs
  #   indexes :exhibit_history
  #   indexes :marks
  #   indexes :public_loc

  #   indexes :origin, boost: 7
  #   indexes :geoloc_synonyms, boost: 5

  #   indexes :min_date, type: 'integer'
  #   indexes :max_date, type: 'integer'
  # end

  def to_param
    accession_number
  end

  def self.search(params)
    # tire.search(page:params[:page], per_page: 10, load: true) do
    #   query {string params[:keyword], default_operator: "AND"} if params[:keyword].present?
    #   filter :range, min_date: {lte: params[:high_date]} if params[:high_date].present?
    #   filter :range, max_date: {gte: params[:low_date]} if params[:low_date].present?
    #   filter :exists, field: :public_loc if params[:on_display].present?
    #   sort {by :accession_number} if params[:query].blank?
    # end
  end

  def to_indexed_json
    to_json(methods: [:category_synonyms, :geoloc_synonyms, :to_param])
  end

  def category_synonyms
    @synonyms ||= calc_category_synonyms
  end

  def calc_category_synonyms
    t = CategorySynonym.arel_table
    @synonyms = CategorySynonym.where(t[:category].eq(alt_name).or(t[:synonym].eq(alt_name))).
      map{|i| [i.category,i.synonym]}.flatten.uniq.join(', ')
  end

  def geoloc_synonyms
    return @geo_locs if @geolocs.present?

    t = GeolocSynonym.arel_table

    @geolocs = GeolocSynonym.where(t[:geoloc].eq(geoloc)).
      map{|i| [i.geoloc, i.synonym]}.
      flatten.
      uniq.join(', ')
  end

  def daily_summary
    return self.label_text || self.old_labels ||
      self.comments || self.description
  end

  def origin_with_date
    [self.origin, self.prob_date].compact.join(', ')
  end

  def self.of_the_day
    prng = Random.new(Date.today.to_time.to_i)
    self.quality_entries.offset(prng.rand(self.quality_entries.count)).first
  end

  def self.process_accession_number(ac_num)
    ac_num.gsub(' NC', '.NC').gsub('#','').gsub(/\s/, '').downcase
  end
end
