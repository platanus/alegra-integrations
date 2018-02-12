class SendEntryToAlegraJob < ApplicationJob
  queue_as :default

  def perform(entry)
    SendEntryToAlegra.for(entry: entry)
  end
end
