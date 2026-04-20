CLASS lsc_z_i_travel__m DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_z_i_travel__m IMPLEMENTATION.

  METHOD save_modified.

    DATA  lt_travel_log TYPE STANDARD TABLE OF zlog_travel_m1.
    DATA  lt_travel_log_C TYPE STANDARD TABLE OF zlog_travel_m1.
    DATA  lt_travel_log_U TYPE STANDARD TABLE OF zlog_travel_m1.
    DATA  lt_travel_log_d TYPE STANDARD TABLE OF zlog_travel_m1.

    IF create-travel IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( create-travel ).

      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_log>).

        <ls_travel_log>-changing_operation = 'CREATE'.
        GET TIME STAMP FIELD <ls_travel_log>-created_at.

        READ TABLE create-travel ASSIGNING FIELD-SYMBOL(<ls_travel>)
                        WITH TABLE KEY entity COMPONENTS TravelId = <ls_travel_log>-travelid.

        IF sy-subrc IS INITIAL.

          IF <ls_travel>-%control-BookingFee = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_field_name = 'Booking Fee'.
            <ls_travel_log>-changed_value = <ls_travel>-BookingFee.
            TRY.
                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            APPEND <ls_travel_log> TO lt_travel_log_c.
          ENDIF.

          IF <ls_travel>-%control-OverallStatus = cl_abap_behv=>flag_changed.
            <ls_travel_log>-changed_field_name = 'OverAll Status'.
            <ls_travel_log>-changed_value = <ls_travel>-OverallStatus.
            TRY.
                <ls_travel_log>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
              CATCH cx_uuid_error.
                "handle exception
            ENDTRY.
            APPEND <ls_travel_log> TO lt_travel_log_c.
          ENDIF.

        ENDIF.


      ENDLOOP.

      INSERT zlog_travel_m1 FROM TABLE @lt_travel_log_c.

    ENDIF.

    IF update-travel IS NOT INITIAL.
      lt_travel_log = CORRESPONDING #( update-travel ).

      LOOP AT update-travel ASSIGNING FIELD-SYMBOL(<ls_travel_log_update>).

        ASSIGN lt_travel_log[ travelid = <ls_travel_log_update>-travelid ] TO FIELD-SYMBOL(<ls_log_u>).
        GET TIME STAMP FIELD <ls_log_u>-created_at.
        <ls_log_u>-changing_operation = 'UPDATE'.


        IF <ls_travel_log_update>-%control-CustomerId  = cl_abap_behv=>flag_changed.
          <ls_log_u>-changed_field_name = 'Customer ID'.
          <ls_log_u>-changed_value = <ls_travel_log_update>-CustomerId.
          TRY.
              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.
              "handle exception
          ENDTRY.
          APPEND <ls_log_u> TO lt_travel_log_u.
        ENDIF.

        IF <ls_travel_log_update>-%control-Description  = cl_abap_behv=>flag_changed.
          <ls_log_u>-changed_field_name = 'Description'.
          <ls_log_u>-changed_value = <ls_travel_log_update>-Description.
          TRY.
              <ls_log_u>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
            CATCH cx_uuid_error.
              "handle exception
          ENDTRY.
          APPEND <ls_log_u> TO lt_travel_log_u.
        ENDIF.


      ENDLOOP.
      INSERT zlog_travel_m1 FROM TABLE @lt_travel_log_u.

    ENDIF.

    IF delete-travel IS NOT INITIAL.

      lt_travel_log = CORRESPONDING #( delete-travel ).
      LOOP AT lt_travel_log ASSIGNING FIELD-SYMBOL(<ls_travel_delete>).
        GET TIME STAMP FIELD <ls_travel_delete>-created_at.
        <ls_travel_delete>-changing_operation = 'DELETE'.
        TRY.
            <ls_travel_delete>-change_id = cl_system_uuid=>create_uuid_x16_static(  ).
          CATCH cx_uuid_error.
            "handle exception
        ENDTRY.
        APPEND <ls_travel_delete> TO lt_travel_log_d.
      ENDLOOP.

      INSERT zlog_travel_m1 FROM TABLE @lt_travel_log_d.
    ENDIF.


************************************************************************************************
********************************************UNMANAGED SAVE BUKSUPL******************************
************************************************************************************************
    DATA: lt_book_suppl TYPE STANDARD TABLE OF zbooksup_m.

