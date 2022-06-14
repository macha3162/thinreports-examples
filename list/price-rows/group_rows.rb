# coding: utf-8

require 'bundler'
Bundler.require

Price = Struct.new :tax_type, :exclude_tax, :tax

prices = [
  Price.new('10%対象', 2000, 200),
  Price.new('8%対象', 100, 8),
  Price.new('軽減税率8%対象', 100, 8)
]

report = Thinreports::Report.new layout: 'group_rows.tlf'

report.list('total') do |list|
  exclude_total = tax_total = 0
  prices.each do |price|
    list.add_row do |row|
      row.item(:tax_type).value(price.tax_type)
      row.item(:exclude_tax).value(price.exclude_tax)
      row.item(:tax).value(price.tax)
      exclude_total += price.exclude_tax
      tax_total += price.tax
    end
  end
  list.header.item(:total).value(exclude_total + tax_total)
  list.on_footer_insert do |footer|
    footer.values exclude_total: exclude_total
    footer.values tax_total: tax_total
  end
end

report.generate filename: 'result.pdf'
