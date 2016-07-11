# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  PrivatePub.subscribe "/comments", (data, channel) ->
    comment = $.parseJSON(data['comment'])
    content = '<ul><li>' + comment.content + '</li></ul>'
    if comment.commentable_type == 'Question'
      $('#question-' + comment.commentable_id).find('.question_comments').append(content)
      $('textarea#comment_content').val('')
      $('.comments-errors-form').empty();
    else
      $('#answer-' + comment.commentable_id).find('.answer_comments').append(content)
      $('textarea#comment_content').val('');	
      $('.comments-errors-form').empty();

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)