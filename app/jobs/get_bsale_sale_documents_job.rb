class GetBsaleSaleDocumentsJob < ApplicationJob
  queue_as :default

  def perform
    GetBsaleSaleDocuments.for
  end
end
