CREATE TYPE PERSON_TY AS OBJECT
    ( first_name     VARCHAR2(20),
      last_name      VARCHAR2(20),
      date_of_birth  DATE
    ) ;
/


CREATE TYPE DRIVER_TY AS OBJECT
    ( person          PERSON_TY,
      Drivers_License_ID  VARCHAR2(20)
    ) ;
/


CREATE TYPE OWNER_TY AS OBJECT
    ( person          PERSON_TY,
      Date_Purchased  DATE,
      Date_Sold       DATE
    ) ;
/


create or replace type OWNERS_VA as varray(3) of OWNER_TY;


CREATE OR REPLACE TYPE DRIVERS_TY AS OBJECT
    ( driver       DRIVER_TY,
      date_driven  DATE
    ) ;
/

create or replace type DRIVERS_NT as table of DRIVERS_TY;

create table AUTOMOBILE(
    vehicle_identification_number   NUMBER(10) Primary key,
    owners                          OWNERS_VA,
    drivers                         DRIVERS_NT)
nested table drivers store as DRIVERS_NT_TAB;



insert into AUTOMOBILE(vehicle_identification_number, owners, drivers)  
values(
    101,
    OWNERS_VA(
        OWNER_TY(PERSON_TY('Lance', 'Smalltalk', null), to_date('01/29/2016', 'MM/DD/YYYY'), null)
    ),
    DRIVERS_NT(
        DRIVERS_TY(DRIVER_TY(PERSON_TY('Erin','Smalltalk', to_date('05/23/1965', 'MM/DD/YYYY')), 'MA101'), to_date('03/01/2018', 'MM/DD/YYYY')),
        DRIVERS_TY(DRIVER_TY(PERSON_TY('Joe','Smalltalk', to_date('10/07/1982', 'MM/DD/YYYY')), 'MA204'), to_date('03/15/2018', 'MM/DD/YYYY'))
    )
);


insert into AUTOMOBILE(vehicle_identification_number, owners, drivers)  
values(
    102,
    OWNERS_VA(
        OWNER_TY(PERSON_TY('George', 'Stephanopolis', null), to_date('7/15/2014', 'MM/DD/YYYY'), to_date('6/17/2016', 'MM/DD/YYYY')),
        OWNER_TY(PERSON_TY('Max', 'Lucids', null), to_date('6/18/2016', 'MM/DD/YYYY'), null)
    ),
    DRIVERS_NT(
        DRIVERS_TY(DRIVER_TY(PERSON_TY('Julie','Goldstein', to_date('7/19/1977', 'MM/DD/YYYY')), 'MA506'), to_date('1/5/2016', 'MM/DD/YYYY')),
        DRIVERS_TY(DRIVER_TY(PERSON_TY('Max','Lucids', to_date('2/12/1987', 'MM/DD/YYYY')), 'MA706'), to_date('3/5/2018', 'MM/DD/YYYY'))
    )
);



select D.driver.person.first_name, D.driver.person.last_name, A.vehicle_identification_number, D.date_driven from AUTOMOBILE A, TABLE(A.drivers) D;

select O.person.first_name, O.person.last_name, A.vehicle_identification_number, O.date_purchased, O.date_sold from AUTOMOBILE A, TABLE(A.owners) O; 

