BEGIN
  EXPAND_NEWARRIVALS_ITEMS(17);
END;

select count(*) from corelist where key_id=53
SELECT count(*) FROM newarrivals_expanded WHERE key_id=14
SELECT sum(qty) FROM newarrivals_expanded WHERE key_id=14
SELECT sum(qty) FROM CORELIST WHERE key_id = 19
select isbn, count(*) from corelist where key_id=18 group by isbn having count(*) > 1
select count(*) from newarrivals_expanded where key_id = 9

DECLARE
  I NUMBER := 39214;
BEGIN
  FOR rec IN (
    SELECT * FROM corelist WHERE KEY_ID in (10,11) order by key_id desc
  )
  loop
    INSERT INTO CORELIST (ID, KEY_ID, ISBN, TITLE, AUTHOR, PUBLISHER, PUBLISHERCODE, PRICE, CURRENCY, CATEGORY, SUBCATEGORY, QTY, BRANCHID)
    VALUES (I, 18, REC.ISBN, REC.TITLE, REC.AUTHOR, REC.PUBLISHER, REC.PUBLISHERCODE, REC.PRICE, REC.CURRENCY, REC.CATEGORY, REC.SUBCATEGORY, REC.QTY, 45);
    
    I := I + 1;
  END loop;
END;


BEGIN
  FOR rec IN (
    select * from newarrivals_expanded where isbn='9780330545266'
  )
  loop
    INSERT INTO newarrivals_expanded (ID, KEY_ID, ISBN, TITLE, AUTHOR, PUBLISHER, PUBLISHERCODE, PRICE, CURRENCY, CATEGORY, SUBCATEGORY, QTY, BRANCHID)
    VALUES (newarrivals_expanded_seq.nextval, 16, REC.ISBN, REC.TITLE, REC.AUTHOR, REC.PUBLISHER, REC.PUBLISHERCODE, REC.PRICE, REC.CURRENCY, REC.CATEGORY, REC.SUBCATEGORY, REC.QTY, rec.branchid);
  END loop;
END;

BEGIN
  compress_newarrivals(19);
end;

BEGIN
  REMOVE_DUPS_IN_CL(53);
end;

SELECT key_id, count(*) FROM newarrivals_expanded WHERE isbn='9780330545266' GROUP BY key_id

BEGIN
  DATA_PULL.PR_PULL_CORELIST_ITEMS(53);
END;

BEGIN
  DATA_PULL.PR_PULL_NEWARRIVAL_ITEMS(17);
END;

BEGIN
  DATA_PULL.pull_ibtr_items(1);
END;

SELECT COUNT(*) FROM PROCUREMENTITEMS --  50751/51967/52041/52061/52076/52279/52712/63453/64043
SELECT COUNT(*) FROM PROCUREMENTITEMS WHERE SOURCE = 'IBTR'--  50751/51967/52041/52061/52076/52279/52712/63453/64043
SELECT count(*) FROM PROCUREMENTITEMS WHERE po_number IS NULL
SELECT * FROM PROCUREMENTITEMS WHERE po_number IS NULL
SELECT COUNT(*) FROM ENRICHEDTITLES WHERE ISBNVALID ='N'
SELECT COUNT(*)  FROM ENRICHEDTITLES WHERE ISBNVALID IS NULL
SELECT * FROM ISBN_VALIDITY_IN_LIST
update enrichedtitles set isbnvalid=null where isbnvalid is null
SELECT * FROM ISBNS_OF_A_LI

BEGIN
  ENRICH_TITLES_FROM_JBDATA;
END;

SELECT COUNT(*) FROM enrichedtitles WHERE nvl(enriched,'N') = 'N'
select * from procurementitems where supplier_id not in (select id from suppliers)

BEGIN
  PULL_SUPPLIER(2544);
END;

BEGIN
  PULL_PUBLISHER(4071);
END;

BEGIN
  WORKLIST_GENERATOR.pr_create_corelist_wl;
END;

BEGIN
  WORKLIST_GENERATOR.PR_CREATE_NEWENTRY_WL;
END;

SELECT COUNT(*) FROM WORKLISTS -- 237 / 472
SELECT COUNT(*) FROM WORKITEMS -- 493 / 1401
delete FROM WORKLISTS -- 237 / 472
delete FROM WORKITEMS -- 493 / 1401

BEGIN
  GENERATE_POS('NSTR', 19);
