# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  $(".first-field").focus()

  askQuestion = (e) ->
    e.preventDefault()
    form_data = $(this).serialize()

    $.ajax $(@).attr('action'),
      data: form_data
      dataType: 'html'
      type: 'post'
      success: (result) ->
        $('#ask-a-question').html(result).addClass('alert alert-info')

  $('#new_question').submit askQuestion