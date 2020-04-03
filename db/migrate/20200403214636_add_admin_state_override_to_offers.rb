class AddAdminStateOverrideToOffers < ActiveRecord::Migration[5.2]
  def change
    add_column :offers, :admin_state_override, :boolean, default: false
  end
end
