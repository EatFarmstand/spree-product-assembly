module Spree
  class AssembliesPart < ActiveRecord::Base
    belongs_to :assembly, class_name: 'Spree::Variant',
                          foreign_key: 'assembly_id',
                          touch: true

    belongs_to :part, class_name: 'Spree::Variant', foreign_key: 'part_id'

    delegate :name, :sku, to: :part

    after_create :set_master_unlimited_stock

    validate :no_duplicate_pouch

    def self.get(assembly_id, part_id)
      find_or_initialize_by(assembly_id: assembly_id, part_id: part_id)
    end

    def options_text
      if variant_selection_deferred?
        Spree.t(:user_selectable)
      else
        part.options_text
      end
    end

    private

    def set_master_unlimited_stock
      part.product.master.update_attribute :track_inventory, false if part.product.variants.any?
    end

    def no_duplicate_pouch
      errors.add(:product, Spree.t(:no_duplicate_pouch)) if pouch_part_of_type?(part.product.pouch_type)
    end

    def pouch_part_of_type?(type)
      assembly.product.parts.any? do |part|
        part.product.pouch_type == type
      end
    end
  end
end
