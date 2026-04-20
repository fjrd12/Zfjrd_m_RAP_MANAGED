@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Boking approver projection'
@UI.headerInfo: {
    typeName: 'Booking',
    typeNamePlural: 'Bookings',
    title: {
                type: #STANDARD,
                label: 'Booking',
                value: 'BookingId'
            }
}
@Search.searchable: true
define view entity Z_C_BOOKING_APPROVER
  as projection on Z_I_BOOKING_M
{

      @UI.facet: [{
           id: 'Booking',
           purpose: #STANDARD,
           position: 10,
           label: 'Booking',
           type: #IDENTIFICATION_REFERENCE
       }]
      @Search.defaultSearchElement: true
  key TravelId,
      @UI.lineItem: [{  position: 20}]
      @UI.identification: [{ position: 20 }]
  key BookingId,
      @UI.lineItem: [{  position: 30}]
      @UI.identification: [{ position: 30 }]
      BookingDate,
      @UI.lineItem: [{  position: 40}]
      @UI.identification: [{ position: 40 }]
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer',
                                                 element: 'CustomerID'} }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      CustomerId,
      _Customer.LastName         as CustomerName,
      @UI.lineItem: [{  position: 50}]
      @UI.identification: [{ position: 50 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Carrier',
                                                element: 'AirlineID'} }]
      @ObjectModel.text.element: [ 'CarrierName' ]
      CarrierId,
      @UI.lineItem: [{  position: 60}]
      @UI.identification: [{ position: 60 }]
      ConnectionId,
      _Carrier.Name              as CarrierName,
      @UI.lineItem: [{  position: 70}]
      @UI.identification: [{ position: 70 }]
      FlightDate,
      @UI.lineItem: [{  position: 80}]
      @UI.identification: [{ position: 80 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      CurrencyCode,
      @UI.lineItem: [{  position: 90}]
      @UI.identification: [{ position: 90 }]
      @UI.textArrangement: #TEXT_FIRST
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Booking_Status_VH',
                                                 element: 'BookingStatus'} }]
      @ObjectModel.text.element: [ 'BookingStatusText' ]
      BookingStatus,
      _Booking_Status._Text.Text as BookingStatusText : localized,
      @UI.hidden: true
      LastChangedAt,
      /* Associations */
      _Booking_Status,
      _Booking_Supl,
      _Carrier,
      _Connection,
      _Customer,
      _Travel : redirected to parent Z_C_TRAVEL_APPROVER
}
