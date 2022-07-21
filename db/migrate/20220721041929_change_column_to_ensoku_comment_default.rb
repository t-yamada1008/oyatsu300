class ChangeColumnToEnsokuCommentDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :ensokus, :comment, 'no_comment'
  end
end
