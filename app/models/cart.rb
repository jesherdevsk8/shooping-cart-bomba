class Cart < ApplicationRecord
  has_many :items, class_name: 'CartItem', dependent: :destroy
  has_many :products, through: :items

  validates_numericality_of :total_price, greater_than_or_equal_to: 0

  enum status: { active: 'active', abandoned: 'abandoned' }

  def total_price
    items.sum(:total_price)
  end

  def self.mark_as_abandoned
    # Abandonar carrinhos que não foram atualizados nas últimas 3 horas
    abandoned_carts = active.where('updated_at < ?', 3.hours.ago)
    return unless abandoned_carts.exists?

    abandoned_carts.update_all(status: :abandoned)
  end

  def self.cleanup_abandoned
    # excluir carrinhos que não foram atualizados nos ultimos 7 dias
    abandoned.where('updated_at < ?', 7.days.ago).destroy_all
  end
end
