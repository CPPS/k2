class CreateServers < ActiveRecord::Migration[5.0]
  def change
    create_table :servers do |t|
      t.string :name
      t.string :url
      t.string :api_type
      t.string :api_endpoint

      t.timestamps
    end
  end
end
