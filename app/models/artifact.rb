class Artifact < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  after_commit :index_document, if: :persisted?
  after_commit :delete_document, on: [:destroy]

  index_name "#{Rails.application.class.module_parent_name.underscore}_#{Rails.env}"
  document_type self.name.downcase

  validates_presence_of :accession_number
  validates_uniqueness_of :accession_number

  has_many :artifact_images
  belongs_to :key_image, class_name: "ArtifactImage"
  has_many :questions, -> { order('created_at desc') }

  scope :quality_entries, -> { where('comments is not null and description is not null and exists
    (select 1 from artifact_images where artifacts.id = artifact_id)').order(:accession_number) }

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :id
      indexes :accession_number, analyzer: 'whitespace'
      indexes :std_term, analyzer: 'english'
      indexes :alt_name, analyzer: 'english'
      indexes :category_synonyms, analyzer: 'english'
      indexes :artist, analyzer: 'standard'
      indexes :school_period, analyzer: 'standard'
      indexes :materials, analyzer: 'english'
      indexes :measure, analyzer: 'standard'
      indexes :weight, analyzer: 'standard'
      indexes :comments, analyzer: 'english'
      indexes :description, analyzer: 'english'
      indexes :label_text, analyzer: 'english'
      indexes :bibliography, analyzer: 'standard'
      indexes :published_refs, analyzer: 'standard'
      indexes :exhibit_history, analyzer: 'english'
      indexes :marks, analyzer: 'english'
      indexes :public_loc, analyzer: 'standard'

      indexes :origin, analyzer: 'standard'
      indexes :geoloc_synonyms

      # indexes :prob_date, type: 'text', analyzer: 'standard'
      indexes :min_date
      indexes :max_date

      indexes :key_image_id
    end
  end

  def to_param
    accession_number
  end

  def self.search(query, min_date, max_date)
    Rails.logger.info '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5'
    Rails.logger.info min_date
    Rails.logger.info max_date

    __elasticsearch__.search(
    {
      query: {
        bool: {
          must: {
            multi_match: {
              query: query,
              type: 'most_fields',
              fields: ['accession_number', 'std_term^20', 'alt_name^5', 'category_synonyms^5', 'artist', 'school_period', 'materials', 'measure',
                'weight', 'comments', 'description', 'label_text', 'bibliography', 'published_refs', 'exhibit_history', 'marks', 'public_loc',
                'origin^7', 'geoloc_synonyms^5']
            }
          },
          filter: {
            bool: {
              must: [
                {range: {min_date: { gte: min_date }}},
                {range: {max_date: { lte: max_date }}}
              ]
            }
              # {range: {min_date: { gte: min_date }}},
              #   max_date: { lte: max_date }
              # }
          }
            # range: { min_date: { gte: min_date }},
            # range: { max_date: { lte: max_date }}
        }
       },
      
       # more blocks will go IN HERE. Keep reading!
    })
  end

  def as_indexed_json(options=nil)
    self.as_json(except: [:prob_date], methods: [:category_synonyms, :geoloc_synonyms, :to_param, :origin_with_date])
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

  def index_document
    __elasticsearch__.index_document
  end

  def delete_document
    __elasticsearch__.delete_document
  end

  def self.of_the_day
    prng = Random.new(Date.today.to_time.to_i)
    self.quality_entries.offset(prng.rand(self.quality_entries.count)).first
  end

  def self.process_accession_number(ac_num)
    ac_num.gsub(' NC', '.NC').gsub('#','').gsub(/\s/, '').downcase
  end
end
