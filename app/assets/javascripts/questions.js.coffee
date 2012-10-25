# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

deleteQuestion = (e) ->
  e.preventDefault()
  $(@).fadeOut 'fast', ->
    if confirm('Are you sure you want to delete this question? This cannot be undone.')  
      $.ajax $(@).attr('href'),
        type: 'delete'
        context: $(@)
        success: ->
          dl = $(@).parents('dl:first')
          dl.slideUp 1000, ->
            $(@).remove()
    else
      $(@).fadeIn()

$('.btn-question-delete').click deleteQuestion
