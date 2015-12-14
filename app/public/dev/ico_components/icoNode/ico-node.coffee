{KEYBOARD_CODES} = window.constants


class IcoNode

  @icoNodeChildClass: 'ico-child'
  @icoNodeElement: 'ico-node'
  @isFoldedClass: 'is-folded'


  @init: =>
    @icoNodeDom = document.registerElement @icoNodeElement
    @_setNodeEditableOnClick()
    @_initKeyboardShortcuts()


  @_setNodeEditableOnClick: =>
    #### To handle child delegation for indent i had to be sure that only the clicked ico node is editable
    $(document).on 'click', @icoNodeElement, (event) =>
      event.stopPropagation()

      @_restoreAllEditableNodes()
      target = event.target
      target.contentEditable = true
      target.focus()


  @_restoreAllEditableNodes: =>
    for element in $(@icoNodeElement)

      element.contentEditable = false


  @_toggleNodeEditable: (node) =>
    if node.contentEditable is "true"
      node.contentEditable = false
    else
      node.contentEditable = true


  @newIcoNode: =>
    newIcoNode = new @icoNodeDom()
    newIcoNode


  @_initKeyboardShortcuts: =>
    $(document).on 'keydown', @icoNodeElement, (event) =>
      event.stopPropagation()
      pressedKey = event.keyCode

      #### If Command is pressed handle it
      @_handleCommandKey(event) if event.metaKey

      switch pressedKey
        when KEYBOARD_CODES.tab then @_indentIcoNode event
        when KEYBOARD_CODES.upArrow then @_moveCursorUp event
        when KEYBOARD_CODES.downArrow then @_moveCursorDown event
        when KEYBOARD_CODES.delete then @_deleteNode event


  @_handleCommandKey: (event) =>
    switch event.keyCode
      when KEYBOARD_CODES.enter then @_appendSiblingOnEnter event
      when KEYBOARD_CODES.rightArrow then @_toggleFold event
      when KEYBOARD_CODES.leftArrow then @_toggleFold event


  @_appendSiblingOnEnter: (event, icoNode = @newIcoNode()) =>
    return false if event.target.nodeName.toLowerCase() isnt @icoNodeElement

    if event.keyCode is KEYBOARD_CODES.enter
      target = event.target
      parent = target.parentNode

      movedIcoNode = parent.insertBefore(icoNode, target.nextSibling)

      target.contentEditable = false
      movedIcoNode.contentEditable = true
      movedIcoNode.focus()
      return false


  @_deleteNode: (event) =>
    target = event.target
    parent = target.parentNode

    if target.previousSibling instanceof @icoNodeDom
      previousNode = target.previousSibling

    else if parent instanceof @icoNodeDom
      previousNode = parent

    #### If cursor is at the beginning of node and has ico node before or parent ico node
    if window.getSelection().anchorOffset is 0 and previousNode
      @_toggleNodeEditable previousNode
      previousNode.focus()
      parent.removeChild(target)


  @_indentIcoNode: (event) =>
    target = event.target
    parent = target.parentNode

    if target.previousSibling instanceof @icoNodeDom
      previousNode = target.previousSibling

    else if parent instanceof @icoNodeDom
      previousNode = parent
    $previousNode = $(previousNode)

    if previousNode and previousNode instanceof @icoNodeDom and previousNode.innerHTML

      if event.shiftKey
        #### Unindent Node
        parentsParent = parent.parentNode
        movedNode = parentsParent.insertBefore(target, parent.nextSibling)

      else
        #### Indent Node
        movedNode = previousNode.appendChild target

      movedNode.focus()
    false


  @_moveCursorUp: (event) =>
    target = event.target

    previousSibling = target.previousSibling
    $previousSibling = $ previousSibling

    previousSiblingLastChild = previousSibling.lastChild

    parentNode = target.parentNode

    if previousSiblingLastChild instanceof @icoNodeDom and !$previousSibling.hasClass @isFoldedClass
      previousNode = previousSiblingLastChild

    else if previousSibling instanceof @icoNodeDom
      previousNode = previousSibling

    else if parentNode instanceof @icoNodeDom
      previousNode = parentNode

    else
      return false

    @_toggleNodeEditable previousNode

    #### Have to wait 0ms because of Dom weird reasons
    setTimeout =>
      previousNode.focus()
    , 0

    @_toggleNodeEditable target


  @_moveCursorDown: (event) =>
    target = event.target
    $target = $ target
#    oldCursorVOffset = window.getSelection().focusOffset

    if target.firstChild.nextSibling instanceof @icoNodeDom and !$target.hasClass(@isFoldedClass)
      nextNode = target.firstChild.nextSibling

    else if target.nextSibling instanceof @icoNodeDom
      nextNode = target.nextSibling

    else if target.parentNode.nextSibling instanceof @icoNodeDom
      nextNode = target.parentNode.nextSibling

    else
      return false

    @_toggleNodeEditable nextNode

    #### Have to wait 0ms because of Dom weird reasons
    setTimeout =>
      nextNode.focus()
    , 0
    @_toggleNodeEditable target


  @_toggleFold: (event) =>
    target = event.target
    $target = $ event.target

    if target.childNodes.length > 1

      $target.toggleClass @isFoldedClass
