class ChangeTagsAddTimestamps < ActiveRecord::Migration
  def up
    add_timestamps :tags

    t = Time.zone.now
    Tag.update_all(created_at: t, updated_at: t)

    #http://apidock.com/rails/ActiveRecord/ConnectionAdapters/ConnectionPool
    #sql = "update tags set created_at = '#{t.to_s(:db)}', updated_at = '#{t.to_s(:db)}'"
    #1
    #connection = ActiveRecord::Base.connection
    #connection.execute(sql)
    #ActiveRecord::Base.clear_active_connections!

    #2
    #connection = ActiveRecord::Base.connection_pool.checkout
    #connection.execute(sql)
    #ActiveRecord::Base.connection_pool.checkin(connection)

    #3
    #ActiveRecord::Base.connection_pool.with_connection do
    #  connection.execute(sql)
    #end
  end

  def down
    remove_timestamps :tags
  end
end
