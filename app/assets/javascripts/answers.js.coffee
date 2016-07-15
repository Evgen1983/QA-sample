# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-answer-link').click (e) -> 
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId')
    $('form#edit-answer-' + answer_id).show()

  $('.answer_votesbuttons').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('#answer-' + response.id).find('.answer_votes').html(response.score);
    if response.status == true
      $('#answer-' + response.id).find('.answer_votesbuttons #button_up').attr('disabled',true)
      $('#answer-' + response.id).find('.answer_votesbuttons #button_down').attr('disabled',true)
      $('#answer-' + response.id).find('.answer_votesbuttons #button_reset').attr('disabled',false)
    else
      $('#answer-' + response.id).find('.answer_votesbuttons #button_up').attr('disabled',false)
      $('#answer-' + response.id).find('.answer_votesbuttons #button_down').attr('disabled',false)
      $('#answer-' + response.id).find('.answer_votesbuttons #button_reset').attr('disabled',true)
  
  
   
$(document).ready(ready) 
$(document).on('page:load', ready)  
$(document).on('page:update', ready) 