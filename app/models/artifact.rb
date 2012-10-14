class Artifact < ActiveRecord::Base
  include Tire::Model::Search
  include Tire::Model::Callbacks

  attr_accessible :accession_number, :std_term, :alt_name, :prob_date, :min_date, :max_date,
    :artist, :school_period, :geoloc, :origin, :materials, :measure, :weight, :comments,
    :bibliography, :published_refs, :label_text, :old_labels, :exhibit_history, :description,
    :marks, :public_loc, :status

  validates_uniqueness_of :accession_number

  has_many :artifact_images

  mapping do
    indexes :id, type: 'integer'
    indexes :accession_number, index: 'not_analyzed'
    indexes :std_term, boost: 10
    indexes :category_synonyms, boost: 5
    indexes :artist
    indexes :school_period
    indexes :materials
    indexes :measure
    indexes :weight
    indexes :comments
    indexes :description
    indexes :label_text
    indexes :bibliography
    indexes :published_refs
    indexes :exhibit_history
    indexes :marks
    indexes :public_loc
  end

  def to_param
    accession_number.gsub('.','-').gsub(' & ',':')
  end

  def self.from_param(param)
    param.gsub('-','.').gsub(':',' & ')
  end

  def self.search(params)
    tire.search(page:params[:page], per_page: 20) do
      query {string params[:query], default_operator: "AND"} if params[:query].present?
      sort {by :accession_number} if params[:query].blank?
    end
  end

  def to_indexed_json
    to_json(methods: [:category_synonyms, :to_param])
  end

  def category_synonyms
    return @synonyms if @synonyms.present?

    t = CategorySynonym.arel_table

    @synonyms = CategorySynonym.where(t[:category].eq(alt_name).or(t[:synonym].eq(alt_name))).
      map{|i| [i.category,i.synonym]}.
      flatten.
      uniq
  end


  def self.de_space_ac_num(ac_num)
    ac_num.gsub(/^[Nn]o#./,'n').sub(/(\d+)/){"%04d"%$1.to_i}.gsub(' & ', '&').gsub(' NC','.NC').downcase
  end
end
