require 'rails_helper'

describe PaymentTransaction do

  include PaymentTransactionHelper

  let(:transaction) { described_class.new(sale_transaction_params) }

  context '.factory!' do

    context 'step 8' do

      it 'returns payment transaction instance' do
        expect(described_class.factory!( {} )).to be_a PaymentTransaction
      end
    end

    context 'step 9' do

      it 'checks transaction type' do
        expect(PaymentTransaction).to receive(:void_transaction?)

        described_class.factory!( {} )
      end
    end

    context 'step 10' do

      it 'builds sale transaction from params' do
        expect(PaymentTransaction).to receive(:new).with(sale_transaction_params)

        described_class.factory!(sale_transaction_params)
      end
    end

    context 'step 11' do

      before(:each) { allow(SecureRandom).to receive(:hex).with(16).and_return('11f0c7f0e46ef8c37c1ad99344ebed36') }

      it 'builds void transaction from params' do
        expect(PaymentTransaction).to receive(:build_from_reference).with(void_transaction_params)

        described_class.factory!(void_transaction_params)
      end
    end

    context 'when transaction type is void' do

      context 'when the referenced transaction does not exist' do

        let(:non_existent_reference_trx_unique_id) { generate_unique_id }

        it 'returns invalid transaction' do
          transaction = described_class.factory!(reference_id:     non_existent_reference_trx_unique_id,
                                                 transaction_type: PaymentTransaction::TYPE_VOID)

          expect(transaction).to_not be_valid
          expect(transaction.errors[:reference_id]).to include 'Invalid reference transaction!'
        end
      end

      context "when the referenced transaction is not a #{described_class::TYPE_SALE} transaction" do

        let(:persisted_void_transaction) { create_void_transaction }

        it 'returns invalid transaction' do
          transaction = described_class.factory!(reference_id:     persisted_void_transaction.unique_id,
                                                 transaction_type: PaymentTransaction::TYPE_VOID)

          expect(transaction).to_not be_valid
          expect(transaction.errors[:reference_id]).to include 'Invalid reference transaction!'
        end
      end

      context 'when the reference is valid' do

        it 'builds transaction from reference' do
          transaction.status = described_class::STATUS_APPROVED
          transaction.save

          void_transaction = described_class.factory!(reference_id: transaction.unique_id, transaction_type: PaymentTransaction::TYPE_VOID)

          expect(void_transaction).to be_valid
          expect(void_transaction.card_holder).to eq transaction.card_holder
        end
      end
    end
  end

  context '#process!' do

    context 'step 12' do

      it 'process the transaction through its gateway' do
        expect(Gateway).to receive(:process!).with(transaction)

        transaction.process!
      end
    end
  end
end
