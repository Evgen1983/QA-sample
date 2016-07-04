# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.edit-question-link').click (e) -> 
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId')
    $('form#edit_question_' + question_id).show()

  $('.question_votesbuttons').bind 'ajax:success', (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    $('.question_votes').html(response.score)
    if response.status == true
      $('.question_votesbuttons').find('#button_up').attr('disabled',true);
      $('.question_votesbuttons').find('#button_down').attr('disabled',true);
      $('.question_votesbuttons').find('#button_reset').attr('disabled',false);
    else
      $('.question_votesbuttons').find('#button_up').attr('disabled',false);
      $('.question_votesbuttons').find('#button_down').attr('disabled',false);
      $('.question_votesbuttons').find('#button_reset').attr('disabled',true); 
$(document).ready(ready) 
$(document).on('page:load', ready)  
$(document).on('page:update', ready) 