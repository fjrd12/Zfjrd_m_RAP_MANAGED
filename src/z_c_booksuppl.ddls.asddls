@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Booking supplement projectionn view'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity Z_C_BOOKSUPPL as projection on Z_I_BOOKSUPPL
{
    key TravelId,
    key BookingId,
    key BookingSupplementId,
    @ObjectModel.text.element: [ 'SupplementDesc' ]
    SupplementId,
    _Suplementtxt.Description as SupplementDesc,
    @Semantics.amount.currencyCode: 'CurrencyCode'
    Price,
    CurrencyCode,
    LastChangedAt,
    /* Associations */
    _Booking: redirected to parent Z_C_BOOKING_M,
    _Suplement,
    _Suplementtxt,
    _Travel: redirected to Z_C_TRAVEL_M
}