*    IF create-travel IS NOT INITIAL.
*      lt_book_suppl = VALUE #( FOR ls_booking_supl IN create-bookingsuppl (
*                                    travel_id = ls_booking_supl-TravelId
*                                    booking_id = ls_booking_supl-BookingId
*                                    booking_supplement_id = ls_booking_supl-BookingSupplementId
*                                    supplement_id = ls_booking_supl-SupplementId
*                                    price = ls_booking_supl-Price
*                                    currency_code = ls_booking_supl-CurrencyCode
*                                    last_changed_at = ls_booking_supl-LastChangedAt ) ).
*
*      INSERT zbooksup_m FROM TABLE @lt_book_suppl.
*    ENDIF.
*
*    IF update-travel IS NOT INITIAL.
*      lt_book_suppl = VALUE #( FOR ls_booking_supl IN create-bookingsuppl (
*                              travel_id = ls_booking_supl-TravelId
*                              booking_id = ls_booking_supl-BookingId
*                              booking_supplement_id = ls_booking_supl-BookingSupplementId
*                              supplement_id = ls_booking_supl-SupplementId
*                              price = ls_booking_supl-Price
*                              currency_code = ls_booking_supl-CurrencyCode
*                              last_changed_at = ls_booking_supl-LastChangedAt ) ).
*
*      UPDATE zbooksup_m FROM TABLE @lt_book_suppl.
*    ENDIF.
*
*    IF delete-travel IS NOT INITIAL.
*      lt_book_suppl = VALUE #( FOR ls_booking_supld IN create-bookingsuppl (
*                              travel_id = ls_booking_supld-TravelId
*                              booking_id = ls_booking_supld-BookingId
*                              booking_supplement_id = ls_booking_supld-BookingSupplementId
*                              supplement_id = ls_booking_supld-SupplementId
*                             ) ).
*
*      DELETE zbooksup_m FROM TABLE @lt_book_suppl.
*
*    ENDIF.

  ENDMETHOD.



ENDCLASS.

CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations
    FOR INSTANCE AUTHORIZATION
      IMPORTING keys
      REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Travel RESULT result.
    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.

    METHODS copyTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~copyTravel.

    METHODS rejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~rejectTravel RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.
    METHODS validatebookingfee FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatebookingfee.

    METHODS validatecurrencycode FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatecurrencycode.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatedates.

    METHODS validatestatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR travel~validatestatus.
    METHODS calculatetotalprice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR travel~calculatetotalprice.
    METHODS recalctotprice FOR MODIFY
      IMPORTING keys FOR ACTION travel~recalctotprice.
    METHODS recaltotalprice FOR MODIFY
      IMPORTING keys FOR ACTION travel~recaltotalprice.

    METHODS earlynumbering_create
      FOR NUMBERING
      IMPORTING entities
                  FOR CREATE Travel.
    METHODS earlynumbering_cba_booking
      FOR NUMBERING
      IMPORTING entities
                  FOR CREATE Travel\_Booking.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA(lt_entities) = entities.
    DELETE lt_entities WHERE TravelId IS NOT INITIAL.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
*        ignore_buffer     =
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( lt_entities ) )
*        subobject         =
*        toyear            =
          IMPORTING
            number            = DATA(lv_latestnum)
            returncode        = DATA(lv_code)
            returned_quantity = DATA(lv_qty)
        ).
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges INTO DATA(lo_error) .
        LOOP AT lt_entities INTO DATA(ls_entities).
          APPEND  VALUE #(  %cid = ls_entities-%cid
                            %key = ls_entities-%key )
              TO failed-travel.
          APPEND  VALUE #(  %cid = ls_entities-%cid
                  %key = ls_entities-%key
                  %msg = lo_error )
              TO reported-travel.

        ENDLOOP.
        EXIT.
    ENDTRY.

    ASSERT lv_qty = lines( lt_entities ).
    DATA: lt_travel_mapped TYPE TABLE FOR MAPPED EARLY z_i_travel__m,
          ls_travel_mapped LIKE LINE OF lt_travel_mapped.

    DATA(lv_curr_num) = CONV i( lv_latestnum - lv_qty ).

    LOOP AT lt_entities INTO ls_entities.
      lv_curr_num = lv_curr_num + 1.
