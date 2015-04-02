class CreateMessagesTable < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.string :topic
      t.text :body
      t.references :received_messageable, :polymorphic => true
      t.references :sent_messageable, :polymorphic => true
      t.boolean :opened, :default => false
      t.boolean :recipient_delete, :default => false
      t.boolean :sender_delete, :default => false

      #closure_tree
      t.integer :parent_id, :null => true, :index => true

      t.timestamps
    end

    add_index :<%= table_name %>,  :received_messageable_id, :name => "acts_as_messageable_received_messageable_id"
    add_index :<%= table_name %>, :sent_messageable_id, :name => "acts_as_messageable_sent_messageable_id"
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
