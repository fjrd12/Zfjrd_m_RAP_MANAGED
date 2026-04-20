CLASS lhc_booking DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS earlynumbering_cba_Booking_sup FOR NUMBERING
      IMPORTING entities FOR CREATE Booking\_Booking_supl.
*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR Booking RESULT result.
*
*    METHODS acceptTravel FOR MODIFY
*      IMPORTING keys FOR ACTION Booking~acceptTravel RESULT result.
*
*    METHODS copyTravel FOR MODIFY
*      IMPORTING keys FOR ACTION Booking~copyTravel.

    METHODS recalcTotPrice FOR MODIFY
      IMPORTING keys FOR ACTION Booking~recalcTotPrice.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Booking RESULT result.
    METHODS validatecustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validatecustomer.
    METHODS validateconnection FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validateconnection.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validatecurrencycode.

    METHODS validateflightprice FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validateflightprice.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR booking~validatestatus.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR booking~calculatetotalprice.

*    METHODS rejectTravel FOR MODIFY
*      IMPORTING keys FOR ACTION Booking~rejectTravel RESULT result.

ENDCLASS.

CLASS lhc_booking IMPLEMENTATION.

  METHOD earlynumbering_cba_Booking_sup.

    DATA: lv_max_booking_supplid TYPE /dmo/booking_supplement_id.

    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
        ENTITY Booking BY \_Booking_Supl
        FROM CORRESPONDING #(  entities )
        LINK DATA(booking_supplements).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_bookings>)
                               GROUP BY <ls_group_bookings>-%tky.

*         Get the maximum Booking id from database
      lv_max_booking_supplid  = REDUCE #( INIT lv_max = CONV /dmo/booking_supplement_id(  '0' )
                                 FOR ls_link IN booking_supplements USING KEY entity
                                     WHERE ( source-TravelId = <ls_group_bookings>-TravelId
                                         AND source-BookingId = <ls_group_bookings>-BookingId )
                                 NEXT lv_max = COND /dmo/booking_supplement_id(  WHEN lv_max < ls_link-target-BookingSupplementId
                                                                                 THEN ls_link-target-BookingSupplementId
                                                                                 ELSE lv_max )

                               ).
*         and from that number lookup in the currnt entities to obtain new max number
      lv_max_booking_supplid  = REDUCE #( INIT lv_max =  lv_max_booking_supplid
                                 FOR  ls_entity IN entities USING KEY entity
                                      WHERE ( TravelId  = <ls_group_bookings>-TravelId
                                          AND BookingId = <ls_group_bookings>-BookingId )
                                     FOR ls_booking_suppl IN ls_entity-%target
                                     NEXT lv_max = COND /dmo/booking_supplement_id(  WHEN lv_max < ls_booking_suppl-BookingSupplementId
                                                                                     THEN ls_booking_suppl-BookingSupplementId
                                                                                     ELSE lv_max )
                               ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                  USING KEY entity
                  WHERE TravelId  = <ls_group_bookings>-TravelId AND
                        BookingId = <ls_group_bookings>-BookingId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_suppl>).

          APPEND CORRESPONDING #(  <ls_booking_suppl> ) TO mapped-bookingsuppl
                 ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).

          IF <ls_booking_suppl>-BookingSupplementId IS INITIAL.
            lv_max_booking_supplid += 10.
            <ls_new_map_book>-BookingSupplementId = lv_max_booking_supplid.
          ENDIF.

        ENDLOOP.


      ENDLOOP.

    ENDLOOP.

  ENDMETHOD.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.

*  METHOD acceptTravel.
*  ENDMETHOD.
*
*  METHOD copyTravel.

