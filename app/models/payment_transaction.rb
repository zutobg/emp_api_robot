class PaymentTransaction < ApplicationRecord

  ATTRIBUTES_FOR_PRESENCE_VALIDATION = [:card_holder, :card_number, :usage, :email, :amount, :address]
  STATUS_APPROVED                    = 'approved'.freeze
  STATUS_VOIDED                      = 'voided'.freeze
  TYPE_VOID                          = 'void'.freeze
  TYPE_SALE                          = 'sale'.freeze
  SUPPORTED_TRANSACTION_TYPES        = [TYPE_SALE, TYPE_VOID]

  validates_presence_of ATTRIBUTES_FOR_PRESENCE_VALIDATION, if: -> { sale_transaction? }
  validates_presence_of [:cvv, :expiration_date],           if: -> { sale_transaction? }

  validates :transaction_type, inclusion: { in: SUPPORTED_TRANSACTION_TYPES }
  validates :amount, numericality: { only_integer: true, greater_than: 0 }, if: -> { sale_transaction? }

  validates_format_of :email,       with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, if: -> { sale_transaction? }
  validates_format_of :card_number, with: /\A[0-9]{13,19}\Z/i,                           if: -> { sale_transaction? }
  validates_format_of :cvv,         with: /\A[0-9]{3,4}\Z/i,                             if: -> { sale_transaction? }

  validate :validates_approved_reference, unless: -> { sale_transaction? }

  before_save :generate_unique_id

  attr_accessor :cvv, :expiration_date

  class << self

    def factory!(params)
      return build_from_reference(params) if void_transaction?(params)

      PaymentTransaction.new(params)
    end

    def build_from_reference(params)
      reference_id          = params[:reference_id]
      reference_transaction = approved_reference_transaction_for(reference_id)

      params.merge!(void_attributes_for(reference_transaction)) if reference_transaction

      PaymentTransaction.new(params)
    end

    def approved_reference_transaction_for(reference_id)
      find_by(unique_id: reference_id, transaction_type: TYPE_SALE, status: STATUS_APPROVED)
    end

    private

    def void_transaction?(params)
      params[:transaction_type] == TYPE_VOID && params.key?(:reference_id)
    end

    def void_attributes_for(reference_transaction)
      reference_transaction.attributes.slice('card_holder', 'usage', 'email', 'amount', 'address')
    end

  end


  def process!
    ##TODO pass transaction to Gateway to be processed
    Gateway.process!(self)
  end

  private

  def sale_transaction?
    transaction_type == TYPE_SALE
  end

  def generate_unique_id
    self.unique_id = SecureRandom.hex(16)
  end

  def validates_approved_reference
    return if PaymentTransaction.approved_reference_transaction_for(reference_id).present?

    errors[:reference_id] << 'Invalid reference transaction!'
  end

end
