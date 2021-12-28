class AddPouchTypeToSpreeProducts < ActiveRecord::Migration[6.1]
  def up
    execute <<-SQL
      CREATE TYPE product_pouch_type AS ENUM ('base', 'main', 'side');
    SQL
    add_column :spree_products, :pouch_type, :product_pouch_type
    add_index :spree_products, :pouch_type
  end

  def down
    remove_column :spree_products, :pouch_type
    execute <<-SQL
      DROP TYPE product_pouch_type;
    SQL
  end
end
