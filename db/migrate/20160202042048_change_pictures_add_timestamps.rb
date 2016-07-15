class ChangePicturesAddTimestamps < ActiveRecord::Migration
  def change
    add_timestamps :pictures
  end
end
