# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.acceptAnswer = ->
  $('.js-accept').on 'click', (e) ->
    form = $(e.target).closest('form')
    # form = $(this).closest('form')  #this also works
    form.submit()

$ ->
  jQuery("time.timeago").timeago()
  acceptAnswer()
