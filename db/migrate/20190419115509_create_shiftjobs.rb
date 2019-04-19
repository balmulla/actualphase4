class CreateShiftjobs < ActiveRecord::Migration[5.2]
  def change
    create_table :shiftjobs do |t|
      t.integer :shift_id
      t.integer :job_id

      t.timestamps
    end
  end
end
