module PaymentTransactionHelper

  private

  def create_void_transaction(reference_transaction = nil)
    build_void_transaction(reference_transaction).tap do |transaction|
      transaction.status = PaymentTransaction::STATUS_APPROVED
      transaction.save
    end
  end

  def build_void_transaction(reference_transaction = nil)
    PaymentTransaction.new(void_transaction_params(reference_transaction || create_sale_transaction))
  end

  def create_sale_transaction
    build_sale_transaction.tap do |transaction|
      transaction.status = PaymentTransaction::STATUS_APPROVED
      transaction.save
    end
  end

  def build_sale_transaction
    PaymentTransaction.new(sale_transaction_params)
  end

  def sale_transaction_params
    {
      card_holder:      'Panda Panda',
      card_number:      '4200000000000000',
      cvv:              '123',
      expiration_date:  '09/2016',
      email:            'panda@example.com',
      amount:           100,
      usage:            'New por',
      transaction_type: PaymentTransaction::TYPE_SALE,
      reference_id:     nil,
      address: {
        first_name: 'Panda',
        last_name:  'Panda',
        city:       'Sofia'
      }
    }
  end

  def void_transaction_params(reference_transaction = nil)
    {
      transaction_type: PaymentTransaction::TYPE_VOID,
      reference_id:     reference_transaction&.unique_id || generate_unique_id
    }
  end

  def generate_unique_id
    SecureRandom.hex(16)
  end

end
