CLASS zfill_tables DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zfill_tables IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA lt_source TYPE STANDARD TABLE OF  /dmo/booking_m.
    DATA lt_target TYPE STANDARD TABLE OF zbooking__m.
    DATA wa_dest TYPE zbooking__m.

    DELETE FROM zbooking__m.

    SELECT *
      FROM /dmo/booking_m
      INTO TABLE @lt_source.

    LOOP AT lt_source INTO DATA(wa_source).
      MOVE-CORRESPONDING wa_source TO wa_dest.
      APPEND wa_dest TO lt_target.
    ENDLOOP.

    INSERT zbooking__m FROM TABLE @lt_target.


    DATA lt_source1 TYPE STANDARD TABLE OF  /dmo/travel_m .
    DATA lt_target1 TYPE STANDARD TABLE OF ztravel__m.
    DATA wa_dest1 TYPE ztravel__m.

    DELETE FROM ztravel__m.

    SELECT *
      FROM /dmo/travel_m
      INTO TABLE @lt_source1.

    LOOP AT lt_source1 INTO DATA(wa_source1).
      MOVE-CORRESPONDING wa_source1 TO wa_dest1.
      APPEND wa_dest1 TO lt_target1.
    ENDLOOP.

    INSERT ztravel__m FROM TABLE @lt_target1.

    DATA lt_source2 TYPE STANDARD TABLE OF  /dmo/booksuppl_m .
    DATA lt_target2 TYPE STANDARD TABLE OF zbooksup_m.
    DATA wa_dest2 TYPE zbooksup_m.

    DELETE FROM zbooksup_m.

    SELECT *
      FROM /dmo/booksuppl_m
      INTO TABLE @lt_source2.

    LOOP AT lt_source2 INTO DATA(wa_source2).
      MOVE-CORRESPONDING wa_source2 TO wa_dest2.
      APPEND wa_dest2 TO lt_target2.
    ENDLOOP.

    INSERT zbooksup_m FROM TABLE @lt_target2.
  ENDMETHOD.
ENDCLASS.
