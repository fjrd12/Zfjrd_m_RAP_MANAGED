@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking projection'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity Z_C_BOOKING_M
  as projection on Z_I_BOOKING_M
{
  key TravelId,
  key BookingId,
      BookingDate,
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName as CustomerName,
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      _Carrier.Name as CarrierName,
      ConnectionId,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @ObjectModel.text.element: [ 'BookingStatustxt' ]
      BookingStatus,
      _Booking_Status._Text.Text as BookingStatustxt: localized,
      LastChangedAt,
      /* Associations */
      _Booking_Status,
      _Booking_Supl: redirected to composition child Z_C_BOOKSUPPL,
      _Carrier,
      _Connection,
      _Customer,
      _Travel : redirected to parent Z_C_TRAVEL_M
}
