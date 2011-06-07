initInvoiceIndex = function (option, onload) {
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

$(document).ready(function() {
    initInvoiceIndex($('.search_invoice #created').val(), false);
    $('.search_invoice #created').live('change', function() {initInvoiceIndex($('.search_invoice #created').val(), false);});
});