*    DATA: it_travel        TYPE TABLE FOR CREATE z_I_travel__m,
*          it_booking       TYPE TABLE FOR CREATE z_I_travel__m\_Booking,
*          it_booking_suppl TYPE TABLE FOR CREATE z_i_booking_m\_Booking_Supl.
*
**    The data is selected
*    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = space.
*    ASSERT <ls_without_cid> IS INITIAL.
*
**    The travel entity is readed
*    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
*        ENTITY Travel
*                ALL FIELDS WITH CORRESPONDING #( keys )
*                RESULT DATA(lt_output_travel)
*                FAILED DATA(lt_failed).
*
**With the travel keys go for the boking keys
*    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
*        ENTITY Travel BY \_Booking
*                ALL FIELDS WITH CORRESPONDING #( lt_output_travel )
*                RESULT DATA(lt_output_booking)
*                FAILED DATA(lt_failed_booking).
*
**Then with the path of the booking goes to the booking supplement
*    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
*            ENTITY Booking BY \_Booking_Supl
*                    ALL FIELDS WITH CORRESPONDING #( lt_output_booking )
*                    RESULT DATA(lt_output_bookingsupl)
*                    FAILED DATA(lt_failed_bookingsupl).
*
**Iterrte for all the travels
*    LOOP AT lt_output_travel ASSIGNING FIELD-SYMBOL(<ls_travel_r>).
*
**      APPEND INITIAL LINE TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
**      <ls_travel>-%cid = keys[ key entity TravelId = <ls_travel_r>-%key-TravelId ]-%cid.
**      <ls-travel>-%data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ).
*
**Generate the %CID and move the data to the entity
*      APPEND VALUE #( %cid  = keys[ KEY entity TravelId = <ls_travel_r>-%key-TravelId ]-%cid
*                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ) )
*           TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*
**Initialie some variables.
*      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date( ).
*      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.
*      <ls_travel>-OverallStatus = 'O'.
*
**Create the rference to the bookings
*      APPEND VALUE #(  %cid_ref = <ls_travel>-%cid )
*         TO it_booking ASSIGNING FIELD-SYMBOL(<it_booking>).
*
**Iterate for the bookings
*      LOOP AT lt_output_booking ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
*                             USING KEY entity
*                             WHERE TravelId = <ls_travel_r>-TravelId.
*
**Initialize the CID for the bookings
*        APPEND VALUE #( %cid  = <ls_travel>-%cid && <ls_booking_r>-BookingId
*                        %data = CORRESPONDING #(  <ls_booking_r> EXCEPT TravelId ) )
*              TO <it_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).
*
**Initialize status
*        <ls_booking_n>-BookingStatus = 'N'.
*
**Create instance of reference for the booking supplement
*        APPEND VALUE #(  %cid_ref = <ls_booking_n>-%cid )
*         TO it_booking_suppl ASSIGNING FIELD-SYMBOL(<ls_booking_suppl>).
*
**Iterate for all the booking supplement
*        LOOP AT lt_output_bookingsupl ASSIGNING FIELD-SYMBOL(<ls_booksuppl_r>)
*                              WHERE TravelId  = <ls_travel_r>-TravelId AND
*                                    BookingId = <ls_booking_r>-BookingId.
*
**Finally store the third level dependence that the booking supplement
*          APPEND VALUE #( %cid  = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_booksuppl_r>-BookingSupplementId
*                        %data = CORRESPONDING #(  <ls_booksuppl_r> EXCEPT TravelId ) )
*              TO <ls_booking_suppl>-%target ASSIGNING FIELD-SYMBOL(<ls_bookingsuppl_n>).
*
*        ENDLOOP.
*
*
*
*      ENDLOOP.
*
*    ENDLOOP.
*
**Finally the entities will be created
*
*    MODIFY ENTITIES OF z_i_travel__m IN LOCAL MODE
*        ENTITY Travel
*         CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
*         WITH it_travel
*        ENTITY Travel
*        CREATE BY \_Booking
*        FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
*        WITH it_booking
*        ENTITY Booking
*        CREATE BY \_Booking_Supl
*        FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
*        WITH it_booking_suppl
*        MAPPED DATA(it_mapped).
*
*    mapped-travel = it_mapped-travel.

*  ENDMETHOD.

  METHOD recalcTotPrice.
  ENDMETHOD.

*  METHOD rejectTravel.
*  ENDMETHOD.

  METHOD get_instance_features.


    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
    ENTITY Travel BY \_Booking
    FIELDS (  TravelId BookingStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_booking).

    result = VALUE #( FOR ls_booking IN lt_booking
                        ( %tky = ls_booking-%tky
*                          %features-%action-
*                          -acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
*                                                                   THEN if_abap_behv=>fc-o-disabled
*                                                                   ELSE if_abap_behv=>fc-o-enabled )
*
*                          %features-%action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
*                                                                   THEN if_abap_behv=>fc-o-disabled
*                                                                   ELSE if_abap_behv=>fc-o-enabled )
*
                          %features-%assoc-_Booking_Supl = COND #( WHEN ls_booking-BookingStatus = 'X'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )

                        )
                    ).


  ENDMETHOD.

  METHOD validateCustomer.


    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
    ENTITY Travel
    FIELDS (  TravelId CustomerId )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

*/DMO/I_Customer
    DATA: lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.
    lt_cust = CORRESPONDING #(  lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).

    DELETE lt_cust WHERE customer_id IS INITIAL.

    IF lt_cust IS NOT INITIAL.

      SELECT
        FROM /dmo/customer
        FIELDS customer_id
        FOR ALL ENTRIES IN @lt_cust
        WHERE customer_id = @lt_cust-customer_id
        INTO TABLE @DATA(lt_customer_db).

      IF sy-subrc IS INITIAL.
      ENDIF.

      LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

        IF <ls_travel> IS INITIAL OR NOT line_exists(  lt_customer_db[ customer_id = <ls_travel>-CustomerId ] ).

          APPEND VALUE #( %tky = <ls_travel>-%tky )
              TO failed-travel.

          APPEND VALUE #( %tky    = <ls_travel>-%tky
                          %msg    = NEW  /dmo/cm_flight_messages(
                                     textid         = /dmo/cm_flight_messages=>customer_unkown
                                     customer_id    =  <ls_travel>-CustomerId
                                     severity       = if_abap_behv_message=>severity-error
                                    )
                          %element-CustomerId = if_abap_behv=>mk-on
                        )
              TO reported-travel.

        ENDIF.

      ENDLOOP.

    ENDIF.


  ENDMETHOD.


  METHOD validateConnection.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateFlightPrice.
  ENDMETHOD.

  METHOD validateStatus.
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
