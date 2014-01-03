# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Put focus on the search field
artifactSearch = 
  submitForm: (e) ->
    $('#low_date').val($(@).data('low'))
    $('#high_date').val($(@).data('high'))
    $('#search-form').submit()
  
$ ->
  $('.date-filter-link').click artifactSearch.submitForm
  $("#query").focus()