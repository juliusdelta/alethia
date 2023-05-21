# frozen_string_literal: true

class CreateBills < ActiveRecord::Migration[7.1]
  def change
    create_table :bills do |t|
      t.string :origin_chamber
      t.string :session
      t.string :short_title
      t.string :title
      t.string :branch
      t.string :su_doc_class_number
      t.string :doc_class
      t.string :bill_number
      t.string :category
      t.datetime :date_issued
      t.datetime :last_modified
      t.string :bill_version
      t.string :gov_info_url
      t.string :text_url
      t.text :bill_text
      t.jsonb :gov_info_raw_payload
      t.timestamps
    end
  end
end
