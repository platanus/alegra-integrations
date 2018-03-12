require 'rails_helper'

describe SendDocumentToAlegra do
  def perform(*_args)
    described_class.for(*_args)
  end

  before do
    allow_any_instance_of(AlegraClient).to receive(:get_contact_by_rut).with(document.rut)
                                                                           .and_return("id": 4)
  end

  describe "#perform" do
    context "create sale document" do
      let(:document) do
        create(:document, :sale)
      end

      let(:document_hash) do
        {
          id_client: 4,
          bill_number: document.legal_id,
          bill_date: document.date,
          bill_due_date: document.date,
          price: document.amount
        }
      end

      before do
        allow_any_instance_of(AlegraClient).to receive(:create_document).with(document_hash)
                                                                        .and_return("id": 123)

        perform(document: document)
      end

      it { expect(document.reload.alegra_id).to eq(123) }
    end
  end

  context "create buy document" do
    let(:document) do
      create(:document, :buy)
    end

    let(:document_hash) do
      {
        id_client: 4,
        bill_number: document.legal_id,
        bill_date: document.date,
        bill_due_date: document.date,
        price: document.amount,
        category_id: 12
      }
    end

    before do
      allow_any_instance_of(AlegraClient).to receive(:create_third_party_document).with(document_hash)
                                                                      .and_return("id": 123)

      perform(document: document)
    end

    it { expect(document.reload.alegra_id).to eq(123) }
  end
end
