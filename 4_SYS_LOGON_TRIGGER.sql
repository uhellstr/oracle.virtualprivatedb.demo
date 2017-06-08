CREATE OR REPLACE TRIGGER set_security_context
AFTER LOGON ON DATABASE
BEGIN
  VPD_TEST.set_vpd_session_context_pkg.set_context;
END;
/
SHOW ERRORS

create view vpd_demo.v_company as select * from vpd_test.company;
create view vpd_demo.v_customer as select * from vpd_test.customer;
