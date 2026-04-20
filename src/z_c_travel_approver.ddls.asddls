@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel aprover projection'
@UI.headerInfo: {
    typeName: 'Travel',
    typeNamePlural: 'Travels',
    title: {
                type: #STANDARD,
                label: 'Travel',
                value: 'TravelId'
            }
}
@Search.searchable: true
define root view entity Z_C_TRAVEL_APPROVER
  provider contract transactional_query
  as projection on Z_I_TRAVEL__M
{

      @UI.facet: [{
          id: 'Travel',
          purpose: #STANDARD,
          position: 10,
          label: 'Travel',
          type: #IDENTIFICATION_REFERENCE
      },
      {   id: 'Booking',
          purpose: #STANDARD,
          position: 20,
          label: 'Booking',
          type: #LINEITEM_REFERENCE,
          targetElement: '_Booking'
      }]

      @UI.lineItem: [{  position: 10, importance: #HIGH} ]
      @UI.identification: [{ position: 10 }]

  key TravelId,
      @UI.lineItem: [{  position: 20, importance: #HIGH} ]
      @UI.selectionField: [{ position: 20 }]
      @UI.identification: [{ position: 20 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Agency',
                                                   element: 'AgencyID'} }]
      @ObjectModel.text.element: [ 'AgencyName' ]
      @Search.defaultSearchElement: true
      AgencyId,
      _Agency.Name         as AgencyName,
      @UI: {
       lineItem: [{  position: 30}],
       selectionField: [{ position: 30 }]
      }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: '/DMO/I_Customer',
                                                   element: 'CustomerID'} }]
      @UI.identification: [{ position: 30 }]
      @ObjectModel.text.element: [ 'CustomerName' ]
      _Customer.LastName   as customerName,
      CustomerId,
      @UI.lineItem: [{  position: 40}]
      @UI.identification: [{ position: 40 }]
      BeginDate,
      @UI.lineItem: [{  position: 50}]
      @UI.identification: [{ position: 50 }]
      EndDate,
      @UI.lineItem: [{  position: 60}]
      @UI.identification: [{ position: 60 }]
      @Semantics.amount.currencyCode: 'CurrencyCode'
      TotalPrice,
      @UI: {
             lineItem: [{  position: 70}],
             selectionField: [{ position: 70 }]
           }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency',
                                                  element: 'Currency'} }]
      CurrencyCode,
      @UI.lineItem: [{  position: 75}]
      @UI.identification: [{ position: 75 }]
      Description,
      @UI.identification: [{ position: 80 },
                           {  type: #FOR_ACTION, dataAction: 'acceptTravel', label: 'Accept Travel' },
                           {  type: #FOR_ACTION, dataAction: 'rejectTravel', label: 'Reject Travel' }]
      @UI.lineItem: [{  position: 75, importance: #HIGH},
                     {  type: #FOR_ACTION, dataAction: 'acceptTravel', label: 'Accept Travel' },
                     {  type: #FOR_ACTION, dataAction: 'rejectTravel', label: 'Reject Travel' }]
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'OverStatusText']
      OverallStatus,
      @UI.hidden: true
      LastChangedAt,
      LocalLastChangedAt,
      _StatusVH._Text.Text as OverStatusText : localized,
      /* Associations */
      _Agency,
      _Booking : redirected to composition child Z_C_BOOKING_APPROVER,
      _Currency,
      _Customer,
      _StatusVH
}
