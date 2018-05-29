class AddAssignedToToClaims < ActiveRecord::Migration[5.2]
  def change
    add_reference :claims, :assigned_to, foreign_key: {to_table: :egov_utils_users}
  end
end
