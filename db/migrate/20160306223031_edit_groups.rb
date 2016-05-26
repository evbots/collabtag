class EditGroups < ActiveRecord::Migration
  def change
    change_table :groups do |t|
      t.remove :url
      t.rename :tags, :tag
    end
  end
end