END;

SELECT count(*) FROM pos -- 508 / 542 / 569 / 733 / 759 / 911 / 1016 / 1036 / 1178 / 1220
SELECT * FROM PROCUREMENTITEMS WHERE PO_NUMBER IS NULL

BEGIN
  REFRESH_PO_MASTER;
END;

SELECT CURRENCY, COUNT(*) FROM PO_VIEW GROUP BY CURRENCY
SELECT COUNT(*) FROM POS WHERE copies_cnt IS NULL
SELECT CURRENCY, COUNT(*) FROM ENRICHEDTITLES WHERE ID IN (
SELECT ENRICHEDTITLE_ID FROM PROCUREMENTITEMS WHERE PO_NUMBER IN (
SELECT CODE FROM POS WHERE copies_cnt IS NULL))
GROUP BY CURRENCY
SELECT * FROM pos ORDER BY ID DESC
SELECT ID, CODE, to_char(created_at, 'DD-MON-RR HH:MI:SS') FROM pos WHERE to_char(created_at,'DD-MON-RR') = '04-MAY-11' 
and code like 'NENT%' and id > 12117
order by id desc

BEGIN
  FOR i IN (
    SELECT CODE FROM pos where to_char(created_at,'DD-MON-RR') = '25-MAY-11' and code like 'NSTR%'
    )
  loop
    extract_pos(i.code);
  end loop;
end;

SELECT code FROM pos 
    WHERE code NOT IN (SELECT ponumber FROM nonbookpomaster@jbclclink WHERE ponumber IS NOT NULL)
    
BEGIN
  FOR rec IN (
    SELECT code FROM pos 
    WHERE code NOT IN (SELECT ponumber FROM nonbookpomaster@jbclclink WHERE ponumber IS NOT NULL)
  )
  loop
    push_po_to_fin(rec.code);
  end loop;
end;

SELECT  count(*)
    FROM enrichedtitles
    WHERE title_id IS NULL  --1364
SELECT count(*) FROM title_mig_log --412/1776

DECLARE
  I PLS_INTEGER;
BEGIN
  I := fn_push_new_titles();
  dbms_output.put_line('Rows - ' || I);
end;



update procurementitems set supplier_id=	161	 where enrichedtitle_id in (select id from enrichedtitles where publisher_id in (select id from publishers where group_id =	78	)) and isbn in (select isbn from corelist where key_id=14) and po_number is null;				
UPDATE procurementitems SET supplier_id=	162	 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id =	1621	)) AND isbn IN (SELECT isbn FROM corelist WHERE key_id=14) AND po_number IS NULL;				
UPDATE procurementitems SET supplier_id=	1312	 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id =	1000	)) AND isbn IN (SELECT isbn FROM corelist WHERE key_id=14) AND po_number IS NULL;				
UPDATE procurementitems SET supplier_id=	61	 WHERE enrichedtitle_id IN (SELECT ID FROM enrichedtitles WHERE publisher_id IN (SELECT ID FROM publishers WHERE group_id =	52	)) AND isbn IN (SELECT isbn FROM corelist WHERE key_id=14) AND po_number IS NULL;				
update procurementitems set supplier_id=	81	 where enrichedtitle_id in (select id from enrichedtitles where publisher_id in (select id from publishers where group_id =	6	)) and isbn in (select isbn from corelist where key_id=14) and po_number is null;

90 rows updated
136 rows updated
50 rows updated
80 ROWS UPDATED
46 rows updated

  SELECT count(a.id)
  FROM PROCUREMENTITEMS A,
    ENRICHEDTITLES B,
    PUBLISHERS C,
    CORELIST D
  WHERE A.ENRICHEDTITLE_ID = B.ID
  AND B.PUBLISHER_ID       = C.ID
  AND (B.ISBN              = D.ISBN
  OR B.ISBN10              = D.ISBN)
  AND A.supplierwer_id       IS NULL
  --AND A.po_number IS NULL
  and d.key_id=14
  
  SELECT 'update  set isbn='||isbn||' where isbn='||isbn10||' and key_id=14;' FROM enrichedtitles WHERE ID IN (
  SELECT COUNT(*) FROM enrichedtitles WHERE ID IN (
  SELECT enrichedtitle_id FROM procurementitems WHERE po_number IS NULL)
  and isbn in (select isbn from corelist where key_id=14)
  
  