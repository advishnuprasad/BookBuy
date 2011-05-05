BEGIN
  EXPAND_NEWARRIVALS_ITEMS(9);
END;

SELECT * FROM newarrivals_expanded
SELECT count(*) FROM CORELIST WHERE key_id = 4
select count(*) from newarrivals_expanded where key_id = 9

BEGIN
  DATA_PULL.PR_PULL_CORELIST_ITEMS(5);
END;

BEGIN
  DATA_PULL.PR_PULL_NEWARRIVAL_ITEMS(9);
END;

SELECT COUNT(*) FROM PROCUREMENTITEMS --  41329 / 41357
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

SELECT COUNT(*) FROM enrichedtitles where nvl(enriched,'N') = 'N'

BEGIN
  PULL_SUPPLIER(512);
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
  GENERATE_POS('NENT', 9);
END;

SELECT count(*) FROM pos -- 508 / 542 / 569 / 733 / 759
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
    SELECT CODE FROM pos where to_char(created_at,'DD-MON-RR') = '04-MAY-11' and code like 'NENT%' and id > 12117
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