require 'spidr'
require 'CSV'

title_spidr,meta_spidr = [],[]

Spidr.site('http://blog.techladies.co/') do |spider|
  spider.every_html_page do |page|

    if page.doc
      page.doc.xpath('/html/head/title').each do |title|
        title_spidr << title.text
      end
    end

    if page.doc
      page.doc.xpath("// meta[@name='description']/@content").each do |meta|
        meta_spidr << meta.text
      end
    end

    # If meta description doesn't exist, fill it with an empty string
    meta_spidr.fill(meta_spidr.size..title_spidr.size-1) { "  " }
  end
end

csv_input = (title_spidr).zip(meta_spidr)

CSV.open("file.csv", "wb") do |csv|
  csv << ["Title", "Meta Description"]
  csv_input.each do |crawled_page|
    csv << crawled_page
  end
end