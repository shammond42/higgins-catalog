# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

artifactQuestion =
  deleteQuestion: (e) ->
    e.preventDefault()
    e.stopImmediatePropagation()
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
        $(@).fadeIn('fast')
  askQuestion: (e) ->
    e.preventDefault()
    if not $('#question_question').val?()
      $('#question_question').parents('dl:first').addClass('error')
      $('#question_question').attr('placeholder', 'Please ask a question before submitting the form.')
      return
    form_data = $(@).serialize()

    $.ajax $(@).attr('action'),
      data: form_data
      dataType: 'html'
      type: 'post'
      success: (result) ->
        $('#ask-a-question').html(result).addClass('alert alert-info')
  editAnswer: (e) ->
    e.preventDefault()
    $.ajax $(@).attr('href'),
      dataType: 'html'
      type: 'get'
      context: $(@)
      success: (result) ->
        dd = $(@).parents('dl:first').children('.answer')
        dd.slideUp 'fast', ->
          $(@).next().slideUp()
          $(@).html(result)
          $(@).slideDown 'slow'
  answerQuestion: (e) ->
    e.preventDefault()
    if not $('#question_answer').val?()
      $('#question_answer').parents('dl:first').addClass('error')
      $('#question_answer').attr('placeholder', 'Please answer the question before submitting the form.')
      return
    form_data = $(@).serialize()

    $.ajax $(@).attr('action'),
      data: form_data
      dataType: 'html'
      type: 'post'
      context: $(@)
      success: (result) ->
        dl = $(@).parents('dl:first')
        dl.removeClass('error')
        dl.slideUp 'slow', ->
          $(@).html($(result).html())
          $(@).slideDown 'slow'
  init: ->
    $('.question-item').on 'click', '.btn-question-delete', this.deleteQuestion
    $('.question-item').on 'click', '.btn-answer-edit', this.editAnswer
    $('.question-item').on 'submit','.edit_question', this.answerQuestion
    $('#new_question').submit this.askQuestion
  
$ ->
  artifactQuestion.init()