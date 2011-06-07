initInvoiceDateFilters = function (option, onload) {
	if (option == 'On' || option == 'Range') {
		$('.search_invoice #div_start_date').show();
     
    if (option == 'Range'){
      $('.search_invoice #div_end_date').show();
		}
    else
    {
      $('.search_invoice #div_end_date').hide();
    }
	} else {
		$('.search_invoice #div_start_date').hide();
		$('.search_invoice #div_end_date').hide();
	}
};

initEntryDateFilters = function (option, onload) {
	if (option == 'On' || option == 'Range') {
		$('.search_entry #div_start_date').show();
     
    if (option == 'Range'){
      $('.search_entry #div_end_date').show();
		}
    else
    {
      $('.search_entry #div_end_date').hide();
    }
	} else {
		$('.search_entry #div_start_date').hide();
		$('.search_entry #div_end_date').hide();
	}
};

$(document).ready(function() {
    initInvoiceDateFilters($('.search_invoice #raised').val(), false);
    $('.search_invoice #raised').live('change', function() {initInvoiceDateFilters($('.search_invoice #raised').val(), false);});
    initEntryDateFilters($('.search_entry #entered').val(), false);
    $('.search_entry #entered').live('change', function() {initEntryDateFilters($('.search_entry #entered').val(), false);});
});
