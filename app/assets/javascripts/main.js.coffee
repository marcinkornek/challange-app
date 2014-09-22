# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.acceptAnswer = ->
  $('.js-accept').on 'click', (e) ->
    form = $(e.target).closest('form')
    # form = $(this).closest('form')  #this also works
    form.submit()

window.userSearchAutocomplete = ->
  $('#search').autocomplete
    source: $('#search').data('autocomplete-source')
    minLength: 2
    autoFocus: true

window.toggleSignForm = ->
  $('.challange-app').on 'click', ->
    $('.form').slideToggle()
    # console.log 'a'

window.showSignForm = ->
  if $('#user_email').val() || $('#user_username').val()
    console.log $('#user_email').val()
    $('.form').toggle()

# window.showAnchorContent = ->


$ ->
  jQuery("time.timeago").timeago()
  acceptAnswer()
  userSearchAutocomplete()
  toggleSignForm()
  showSignForm() #shows form when username or email is present
  # showAnchorContent()
