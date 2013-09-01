jQuery ->

    # Install drag-and-drop callback for all
    # elements with class .sortable
    #
    # Element must have a css-id and a data-attribute "action".
    # "actions" is fired with a POST-request on drop.
    # Action appends param "sorted_ids" as an Array of
    # new sorted [ item-ids ]. The called action must
    # persist the new order.

    $('.sortable').each ->
      new SortableList( $(this).attr('id') )


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
