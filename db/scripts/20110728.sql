--------------------------------------------------------
--  DDL for Sequence DISTRIBUTIONS_SEQ
--------------------------------------------------------

   CREATE SEQUENCE  "DISTRIBUTIONS_SEQ"  MINVALUE 1 MAXVALUE 999999999999999999999999999 INCREMENT BY 1 START WITH 10000 CACHE 20 NOORDER  NOCYCLE ;
 
--------------------------------------------------------
--  DDL for Table DISTRIBUTIONS
--------------------------------------------------------

  CREATE TABLE "DISTRIBUTIONS" 
   (	"ID" NUMBER(38,0), 
	"PROCUREMENTITEM_ID" NUMBER(38,0), 
	"BRANCH_ID" NUMBER(38,0), 
	"QUANTITY" NUMBER(38,0), 
	"PROCURED_CNT" NUMBER(38,0), 
	"CREATED_BY" NUMBER(38,0), 
	"MODIFIED_BY" NUMBER(38,0), 
	"CREATED_AT" DATE, 
	"UPDATED_AT" DATE
   ) ;
 
--------------------------------------------------------
--  Constraints for Table DISTRIBUTIONS
--------------------------------------------------------

  ALTER TABLE "DISTRIBUTIONS" MODIFY ("ID" NOT NULL ENABLE);
 
  ALTER TABLE "DISTRIBUTIONS" ADD PRIMARY KEY ("ID") ENABLE;
 
  ALTER TABLE "PROCUREMENTS" ADD ( "KIND" VARCHAR2(1020) );
  
