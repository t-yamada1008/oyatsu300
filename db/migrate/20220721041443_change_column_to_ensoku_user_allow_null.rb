class ChangeColumnToEnsokuUserAllowNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :ensokus, :user_id, true
  end
end
