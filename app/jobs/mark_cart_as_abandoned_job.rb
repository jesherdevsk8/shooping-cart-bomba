# frozen_string_literal: true

class MarkCartAsAbandonedJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Cart.mark_as_abandoned
    Cart.cleanup_abandoned
  end
end
