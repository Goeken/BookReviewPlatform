# frozen_string_literal: true

class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.integer :publication_year
      t.string :isbn
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :books, :title
    add_index :books, :author
  end
end
