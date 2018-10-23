class ExternalResource < ApplicationRecord
  validates_presence_of :name
  validates_presence_of :description
  validates :link, :format => URI::regexp(%w(http https))
  validates :img, :format => URI::regexp(%w(http https))

  before_update :set_ranks_on_update, if: :will_save_change_to_rank?
  private def set_ranks_on_update
    er_count = ExternalResource.all.count
    if rank > er_count
      self.rank = er_count
    end
    if rank < 1
      self.rank = 1
    end
    if self.rank > self.rank_was
      ExternalResource.where("rank > ?", rank_was).where("rank <= ?", rank).update_all("rank = rank - 1")
    else
      ExternalResource.where("rank < ?", rank_was).where("rank >= ?", rank).update_all("rank = rank + 1")
    end
  end

  after_create :set_rank_on_create
  private def set_rank_on_create
    update_column :rank, ExternalResource.all.count
  end

  after_destroy :fix_rank
  private def fix_rank
    ExternalResource.where("rank > ?", rank).update_all("rank = rank - 1")
  end
end