*      ls_travel_mapped = VALUE #(  %cid = ls_entities-%cid
*                                   TravelId = lv_curr_num ).
*      APPEND  ls_travel_mapped TO mapped-z_i_travel__m.
      APPEND  VALUE #(  %cid = ls_entities-%cid
                        TravelId = lv_curr_num )
                TO mapped-travel.

    ENDLOOP.


  ENDMETHOD.

  METHOD earlynumbering_cba_booking.
    DATA: lv_max_booking TYPE /dmo/booking_id.

    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
        ENTITY Travel BY \_Booking
        FROM CORRESPONDING #(  entities )
        LINK DATA(lt_link_data).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_group_entity>)
                               GROUP BY <ls_group_entity>-TravelId.

*         Get the maximum Booking id from database
      lv_max_booking = REDUCE #( INIT lv_max = CONV /dmo/booking_id(  '0' )
                                 FOR ls_link IN lt_link_data USING KEY entity
                                     WHERE ( source-TravelId = <ls_group_entity>-TravelId )
                                 NEXT lv_max = COND /dmo/booking_id(  WHEN lv_max < ls_link-target-BookingId
                                                                      THEN ls_link-target-BookingId
                                                                      ELSE lv_max )

                               ).
*         and from that number lookup in the currnt entities to obtain new max number
      lv_max_booking = REDUCE #( INIT lv_max = lv_max_booking
                                 FOR  ls_entity IN entities USING KEY entity
                                      WHERE ( TravelId = <ls_group_entity>-TravelId )
                                     FOR ls_booking IN ls_entity-%target
                                     NEXT lv_max = COND /dmo/booking_id(  WHEN lv_max < ls_booking-BookingId
                                                                          THEN ls_booking-BookingId
                                                                          ELSE lv_max )
                               ).

      LOOP AT entities ASSIGNING FIELD-SYMBOL(<ls_entities>)
                  USING KEY entity
                  WHERE TravelId = <ls_group_entity>-TravelId.

        LOOP AT <ls_entities>-%target ASSIGNING FIELD-SYMBOL(<ls_booking>).
          APPEND CORRESPONDING #(  <ls_booking> ) TO mapped-booking
              ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).
          IF <ls_booking>-BookingId IS INITIAL.
            lv_max_booking += 10.
*            APPEND CORRESPONDING #(  <ls_booking> ) TO mapped-booking
*                ASSIGNING FIELD-SYMBOL(<ls_new_map_book>).
            <ls_new_map_book>-BookingId = lv_max_booking.
          ENDIF.

        ENDLOOP.


      ENDLOOP.

    ENDLOOP.


  ENDMETHOD.

  METHOD acceptTravel.
    MODIFY ENTITIES OF z_i_travel__m IN LOCAL MODE
        ENTITY Travel
            UPDATE FIELDS ( OverallStatus )
            WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                                OverallStatus = 'A' ) )
        REPORTED DATA(lt_travel).

    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
    ENTITY Travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #(  FOR ls_result IN lt_result (  %tky = ls_result-%tky
                                                   %param = ls_result ) ).

  ENDMETHOD.

  METHOD copyTravel.
    DATA: it_travel        TYPE TABLE FOR CREATE z_I_travel__m,
          it_booking       TYPE TABLE FOR CREATE z_I_travel__m\_Booking,
          it_booking_suppl TYPE TABLE FOR CREATE z_i_booking_m\_Booking_Supl.

*    The data is selected
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_without_cid>) WITH KEY %cid = ' '.
    ASSERT <ls_without_cid> IS NOT ASSIGNED.

*    The travel entity is readed
    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
        ENTITY Travel
                ALL FIELDS WITH CORRESPONDING #( keys )
                RESULT DATA(lt_output_travel)
                FAILED DATA(lt_failed).

*With the travel keys go for the boking keys
    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
        ENTITY Travel BY \_Booking
                ALL FIELDS WITH CORRESPONDING #( lt_output_travel )
                RESULT DATA(lt_output_booking)
                FAILED DATA(lt_failed_booking).

*Then with the path of the booking goes to the booking supplement
    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
            ENTITY Booking BY \_Booking_Supl
                    ALL FIELDS WITH CORRESPONDING #( lt_output_booking )
                    RESULT DATA(lt_output_bookingsupl)
                    FAILED DATA(lt_failed_bookingsupl).

