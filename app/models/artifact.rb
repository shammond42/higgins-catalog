class Artifact < ActiveRecord::Base
  attr_accessible :accession_number, :std_term, :alt_name, :prob_date, :min_date, :max_date,
    :artist, :school_period, :geoloc, :origin, :materials, :measure, :weight, :comments,
    :bibliography, :published_refs, :label_text, :old_labels, :exhibit_history, :description,
    :marks, :public_loc, :status

  validates_uniqueness_of :accession_number

  def to_param
    accession_number.gsub('.','-').gsub(' & ',':')
  end

  def self.from_param(param)
    param.gsub('-','.').gsub(':',' & ')
  end

  def category_synonyms
    return @synonyms if @synonyms.present?

    t = CategorySynonym.arel_table

    @synonyms = CategorySynonym.where(t[:category].eq(alt_name).or(t[:synonym].eq(alt_name))).
      map{|i| [i.category,i.synonym]}.
      flatten.
      uniq
  end
end
