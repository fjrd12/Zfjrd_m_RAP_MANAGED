@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking interface view Managed scenario'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_I_BOOKING_M
  as select from zbooking__m
  composition [0..*] of Z_I_BOOKSUPPL            as _Booking_Supl
  association        to parent Z_I_TRAVEL__M            as _Travel  on  $projection.TravelId = _Travel.TravelId
  association [1..1] to /DMO/I_Carrier           as _Carrier        on  $projection.CarrierId = _Carrier.AirlineID
  association [1..1] to /DMO/I_Customer          as _Customer       on  $projection.CustomerId = _Customer.CustomerID
  association [1..1] to /DMO/I_Connection        as _Connection     on  $projection.CarrierId    = _Connection.AirlineID
                                                                    and $projection.ConnectionId = _Connection.ConnectionID
  association [1..1] to /DMO/I_Booking_Status_VH as _Booking_Status on  $projection.BookingStatus = _Booking_Status.BookingStatus

  //composition of target_data_source_name as _association_name
 {
  key travel_id       as TravelId,
  key booking_id      as BookingId,
      booking_date    as BookingDate,
      customer_id     as CustomerId,
      carrier_id      as CarrierId,
      connection_id   as ConnectionId,
      flight_date     as FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      flight_price    as FlightPrice,
      currency_code   as CurrencyCode,
      booking_status  as BookingStatus,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at as LastChangedAt,      
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _Carrier,
      _Customer,
      _Connection,
      _Booking_Status,
      _Travel,
      _Booking_Supl
}
