@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Booking sumplement'
@Metadata.ignorePropagatedAnnotations: true
define view entity Z_I_BOOKSUPPL
  as select from zbooksup_m
  association        to parent Z_I_BOOKING_M     as _Booking      on  $projection.TravelId  = _Booking.TravelId
                                                                  and $projection.BookingId = _Booking.BookingId
  association [1..1] to Z_I_TRAVEL__M  as _Travel
  on $projection.TravelId = _Travel.TravelId
   
  association [1..1] to /DMO/I_Supplement     as _Suplement    on  $projection.SupplementId = _Suplement.SupplementID
  association [1..1] to /DMO/I_SupplementText as _Suplementtxt on  $projection.SupplementId = _Suplementtxt.SupplementID

{
  key travel_id             as TravelId,
  key booking_id            as BookingId,
  key booking_supplement_id as BookingSupplementId,
      supplement_id         as SupplementId,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      price                 as Price,
      currency_code         as CurrencyCode,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      _Suplement,
     _Suplementtxt,
     _Booking,
     _Travel
}
