class AddPersonBirthday < ActiveRecord::Migration

  def change
    add_column :people, :birthday, :date, after: :birthyear
  end
  
end
