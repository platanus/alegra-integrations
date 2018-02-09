class EntryObserver < PowerTypes::Observer
  after_create :send_entry

  def send_entry
    SendEntryToAlegraJob.perform_later(object)
  end
end
