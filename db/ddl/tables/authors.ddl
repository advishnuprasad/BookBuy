create table authors as
SELECT authorid id, 
  trim(firstname || ' ' || lastname) name 
  from authorprofile@jbclclink
