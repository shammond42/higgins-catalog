# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

artifactQuestion =
  deleteQuestion: (e) ->
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
              if $('dl').length is 0
                $('<h2 class="hide">All questions have been taken care of.</h2>').insertAfter('h1:first')
                $('h2:first').slideDown()
      else
        $(@).fadeIn()
  askQuestion: (e) ->
    e.preventDefault()
    form_data = $(@).serialize()

    $.ajax $(@).attr('action'),
      data: form_data
      dataType: 'html'
      type: 'post'
      success: (result) ->
        $('#ask-a-question').html(result).addClass('alert alert-info')
  answerQuestion: (e) ->
    e.preventDefault()
    form_data = $(@).serialize()

    $.ajax $(@).attr('action'),
      data: form_data
      dataType: 'html'
      type: 'post'
      context: $(@)
      success: (result) ->
        dl = $(@).parents('dl:first')
        dl.slideUp 1000, ->
          $(@).find('form').replaceWith(result)
          $(@).slideDown 'slow'
  init: ->
    $('.btn-question-delete').click this.deleteQuestion
    $('.edit_question').submit this.answerQuestion
    $('#new_question').submit this.askQuestion
  
$ ->
  artifactQuestion.init()