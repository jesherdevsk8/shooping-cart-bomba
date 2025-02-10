# frozen_string_literal: true

require 'rails_helper'

# rspec spec/jobs/mark_cart_as_abandoned_job_spec.rb

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  context '#perform' do
    let!(:cart) { create(:cart, updated_at: 4.days.ago) }

    describe 'when performing job' do
      it 'calls mark_as_abandoned and cleanup_abandoned on Cart' do
        expect(Cart.active.where('updated_at < ?', 3.hours.ago).size).to eq(1)

        described_class.perform_now

        expect(Cart.active.where('updated_at < ?', 3.hours.ago)).to be_empty
        expect(Cart.abandoned.exists?(cart.id)).to be_truthy

        cart.update_column(:updated_at, 8.days.ago)
        expect(Cart.abandoned.size).to eq(1)
        described_class.perform_now

        expect(Cart.abandoned.size).to eq(0)
      end
    end

    describe 'When enqueuing job' do
      describe 'When enqueuing job' do
        it 'enqueues the job in the default queue' do
          ActiveJob::Base.queue_adapter = :test

          expect do
            described_class.perform_later
          end.to have_enqueued_job(MarkCartAsAbandonedJob).on_queue('default')
        end
      end
    end
  end
end
