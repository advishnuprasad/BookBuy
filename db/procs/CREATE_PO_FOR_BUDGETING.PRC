create or replace
PROCEDURE CREATE_PO_FOR_BUDGETING (p_type NUMBER, p_ponumber VARCHAR2, p_date DATE, p_quantity NUMBER, 
  p_rate NUMBER, p_grossamount NUMBER, p_discount NUMBER, p_netamount NUMBER, p_supplierid NUMBER, p_narration VARCHAR2,
  p_pmttermdate1 DATE, p_pmttermamount1 NUMBER,p_pmttermdate2 DATE, p_pmttermamount2 NUMBER,p_pmttermdate3 DATE, p_pmttermamount3 NUMBER,
  p_orgunit number, p_suborgunit number, p_expensehead number, p_branchid number)
AS
BEGIN
  INSERT INTO nonbookpomaster
  (potype, ponumber, podate, postaff, poquantity, 
  porate, pogrossamount, discount, ponetamount, 
  suppliercode, ponarration, popmttermdate1, 
  popmttermamount1, popmttermdate2, popmttermamount2,
  popmttermdate3, popmttermamount3, orgunit, suborgunit,poexpensehead, postatus, branchid)
  VALUES
  (p_type, p_ponumber, p_date, 'BOOKBUY', p_quantity, 
  p_rate, p_grossamount, p_discount, p_netamount, 
  p_supplierid, p_narration, p_pmttermdate1, 
  p_pmttermamount1, p_pmttermdate2, p_pmttermamount2,
  p_pmttermdate3, p_pmttermamount3, p_orgunit, p_suborgunit, p_expensehead,0, p_branchid);
  
  update budgetmaster
  set openpoamount = nvl(openpoamount,0) + p_pmttermamount1 
  where orgunit = p_orgunit
  and suborgunit = p_suborgunit
  and expensetype = p_type
  and budgetdate = last_day(p_pmttermdate1);
  
  update budgetmaster
  set openpoamount = nvl(openpoamount,0) + p_pmttermamount2
  where orgunit = p_orgunit
  and suborgunit = p_suborgunit
  and expensetype = p_type
  and budgetdate = last_day(p_pmttermdate2);
  
  update budgetmaster
  set openpoamount = nvl(openpoamount,0) + p_pmttermamount3
  where orgunit = p_orgunit
  and suborgunit = p_suborgunit
  AND expensetype = p_type
  AND budgetdate = last_day(p_pmttermdate3);
END CREATE_PO_FOR_BUDGETING;