*Iterate for all the travels
    LOOP AT lt_output_travel ASSIGNING FIELD-SYMBOL(<ls_travel_r>).

*      APPEND INITIAL LINE TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*      <ls_travel>-%cid = keys[ key entity TravelId = <ls_travel_r>-%key-TravelId ]-%cid.
*      <ls-travel>-%data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ).

*Generate the %CID and move the data to the entity
      APPEND VALUE #( %cid  = keys[ KEY entity TravelId = <ls_travel_r>-%key-TravelId ]-%cid
                      %data = CORRESPONDING #( <ls_travel_r> EXCEPT TravelId ) )
           TO it_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

*Initialie some variables.
      <ls_travel>-BeginDate = cl_abap_context_info=>get_system_date( ).
      <ls_travel>-EndDate = cl_abap_context_info=>get_system_date(  ) + 30.
      <ls_travel>-OverallStatus = 'O'.

*Create the rference to the bookings
      APPEND VALUE #(  %cid_ref = <ls_travel>-%cid )
         TO it_booking ASSIGNING FIELD-SYMBOL(<it_booking>).

*Iterate for the bookings
      LOOP AT lt_output_booking ASSIGNING FIELD-SYMBOL(<ls_booking_r>)
                             USING KEY entity
                             WHERE TravelId = <ls_travel_r>-TravelId.

*Initialize the CID for the bookings
        APPEND VALUE #( %cid  = <ls_travel>-%cid && <ls_booking_r>-BookingId
                        %data = CORRESPONDING #(  <ls_booking_r> EXCEPT TravelId ) )
              TO <it_booking>-%target ASSIGNING FIELD-SYMBOL(<ls_booking_n>).

*Initialize status
        <ls_booking_n>-BookingStatus = 'N'.

*Create instance of reference for the booking supplement
        APPEND VALUE #(  %cid_ref = <ls_booking_n>-%cid )
         TO it_booking_suppl ASSIGNING FIELD-SYMBOL(<ls_booking_suppl>).

*Iterate for all the booking supplement
        LOOP AT lt_output_bookingsupl ASSIGNING FIELD-SYMBOL(<ls_booksuppl_r>)
                              WHERE TravelId  = <ls_travel_r>-TravelId AND
                                    BookingId = <ls_booking_r>-BookingId.

*Finally store the third level dependence that the booking supplement
          APPEND VALUE #( %cid  = <ls_travel>-%cid && <ls_booking_r>-BookingId && <ls_booksuppl_r>-BookingSupplementId
                        %data = CORRESPONDING #(  <ls_booksuppl_r> EXCEPT TravelId ) )
              TO <ls_booking_suppl>-%target ASSIGNING FIELD-SYMBOL(<ls_bookingsuppl_n>).

        ENDLOOP.



      ENDLOOP.

    ENDLOOP.

*Finally the entities will be created

    MODIFY ENTITIES OF z_i_travel__m IN LOCAL MODE
        ENTITY Travel
         CREATE FIELDS ( AgencyId CustomerId BeginDate EndDate BookingFee TotalPrice CurrencyCode OverallStatus Description )
         WITH it_travel
        ENTITY Travel
        CREATE BY \_Booking
        FIELDS ( BookingId BookingDate CustomerId CarrierId ConnectionId FlightDate FlightPrice CurrencyCode BookingStatus )
        WITH it_booking
        ENTITY Booking
        CREATE BY \_Booking_Supl
        FIELDS ( BookingSupplementId SupplementId Price CurrencyCode )
        WITH it_booking_suppl
        MAPPED DATA(it_mapped).

    mapped-travel = it_mapped-travel.
  ENDMETHOD.

  METHOD rejectTravel.
*    Modif the entity
    MODIFY ENTITIES OF z_i_travel__m IN LOCAL MODE
      ENTITY Travel
          UPDATE FIELDS ( OverallStatus )
          WITH VALUE #( FOR ls_keys IN keys ( %tky = ls_keys-%tky
                                              OverallStatus = 'X' ) )
      REPORTED DATA(lt_travel).

*   Read the modified entity|
    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
    ENTITY Travel
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

