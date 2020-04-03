class RemoveStateFromOffers < ActiveRecord::Migration[5.2]
  def up
    remove_column :offers, :state
  end

  def down
    add_column :offers, :state, :integer
  end
end
