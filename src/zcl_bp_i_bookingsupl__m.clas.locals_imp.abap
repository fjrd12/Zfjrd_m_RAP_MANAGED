CLASS lhc_bookingsuppl DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validateCurrencyCode FOR VALIDATE ON SAVE
      IMPORTING keys FOR BookingSuppl~validateCurrencyCode.

    METHODS validatePrice FOR VALIDATE ON SAVE
      IMPORTING keys FOR BookingSuppl~validatePrice.

    METHODS validateSuplement FOR VALIDATE ON SAVE
      IMPORTING keys FOR BookingSuppl~validateSuplement.
    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR BookingSuppl~calculateTotalPrice.

ENDCLASS.

CLASS lhc_bookingsuppl IMPLEMENTATION.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validatePrice.
  ENDMETHOD.

  METHOD validateSuplement.
  ENDMETHOD.

  METHOD calculateTotalPrice.

    DATA: it_travel TYPE STANDARD TABLE OF z_I_travel__m WITH UNIQUE HASHED KEY key COMPONENTS TravelId.

    it_travel = CORRESPONDING #( keys DISCARDING DUPLICATES MAPPING TravelID = TravelId ).

    MODIFY ENTITIES OF z_i_travel__m IN LOCAL MODE
      ENTITY Travel
      EXECUTE recalcTotPrice
      FROM CORRESPONDING #( it_travel ).
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
