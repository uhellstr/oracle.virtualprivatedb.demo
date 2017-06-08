-- Setup security package for customer and company tables


begin

dbms_rls.drop_policy (
   object_schema  => 'VPD_TEST',
   object_name => 'COMPANY',
   policy_name  => 'VPD_TEST_SELECT_SECURITY');

dbms_rls.drop_policy (
   object_schema  => 'VPD_TEST',
   object_name => 'CUSTOMER',
   policy_name  => 'VPD_TEST_SELECT_SECURITY');
   
end;
/

drop package vpd_test.vpd_security_pkg;
drop public synonym vpd_security_pkg;

create or replace package vpd_test.vpd_security_pkg as

  function vpd_test_select_security(owner varchar2, objname varchar2)
    return varchar2;

end vpd_security_pkg;
/

create or replace package body vpd_test.vpd_security_pkg is


  function vpd_test_select_security(owner varchar2, objname varchar2) return varchar2 is

    predicate VARCHAR2(2000);

  begin

    predicate := '1=2';

    if (sys_context('USERENV','SESSION_USER') = 'VPD_TEST') then
      predicate := NULL;
    else
      predicate := 'company_id = SYS_CONTEXT(''VPD_USER_CONTEXT'',''USER_ID'')';
    end if;

    return predicate;
    
  end vpd_test_select_security;

end vpd_security_pkg;
/
show errors


grant execute on vpd_test.vpd_security_pkg to public;
create public synonym vpd_security_pkg for vpd_test.vpd_security_pkg;


-- Add policy for company and customer tables on select level..

begin

  dbms_rls.add_policy('VPD_TEST', 'CUSTOMER', 'VPD_TEST_SELECT_SECURITY',
                      'VPD_TEST', 'VPD_SECURITY_PKG.VPD_TEST_SELECT_SECURITY','SELECT');
  dbms_rls.add_policy('VPD_TEST','COMPANY', 'VPD_TEST_SELECT_SECURITY',
                       'VPD_TEST','VPD_SECURITY_PKG.VPD_TEST_SELECT_SECURITY','SELECT');
end;
/
