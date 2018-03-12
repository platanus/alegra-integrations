class SendDocumentToAlegraJob < ApplicationJob
  queue_as :default

  def perform(document)
    SendDocumentToAlegra.for(document: document)
  end
end
