require 'active_support/concern'

module ActsAsMessageable
  module Scopes
    extend ActiveSupport::Concern

    included do
      initialize_scopes
    end

    module ClassMethods
      def initialize_scopes
        unless respond_to? :are_from, true
          scope :are_from,       lambda { |*args|
            where(:sent_messageable_id => args.first, :sent_messageable_type => args.first.class.name)
          }
        end

        unless respond_to? :are_to, true
          scope :are_to,         lambda { |*args|
            where(:received_messageable_id => args.first, :received_messageable_type => args.first.class.name)
          }
        end

        unless respond_to? :search, true
          scope :search,         lambda { |*args|
            where("body like :search_txt or topic like :search_txt",:search_txt => "%#{args.first}%")
          }
        end

        unless respond_to? :connected_with, true
          scope :connected_with, lambda { |*args|
            where("(sent_messageable_type = :sent_type and
                    sent_messageable_id = :sent_id and
                    sender_delete = :s_delete and sender_permanent_delete = :s_perm_delete) or
                    (received_messageable_type = :received_type and
                    received_messageable_id = :received_id and
                    recipient_delete = :r_delete and recipient_permanent_delete = :r_perm_delete)",
                  :sent_type      => args.first.class.resolve_active_record_ancestor.to_s,
                  :sent_id        => args.first.id,
                  :received_type  => args.first.class.resolve_active_record_ancestor.to_s,
                  :received_id    => args.first.id,
                  :r_delete       => args.last,
                  :s_delete       => args.last,
                  :r_perm_delete  => false,
                  :s_perm_delete  => false)
          }
        end

        unless respond_to? :readed, true
          scope :readed,         lambda { where('opened_at is not null') }
        end

        unless respond_to? :unreaded, true
          scope :unreaded,       lambda { where(:opened_at => nil) }
        end

        unless respond_to? :deleted, true
          scope :deleted,        lambda { where(:recipient_delete => true, :sender_delete => true) }
        end
      end
    end
  end
end
