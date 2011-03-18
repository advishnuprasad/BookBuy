create table publishers as
  select publishercode id, publishername name, publishercountry country 
  from publisherprofile@JBCLCLINK
