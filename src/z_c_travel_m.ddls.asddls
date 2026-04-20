@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Travel consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity Z_C_TRAVEL_M
provider contract transactional_query
as projection on Z_I_TRAVEL__M
{
    key TravelId,
    @ObjectModel.text.element: [ 'AgencyName' ]
    AgencyId,
    _Agency.Name as AgencyName,
    CustomerId,
    @ObjectModel.text.element: [ 'CustomerName' ]
    _Customer.LastName as CustomerName,
    BeginDate,
    EndDate,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    BookingFee,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    TotalPrice,
    CurrencyCode,
    Description,
    @ObjectModel.text.element: [ 'OverallStatusText' ]
    OverallStatus,
    _StatusVH._Text.Text as OverallStatusText: localized,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    LocalLastChangedAt,
    /* Associations */
    _Agency,
    _Booking: redirected to composition child  Z_C_BOOKING_M,
    _Currency,
    _Customer,
    _StatusVH
}
