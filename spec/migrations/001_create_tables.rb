Sequel.migration do
  change do
    create_table  :items do
      primary_key :id
      String      :name
      String      :manufacturer
      String      :origin
      String      :owner
      Float       :price
    end

    create_table  :comments do
      primary_key :id
      foreign_key :item_id, :items, :type => Fixnum
      String      :content
      DateTime    :created_at
      index       :item_id
    end

    create_table  :comments_items do
      foreign_key :comment_id, :comments, :type => Fixnum
      foreign_key :item_id, :items, :type => Fixnum
      index       [:comment_id, :item_id], :unique => true
    end
  end
end
