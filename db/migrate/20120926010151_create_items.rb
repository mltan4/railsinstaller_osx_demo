class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :title
      t.references :category
      t.integer :quantity
      t.text :description
      t.decimal :buy_price
      t.decimal :minimum_bid_price
      t.integer :bid_duration

      t.timestamps
    end
  end
end
