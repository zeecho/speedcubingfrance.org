class ExternalResource < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates :link, :format => URI::regexp(%w(http https))
  validates :img, :format => URI::regexp(%w(http https))

  before_save :set_ranks_on_save, if: :will_save_change_to_rank?
  private def set_ranks_on_save
    if self.rank_was.nil?
      ExternalResource.where("rank >= ?", rank).update_all("rank = rank + 1")
    else
      if self.rank > self.rank_was
	self.rank = self.rank - 1
        ExternalResource.where("rank > ?", rank_was).where("rank <= ?", rank).update_all("rank = rank - 1")
      else
        ExternalResource.where("rank < ?", rank_was).where("rank >= ?", rank).update_all("rank = rank + 1")
      end
    end
  end

  after_destroy :fix_rank
  private def fix_rank
    ExternalResource.where("rank > ?", rank).update_all("rank = rank - 1")
  end
end
