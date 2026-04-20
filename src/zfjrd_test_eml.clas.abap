CLASS zfjrd_test_eml DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zfjrd_test_eml IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    CONSTANTS _c1 TYPE decfloat16 VALUE '00000006'.
*1st read way
*    READ ENTITY z_i_travel__m
*    FROM VALUE #( ( %key-TravelId = _c1
*                    %CONTROL = value #(  AgencyId = if_abap_behv=>mk-on
*                                         CustomerId = if_abap_behv=>mk-on
*                                         BeginDate = if_abap_behv=>mk-on
*                                       ) ) )
*    RESULT DATA(lt_output)
*    FAILED DATA(lt_failed).
*
*    IF lt_failed IS NOT INITIAL.
*      out->write( 'Problem to read' ).
*    ELSE.
*      out->write( lt_output ).
*    ENDIF.

*2nd way to read
*    READ ENTITY z_i_travel__m
*      by \_Booking
**    FIELDS ( AgencyId CreatedAt CustomerId )
*    All FIELDS
*    WITH VALUE #( ( %key-TravelId = _c1 )
*                  ( %key-TravelId =  '00000007')
*                  ( %key-TravelId =  '00000014') )
*    RESULT DATA(lt_output)
*    FAILED DATA(lt_failed).
*
*    IF lt_failed IS NOT INITIAL.
*      out->write( 'Problem to read' ).
*    ELSE.
*      out->write( lt_output ).
*    ENDIF.

*3rd form to read
*    READ ENTITIES OF z_i_travel__m
*
*    ENTITY Travel
*    ALL FIELDS
*        WITH VALUE #( ( %key-TravelId = _c1 )
*                      ( %key-TravelId =  '00000007')
*                      ( %key-TravelId =  '00000014') )
*    RESULT DATA(lt_output_travel)
*
*
*    ENTITY Booking
*    ALL FIELDS
*        WITH VALUE #( ( %key-TravelId =   '00000001'
*                        %key-BookingId =  '00000001') )
*    RESULT DATA(lt_output_booking)
*    FAILED DATA(lt_failed).
*
*    IF lt_failed IS NOT INITIAL.
*      out->write( 'Problem to read' ).
*    ELSE.
*      out->write( lt_output_travel ).
*      out->write( lt_output_booking ).
*    ENDIF.

**4th dynamic reading
*    DATA : it_optab            TYPE abp_behv_retrievals_tab,
*           it_travel           TYPE TABLE FOR READ IMPORT z_i_travel__m,
*           it_booking          TYPE TABLE FOR READ IMPORT z_i_travel__m\_Booking,
*           it_travel_results   TYPE TABLE FOR READ RESULT z_i_travel__m,
*           it_booking_results  TYPE TABLE FOR READ RESULT z_i_travel__m\_Booking.
*
*    it_travel = VALUE #( ( %key-TravelId = _c1
*                               %control = VALUE #(  AgencyId = if_abap_behv=>mk-on
*                                                  CustomerId = if_abap_behv=>mk-on
*                                                   BeginDate = if_abap_behv=>mk-on )
*                      ) ).
*
*    it_booking = VALUE #( ( %key-TravelId = _c1
*                            %control = VALUE #(  BookingDate = if_abap_behv=>mk-on
*                                                 BookingStatus = if_abap_behv=>mk-on
*                                                 BookingId = if_abap_behv=>mk-on )
*                      ) ).
*
*    it_optab = VALUE #( ( op = if_abap_behv=>op-r-read
*                          entity_name = 'Z_I_TRAVEL__M'
*                          instances = REF #( it_travel )
*                          results = REF #( it_travel_results ) )
*
*                          ( op = if_abap_behv=>op-r-read_ba
*                          entity_name = 'Z_I_TRAVEL__M'
*                          sub_name = '_BOOKING'
*                          instances = REF #( it_booking )
*                          results = REF #( it_booking_results ) ) ).
*
*    READ ENTITIES OPERATIONS it_optab
*    FAILED DATA(lt_failed_dy).
*
*    IF lt_failed_dy IS NOT INITIAL.
*      out->write( 'Problem to read' ).
*    ELSE.
*      out->write( it_travel_results ).
*      out->write( it_booking_results ).
**      out->write( lt_output_booking ).
*    ENDIF.
*    DATA: it_book TYPE TABLE FOR CREATE z_i_travel__m\_Booking.
**    Adding with nested entities
*    MODIFY ENTITY z_i_travel__m
*        CREATE FROM VALUE #(
*                ( %cid = 'cid1'
*                  %data-BeginDate = '20260402'
*                  %control-BeginDate = if_abap_behv=>mk-on
*                  ) )
*        CREATE BY \_Booking
*            FROM VALUE #( ( %cid_ref = 'cid1'
*                            %target  = VALUE #( ( %cid  = 'cid1_1'
*                                                  BookingDate = '20260402'
*                                                  %control-BookingDate = if_abap_behv=>mk-on
*                                              ) )
*                       ) )
*        FAILED FINAL(it_failed)
*        MAPPED FINAL(it_mapped)
*        REPORTED FINAL(it_result).
*
*    IF it_failed IS NOT INITIAL.
*      out->write( it_failed ).
*    ELSE.
*      out->write( it_result ).
*      COMMIT ENTITIES.
*    ENDIF.

*    Deleting related records
*    MODIFY ENTITY z_i_booking_m
*    DELETE FROM VALUE #( ( %key-TravelId = '00049843'
*                           %key-BookingId = '0010' ) )
*    FAILED FINAL(it_failed_del)
*    MAPPED FINAL(it_mapped_del)
*    REPORTED FINAL(it_result_del).
*
*    IF it_failed_del IS NOT INITIAL.
*      out->write( it_failed_del ).
*    ELSE.
*      out->write( it_result_del ).
*      COMMIT ENTITIES.
*    ENDIF.

* MODIFY CREATE AUTOFILL
*    MODIFY ENTITY z_i_travel__m
*        CREATE AUTO FILL CID WITH VALUE #(
*                (
*                  %data-BeginDate = '20260404'
*                  %control-BeginDate = if_abap_behv=>mk-on
*                  ) )
*
*        FAILED FINAL(it_failed)
*        MAPPED FINAL(it_mapped)
*        REPORTED FINAL(it_result).
*
*    IF it_failed IS NOT INITIAL.
*      out->write( it_failed ).
*    ELSE.
*      out->write( it_result ).
*      COMMIT ENTITIES.
*    ENDIF.

*Modify and delete together
*    MODIFY ENTITIES OF z_i_travel__m
*      ENTITY Travel
*        UPDATE FIELDS ( BeginDate )
*        WITH VALUE #( ( %key-TravelId = '00049844'
*                            BeginDate = '20260509'
*                  ) )
*      ENTITY Travel
*        DELETE FROM VALUE #( ( %key-TravelId = '00049843' ) ).
*
*    COMMIT ENTITIES.

    MODIFY ENTITY z_i_travel__m
    UPDATE SET FIELDS WITH VALUE #( ( %key-TravelId =  '00049844' BeginDate = '20260525' ) ).
    COMMIT ENTITIES.



  ENDMETHOD.
ENDCLASS.
