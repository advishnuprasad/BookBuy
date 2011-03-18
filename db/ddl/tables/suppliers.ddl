CREATE TABLE "BOOKBUY"."SUPPLIERS"
  (
    "ID"           NUMBER NOT NULL ENABLE,
    "NAME"         VARCHAR2(100 BYTE),
    "CONTACT"      VARCHAR2(100 BYTE),
    "PHONE"        VARCHAR2(100 BYTE),
    "CITY"         VARCHAR2(100 BYTE),
    "TYPE"         NUMBER,
    "DISCOUNT"     NUMBER,
    "CREDITPERIOD" NUMBER
  );
