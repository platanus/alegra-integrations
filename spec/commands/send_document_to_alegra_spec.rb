require 'rails_helper'

describe SendDocumentToAlegra do
  def perform(*_args)
    described_class.for(*_args)
  end

  pending "describe what perform does here"
end