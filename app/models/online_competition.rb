class OnlineCompetition < ApplicationRecord
  validates_presence_of :name
  validates_inclusion_of :visible, in: [true, false]
  validates :slug, presence: true, uniqueness: true,
    allow_blank: false, format: { with: /\A\w+\z/, message: "caractères interdits présents" }

  scope :by_start_date, -> { order(start_date: :desc) }
  scope :visible, -> { where(visible: true) }

  has_many :results
  has_one_attached :scrambles_pdf
  MAX_FILE_SIZE = 3.megabytes.freeze
  validates(:scrambles_pdf, content_type: {
    in: %w(application/pdf),
    message: "is not a pdf",
  }, size: {
    less_than: MAX_FILE_SIZE,
    message: "Must be less than #{MAX_FILE_SIZE} bytes",
  })

  serialize :scrambles, OnlineScrambles

  validate :associated_scrambles
  def associated_scrambles
    unless scrambles.valid?
      scrambles.errors.messages.each do |k, v|
        errors.add(k, v.join(","))
      end
    end
  end

  # Helper for the form to delete an attachment
  attr_reader :delete_pdf

  after_save :set_pdf_filename
  def set_pdf_filename
    if self.scrambles_pdf.attached?
      self.scrambles_pdf.blob.update(filename: "#{self.slug || self.id}_Scrambles.pdf")
    end
  end

  validate :dates_are_valid
  def dates_are_valid
    return errors.add(:start_date, "Pas de date de début") unless start_date.present?
    return errors.add(:end_date, "Pas de date de fin") unless end_date.present?

    if end_date < start_date
      errors.add(:end_date, "La compétition finie avant d'avoir commencée...")
    end
  end

  def scrambles=(arg)
    self[:scrambles] = OnlineScrambles.new(arg)
  end

  def over?
    force_close || end_date < Date.today
  end

  def started?
    start_date <= Date.today
  end

  def ongoing?
    started? && !over?
  end

  def visible?
    visible
  end

  def unique_competitors
    User.where(id: results.select("distinct user_id"))
  end
end
