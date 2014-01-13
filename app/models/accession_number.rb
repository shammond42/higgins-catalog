# Value Object representing the accession number of an artifact
class AccessionNumber
  def initialize(accession_number_string)
    @accession_number = accession_number_string
    self.freeze
  end

  def to_s
    @accession_number
  end

  def ==(other_accession_number)
    self.to_s == other_accession_number.to_s
  end
end