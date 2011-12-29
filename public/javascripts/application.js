// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$("#enrichedtitle_use_image_url").live('click',function() {
  if (this.checked) {
    $("#enrichedtitle_cover").val("");
    $("#enrichedtitle_cover").attr('disabled','disabled');
  } else {
    $("#enrichedtitle_cover").removeAttr('disabled');
  }
  
});