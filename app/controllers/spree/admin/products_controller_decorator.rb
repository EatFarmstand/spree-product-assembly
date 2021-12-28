module Spree
  module Admin
    module ProductsControllerDecorator
      def create
        super

        return unless @product.individual_sale?

        part_params.each_value do |part|
          part = Spree::Product.find(part.to_i)
          Spree::AssembliesPart.create(assembly: @product.master, part: part.master)
        end
        @product.reload # For parts to show
      end

      private

      def part_params
        params.require(:part).permit(%i[base_pouch_id main_pouch_id side_pouch_id])
      end
    end
  end
end

Spree::Admin::ProductsController.prepend Spree::Admin::ProductsControllerDecorator
