Factory.define :user do |user|
  user.username         'Subhash Bhushan'
  user.email            'subhash.bhushan@gmail.com'
end

Factory.define :list do |list|
  #10109
  list.name             'NG-HBS New Arrivals'
  list.kind             'NENT'
  list.key              '1310916824658'
  list.description      'NG-HBS New Arrivals'
end

Factory.define :listitem do |listitem|
  #11031 - 11039
  listitem.association  :list
  listitem.isbn         '9781422172230'
  listitem.title        'HBR on Advancing Your Career'
  listitem.author       'No Author'
  listitem.publisher    'Harward Publications'
  listitem.publisher_id 68
  listitem.quantity     4
  listitem.currency     'INR'
  listitem.listprice    595
end

Factory.define :procurement do |procurement|
  #10189
  procurement.association :list
  procurement.description 'NG-HBS New Arrivals'
  procurement.kind        'NENT'
  procurement.status      'Open'
end

Factory.define :procurementitem do |pitem|
  #158633 - 158641
  pitem.source            'NENT'
  pitem.association       :listitem
  pitem.association       :enrichedtitle
  pitem.isbn              '9781422172230'
  pitem.status            'Assigned'
  pitem.association       :supplier
  pitem.association       :branch
  pitem.association       :procurement
  pitem.quantity          4  
end

Factory.define :supplier do |supplier|
  supplier.name           'India Book Distributors'
  supplier.contact        'Deepak'
  supplier.phone          '080 41440222'
  supplier.city           'Bangalore'
  supplier.email          'ibdbang.blr@airtelmail.in'
  supplier.creditperiod   90
  supplier.discount       40
end

Factory.define :publisher do |publisher|
  publisher.id            68
  publisher.name          'Harward Publications'
end

Factory.define :branch do |branch|
  branch.id               952
  branch.name             '952 - Warehouse Branch'
  branch.category3        'H'
  branch.association      :parent
  branch.card_id          'MWAREHOUSEBR'
  branch.city_id          26    
end

Factory.define :enrichedtitle do |enrichedtitle|
  #32742
  enrichedtitle.title             'HBR on Advancing Your Career'
  enrichedtitle.isbn              '9781422172230'
  enrichedtitle.author            'No Author'
  enrichedtitle.listprice         595
  enrichedtitle.currency          'INR'
end

Factory.define :imprint do |imprint|
  #10061
  imprint.code            '1-4221'
end
