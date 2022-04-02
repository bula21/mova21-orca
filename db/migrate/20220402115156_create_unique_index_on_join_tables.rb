class CreateUniqueIndexOnJoinTables < ActiveRecord::Migration[6.1]
  def change
    remove_duplicates_of_join_table('activities_tags', 'activity_id', 'tag_id', 'index_activities_tags_on_activity_id_and_tag_id')
    remove_duplicates_of_join_table('activities_goals', 'activity_id', 'goal_id', 'index_activities_goals_on_activity_id_and_goal_id')
    remove_duplicates_of_join_table('activities_stufen', 'activity_id', 'stufe_id', 'index_activities_stufen_on_activity_id_and_stufe_id')
    remove_duplicates_of_join_table('activities_stufen_recommended', 'activity_id', 'stufe_id', 'unique_activities_stufen_recommended_index')
  end

  def remove_duplicates_of_join_table(table_name, pk_1, pk_2, index_name)
    duplicates = execute <<-SQL
      select #{pk_1}, #{pk_2} from #{table_name}
      group by #{pk_1}, #{pk_2} 
      having count(#{pk_1}) > 1
    SQL
    duplicates_as_array = duplicates.to_a

    if duplicates_as_array.any?
      or_conditions = duplicates_as_array.map { |d| "(#{pk_1} = #{d[pk_1]} and #{pk_2} = #{d[pk_2]})" }.join(' OR ')
      execute <<-SQL
        DELETE FROM #{table_name} 
        WHERE #{or_conditions}
      SQL
      insert_values = duplicates_as_array.map { |d| "(#{d[pk_1]}, #{d[pk_2]})" }.join(',')
      execute <<-SQL
        INSERT INTO #{table_name}(#{pk_1},#{pk_2}) 
        VALUES #{insert_values}
      SQL
    end
    if index_exists? table_name.to_sym, [pk_1.to_sym, pk_2.to_sym], name: index_name
      remove_index table_name.to_sym, [pk_1.to_sym, pk_2.to_sym], name: index_name
    end
    add_index table_name.to_sym, [pk_1.to_sym, pk_2.to_sym], name: index_name, unique: true
  end
end
