class AddDateOfCompletionToAchievement < ActiveRecord::Migration[5.1]
  def change
  	add_column :achievements, :date_of_completion, :datetime
  end
end
