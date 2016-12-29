class AddScoreToSubmissions < ActiveRecord::Migration[5.0]
  def change
	  add_column :submissions, :score, :int
  end
end
