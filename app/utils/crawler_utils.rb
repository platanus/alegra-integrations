module CrawlerUtils
  extend self

  def click_on_link_with_text(pincers, selector, text)
    pincers.search("#{selector} a:contains('#{text}')").click
  end
end
