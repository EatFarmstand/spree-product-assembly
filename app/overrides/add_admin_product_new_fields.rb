Deface::Override.new(virtual_path: 'spree/admin/products/new',
                     name: 'product_assembly_admin_product_form_right',
                     insert_before: "[data-hook='new_product_attrs']",
                     partial: 'spree/admin/products/product_assembly_fields',
                     original: 'd12e020e6c8008c73a0fe5298e6469b607646d9a',
                     disabled: false)

Deface::Override.new(virtual_path: 'spree/admin/products/new',
                     name: 'product_assembly_admin_product_new_pouch_type',
                     insert_after: "[data-hook='admin_product_form_individual_sale']",
                     partial: 'spree/admin/products/pouch_or_product_options',
                     original: 'efc1fd2863d6d030307ae3e030f1a7ceb4e95943',
                     disabled: false)
