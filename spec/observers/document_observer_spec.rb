require 'rails_helper'

describe DocumentObserver do
  let(:object) do
    create(:document, document_type: :sale,
                      bsale_id: 369,
                      alegra_id: 123,
                      bsale_info: "bsale aditional info")
  end

  def trigger(_type, _event)
    described_class.trigger(_type, _event, object)
  end

  describe "#send_document_to_alegra" do
    it "call send_document_to_alegra after_create" do
      expect(SendDocumentToAlegra).to receive(:for).with(document: object).once
      trigger(:after, :create)
    end
  end
end
