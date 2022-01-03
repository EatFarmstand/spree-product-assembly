module Spree::ProductDecorator
  POUCH_TYPES = %w[base main side].freeze

  def self.prepended(base)
    base.has_many :assemblies_parts, through: :variants_including_master,
                                     source: :parts_variants
    base.has_many :parts, through: :assemblies_parts

    base.scope :individual_saled, -> { where(individual_sale: true) }

    base.scope :search_can_be_part, lambda { |query|
      not_deleted.available.joins(:master)
                 .where(arel_table['name'].matches("%#{query}%").or(Spree::Variant.arel_table['sku'].matches("%#{query}%")))
                 .where(can_be_part: true)
                 .limit(30)
    }

    base.validate :assembly_cannot_be_part, if: :assembly?

    base.enum pouch_type: Hash[*POUCH_TYPES.collect { |v| [v, v] }.flatten], _suffix: true
    base.validates_presence_of :pouch_type, if: :can_be_part?
    base.validates :individual_sale?, presence: false, if: :can_be_part?

    base.validates :can_be_part?, presence: false, if: :individual_sale?
    base.validate :pouch_type, presence: false, if: :individual_sale?

    base.scope :main_pouches, -> { where(pouch_type: 'main') }
    base.scope :side_pouches, -> { where(pouch_type: 'side') }
    base.scope :base_pouches, -> { where(pouch_type: 'base') }
  end

  def variants_or_master
    has_variants? ? variants : [master]
  end

  def assembly?
    parts.exists?
  end

  def count_of(variant)
    ap = assemblies_part(variant)
    # This checks persisted because the default count is 1
    ap.persisted? ? ap.count : 0
  end

  def assembly_cannot_be_part
    errors.add(:can_be_part, Spree.t(:assembly_cannot_be_part)) if can_be_part?
  end

  private

  def assemblies_part(variant)
    Spree::AssembliesPart.get(id, variant.id)
  end
end

Spree::Product.prepend Spree::ProductDecorator
