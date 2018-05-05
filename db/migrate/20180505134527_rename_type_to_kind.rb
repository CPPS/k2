class RenameTypeToKind < ActiveRecord::Migration[5.1]
  def change
  	rename_column :achievements, :type, :kind
  end
end
