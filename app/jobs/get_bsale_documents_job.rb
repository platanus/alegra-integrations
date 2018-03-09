class GetBsaleDocumentsJob < ApplicationJob
  queue_as :default

  def perform
    GetBsaleDocuments.for
  end
end
