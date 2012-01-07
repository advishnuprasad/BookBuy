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

$("#ibtr_validate").live('click',function() {
  var isbn = $.trim($("#ibtr_isbn").val());
  var url = '/enrichedtitles?queryISBN=' + isbn;

  $.ajax({
    url: url,
    async: false,
    dataType: 'json',
    success: function(data) {
      $("#ibtr_isbn_title").text(data.enrichedtitle.title);
      $("#ibtr_isbn_author").text(data.enrichedtitle.author);
      $("#ibtr_isbn_titleid").text(data.enrichedtitle.title_id);
    },
    error: function(xhr,status,errorThrown) {
      alert('This ISBN does not exist - if you are sure this is a valid ISBN, add it first - ' + xhr.status);
    }
  });
});