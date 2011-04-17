--------------------------------------------------------
--  DDL for Sequence BOOKRECEIPTS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "BOOKRECEIPTS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 NOCACHE NOORDER NOCYCLE ;
 
--------------------------------------------------------
--  DDL for Sequence INVOICES_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "INVOICES_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 NOCACHE NOORDER NOCYCLE ;
 
--------------------------------------------------------
--  DDL for Sequence TITLERECEIPTS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "TITLERECEIPTS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 NOCACHE NOORDER NOCYCLE ;
 
--------------------------------------------------------
--  DDL for Table BOOKRECEIPTS
--------------------------------------------------------

  CREATE TABLE "BOOKRECEIPTS" 
   (	"ID" NUMBER(38,0), 
	"BOOK_NO" VARCHAR2(255 CHAR), 
	"PO_NO" VARCHAR2(255 CHAR), 
	"INVOICE_NO" VARCHAR2(255 CHAR), 
	"ISBN" VARCHAR2(255 CHAR), 
	"TITLE_ID" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE
   ) ;
 
--------------------------------------------------------
--  Constraints for Table BOOKRECEIPTS
--------------------------------------------------------

  ALTER TABLE "BOOKRECEIPTS" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "BOOKRECEIPTS" ADD PRIMARY KEY ("ID") ENABLE;
 
--------------------------------------------------------
--  DDL for Table INVOICES
--------------------------------------------------------

  CREATE TABLE "INVOICES" 
   (	"ID" NUMBER(38,0), 
	"INVOICE_NO" VARCHAR2(255 CHAR), 
	"PO_ID" NUMBER(38,0), 
	"DATE_OF_RECEIPT" DATE, 
	"QUANTITY" NUMBER(38,0), 
	"AMOUNT" NUMBER, 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE, 
	"BOXES_CNT" NUMBER(38,0)
   ) ;
 
--------------------------------------------------------
--  Constraints for Table INVOICES
--------------------------------------------------------

  ALTER TABLE "INVOICES" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "INVOICES" ADD PRIMARY KEY ("ID") ENABLE;
 

alter table "PROCUREMENTITEMS" drop column "BOOK_NUMBER";

--------------------------------------------------------
--  DDL for Table TITLERECEIPTS
--------------------------------------------------------

  CREATE TABLE "TITLERECEIPTS" 
   (	"ID" NUMBER(38,0), 
	"PO_NO" VARCHAR2(255 CHAR), 
	"INVOICE_NO" VARCHAR2(255 CHAR), 
	"ISBN" VARCHAR2(255 CHAR), 
	"BOX_NO" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE
   ) ;
 
--------------------------------------------------------
--  Constraints for Table TITLERECEIPTS
--------------------------------------------------------

  ALTER TABLE "TITLERECEIPTS" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "TITLERECEIPTS" ADD PRIMARY KEY ("ID") ENABLE;