*Return the data
    result = VALUE #(  FOR ls_result IN lt_result (  %tky = ls_result-%tky
                                                   %param = ls_result ) ).

  ENDMETHOD.

  METHOD get_instance_features.

    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
    ENTITY Travel
    FIELDS (  TravelId OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    result = VALUE #( FOR ls_travel IN lt_travel
                        ( %tky = ls_travel-%tky
                          %features-%action-acceptTravel = COND #( WHEN ls_travel-OverallStatus = 'A'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )

                          %features-%action-rejectTravel = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )

                          %features-%assoc-_Booking = COND #( WHEN ls_travel-OverallStatus = 'X'
                                                                   THEN if_abap_behv=>fc-o-disabled
                                                                   ELSE if_abap_behv=>fc-o-enabled )

                        )
                    ).

  ENDMETHOD.

  METHOD validateBookingFee.
  ENDMETHOD.

  METHOD validateCurrencyCode.
  ENDMETHOD.

  METHOD validateDates.

    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
    ENTITY Travel
    FIELDS ( BeginDate EndDate )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      IF <ls_travel>-BeginDate > <ls_travel>-EndDate.

        APPEND VALUE #( %tky = <ls_travel>-%tky ) TO failed-travel.

        APPEND VALUE #( %tky    = <ls_travel>-%tky
                        %msg    = NEW  /dmo/cm_flight_messages(
                                   textid         = /dmo/cm_flight_messages=>begin_date_bef_end_date
                                   severity       = if_abap_behv_message=>severity-error
                                   begin_date     = <ls_travel>-BeginDate
                                   end_date       = <ls_travel>-EndDate
                                   travel_id      = <ls_travel>-TravelId

                                  )
                        %element-BeginDate = if_abap_behv=>mk-on
                        %element-EndDate = if_abap_behv=>mk-on
                      )
            TO reported-travel.

      ELSEIF <ls_travel>-BeginDate < cl_abap_context_info=>get_system_date( ).

        APPEND VALUE #( %tky = <ls_travel>-%tky ) TO failed-travel.

        APPEND VALUE #( %tky    = <ls_travel>-%tky
                        %msg    = NEW  /dmo/cm_flight_messages(
                                   textid         = /dmo/cm_flight_messages=>begin_date_on_or_bef_sysdate
                                   severity       = if_abap_behv_message=>severity-error
                                   begin_date     = <ls_travel>-BeginDate
                                   end_date       = <ls_travel>-EndDate
                                   travel_id      = <ls_travel>-TravelId
                                  )
                        %element-BeginDate = if_abap_behv=>mk-on
                        %element-EndDate = if_abap_behv=>mk-on
                      )
            TO reported-travel.

      ENDIF.

    ENDLOOP.


