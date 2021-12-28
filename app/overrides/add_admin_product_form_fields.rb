Deface::Override.new(virtual_path: 'spree/admin/products/_form',
                     name: 'product_assembly_admin_product_types',
                     insert_before: "[data-hook='admin_product_form_taxons']",
                     original: 'efc1fd2863d6d030307ae3e030f1a7ceb4e95943',
                     partial: 'spree/admin/products/pouch_options',
                     disabled: false)
