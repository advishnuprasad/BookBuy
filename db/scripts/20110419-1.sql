alter table "INVOICES" add ( "DATE_OF_INVOICE" DATE );

alter table INVOICES drop constraint INVOICES_UK1;

alter table "PROCUREMENTITEMS" add ( "PROCURED_CNT" NUMBER (38,0) default 0 );

alter table "TITLERECEIPTS" add ( "BOOK_NO" VARCHAR2(1020) );

--------------------------------------------------------
--  DDL for View PO_VIEW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "PO_VIEW" ("PONUMBER", "WORKLIST_ID", "TITLE", "ISBN", "AUTHOR", "PUBLISHERNAME", "SUPPLIER", "QUANTITY", "LISTPRICE", "CURRENCY", "CONV_RATE", "INRPRICE", "DISCOUNT", "COSTPRICE", "TITLE_ID") AS 
  SELECT a.po_number,
    b.worklist_id,
    d.title,
    d.isbn,
    d.author,
    e.publishername,
    f.name,
    A.quantity,
    d.listprice,
    d.currency,
    DECODE(d.currency,'USD',47.90,'GBP',77.50,'EUR',65.70,1),
    d.listprice * DECODE(d.currency,'USD',47.90,'GBP',77.50,'EUR',65.70,1),
    g.discount,
    ROUND(g.discount * d.listprice * DECODE(d.currency,'USD',47.90,'GBP',77.50,'EUR',65.70,1)/100,2),
    d.title_id
  FROM procurementitems A,
    workitems b,
    enrichedtitles d,
    publishers e,
    suppliers f,
    supplierdiscounts g
  WHERE A.ID             = b.ref_id
  AND A.enrichedtitle_id = d.ID
  AND d.publisher_id     = e.ID
  AND a.po_number       IS NOT NULL
  AND A.supplier_id      = f.ID
  AND g.supplier_id      = f.id
  AND g.publisher_id     = e.ID
  ORDER BY worklist_id;
