jQuery ->

    $('.sortable').each ->
      new SortableList( $(this).attr('id') )


# Element must have an id and a data-attribute 'action'
# actions is fired with a POST-request appending
# sorted_ids: item-ids in new order
class SortableList

  constructor: (_id) ->
    element          = $("##{_id}")
    action           = element.attr 'action'
    setupListElement element, action

  setupListElement= (element, action) ->
    element.disableSelection()
    element.sortable 
      dropOnEmpty: false,
      update:  (event, ui) ->
        fireRequest( collectItems(element), action )

  collectItems= (element) ->
    objects = []
    element.children().each ->
      objects.push $(this).attr('id')
    return objects

  fireRequest= (objects, action) ->
    $.post action, sorted_ids: objects