**/DMO/I_Customer
*    DATA: lt_cust TYPE SORTED TABLE OF /dmo/customer WITH UNIQUE KEY customer_id.
*    lt_cust = CORRESPONDING #(  lt_travel DISCARDING DUPLICATES MAPPING customer_id = CustomerId ).
*
*    DELETE lt_cust WHERE customer_id IS INITIAL.
*
*    IF lt_cust IS NOT INITIAL.
*
*      SELECT
*        FROM /dmo/customer
*        FIELDS customer_id
*        FOR ALL ENTRIES IN @lt_cust
*        WHERE customer_id = @lt_cust-customer_id
*        INTO TABLE @DATA(lt_customer_db).
*
*      IF sy-subrc IS INITIAL.
*      ENDIF.
*
*      LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).
*
*        IF <ls_travel> IS INITIAL OR NOT line_exists(  lt_customer_db[ customer_id = <ls_travel>-CustomerId ] ).
*
*          APPEND VALUE #( %tky = <ls_travel>-%tky )
*              TO failed-travel.
*
*          APPEND VALUE #( %tky    = <ls_travel>-%tky
*                          %msg    = NEW  /dmo/cm_flight_messages(
*                                     textid         = /dmo/cm_flight_messages=>customer_unkown
*                                     customer_id    =  <ls_travel>-CustomerId
*                                     severity       = if_abap_behv_message=>severity-error
*                                    )
*                          %element-CustomerId = if_abap_behv=>mk-on
*                        )
*              TO reported-travel.
*
*        ENDIF.
*
*      ENDLOOP.
*
*    ENDIF.
  ENDMETHOD.

  METHOD validateStatus.
    READ ENTITIES OF z_i_travel__m IN LOCAL MODE
    ENTITY Travel
    FIELDS (  OverallStatus )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_travel).


    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      CASE <ls_travel>-OverallStatus.
        WHEN 'A'.
        WHEN 'O'.
        WHEN 'X'.
        WHEN OTHERS.
          APPEND VALUE #( %tky = <ls_travel>-%tky ) TO failed-travel.

          APPEND VALUE #( %tky    = <ls_travel>-%tky
                          %msg    = NEW  /dmo/cm_flight_messages(
                                     textid         = /dmo/cm_flight_messages=>status_invalid
                                     severity       = if_abap_behv_message=>severity-error
                                     status         = <ls_travel>-OverallStatus
                                    )
                          %element-OverallStatus = if_abap_behv=>mk-on
                        )
              TO reported-travel.
      ENDCASE.
    ENDLOOP.


  ENDMETHOD.

  METHOD calculateTotalPrice.

    MODIFY ENTITIES OF z_i_travel__m IN LOCAL MODE
    ENTITY Travel
    EXECUTE recalcTotPrice
    FROM CORRESPONDING #( keys ).

  ENDMETHOD.

  METHOD recalcTotPrice.

    TYPES: BEGIN OF ty_total,
             price    TYPE /dmo/total_price,
             currency TYPE /dmo/currency_code,
           END OF ty_total.

    DATA: lt_total TYPE STANDARD TABLE OF ty_total.

    READ  ENTITIES OF z_i_travel__m IN LOCAL MODE
        ENTITY Travel
        FIELDS ( BookingFee CurrencyCode )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_travel).


    READ  ENTITIES OF z_i_travel__m IN LOCAL MODE
        ENTITY Travel BY \_Booking
        FIELDS ( FlightPrice CurrencyCode )
        WITH CORRESPONDING #( lt_travel )
        RESULT DATA(lt_prices_booking).


    READ  ENTITIES OF z_i_travel__m IN LOCAL MODE
        ENTITY Booking BY \_Booking_Supl
        FIELDS ( Price CurrencyCode )
        WITH CORRESPONDING #( lt_prices_booking )
        RESULT DATA(lt_prices_booking_sup).

    LOOP AT lt_travel ASSIGNING FIELD-SYMBOL(<ls_travel>).

      lt_total =  VALUE #( ( price = <ls_travel>-BookingFee currency =  <ls_travel>-CurrencyCode ) ).
      LOOP AT lt_prices_booking ASSIGNING FIELD-SYMBOL(<ls_booking>)
                                  USING KEY entity
                                  WHERE TravelId = <ls_travel>-TravelId AND
                                        CurrencyCode IS NOT INITIAL.
        APPEND VALUE #( price = <ls_booking>-FlightPrice currency =  <ls_booking>-CurrencyCode ) TO lt_total.

        LOOP AT lt_prices_booking_sup ASSIGNING FIELD-SYMBOL(<ls_booking_sup>)
                                    USING KEY entity
                                    WHERE TravelId = <ls_booking>-TravelId AND
                                          BookingId = <ls_booking>-BookingId AND
                                          CurrencyCode IS NOT INITIAL.

          APPEND VALUE #( price = <ls_booking_sup>-Price currency =  <ls_booking_sup>-CurrencyCode ) TO lt_total.

        ENDLOOP.



      ENDLOOP.

      LOOP AT lt_total ASSIGNING FIELD-SYMBOL(<ls_total>).

        IF <ls_travel>-CurrencyCode NE <ls_total>-currency.

          /dmo/cl_flight_amdp=>convert_currency(
            EXPORTING
              iv_amount               = <ls_total>-price
              iv_currency_code_source = <ls_total>-currency
              iv_currency_code_target = <ls_travel>-CurrencyCode
              iv_exchange_rate_date   = cl_abap_context_info=>get_system_date( )
            IMPORTING
              ev_amount               = <ls_total>-price
          ).
        ENDIF.

        <ls_travel>-TotalPrice += <ls_total>-price.
      ENDLOOP.

    ENDLOOP.

    MODIFY ENTITIES OF Z_i_travel__m IN LOCAL MODE
    ENTITY Travel
    UPDATE FIELDS ( TotalPrice )
    WITH CORRESPONDING #( lt_travel ).




  ENDMETHOD.

  METHOD reCalTotalPrice.
  ENDMETHOD.

ENDCLASS.
