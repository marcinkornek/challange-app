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

class AvatarCropper
  constructor: ->
    $('#cropbox').Jcrop
      aspectRatio:  1
      setSelect:    [0, 0, 600, 600]
      bgColor:     'black'
      onSelect:     @update
      onChange:     @update

  update: (coords) =>
    $('#user_crop_x').val(coords.x)
    $('#user_crop_y').val(coords.y)
    $('#user_crop_w').val(coords.w)
    $('#user_crop_h').val(coords.h)
    @updatePreview(coords)

  updatePreview: (coords) =>
    $('#preview').css
      width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
      height: Math.round(100/coords.w * $('#cropbox').height()) + 'px'
      marginLeft: '-' + Math.round(100/coords.w * coords.x) + 'px'
      marginTop: '-' + Math.round(100/coords.h * coords.y) + 'px'

$ ->
  jQuery("time.timeago").timeago()
  acceptAnswer()
  userSearchAutocomplete()
  toggleSignForm()
  showSignForm() #shows form when username or email is present
  new AvatarCropper()




