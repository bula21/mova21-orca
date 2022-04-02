class AddGeneratedToInvoice < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :generated, :boolean, default: true
  end
end
