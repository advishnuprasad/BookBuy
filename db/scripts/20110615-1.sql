alter table "BOOKRECEIPTS" add ( "CREATED_BY" NUMBER (38,0) );
alter table "BOOKRECEIPTS" add ( "MODIFIED_BY" NUMBER (38,0) );

alter table "CRATES" add ( "CREATED_BY" NUMBER (38,0) );
alter table "CRATES" add ( "MODIFIED_BY" NUMBER (38,0) );

alter table "INVOICES" add ( "CREATED_BY" NUMBER (38,0) );
alter table "INVOICES" add ( "MODIFIED_BY" NUMBER (38,0) );

alter table "TITLERECEIPTS" add ( "CREATED_BY" NUMBER (38,0) );