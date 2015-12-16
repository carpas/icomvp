class IcoEditor

  @icoEditorElement: 'ico-editor'
  @dataContentAttr: 'content'
  @dataCurrentFile: 'fileName'

  @IcoNode: IcoNode


  @init: =>
    @icoEditorDom = document.registerElement @icoEditorElement
    changeFileEventWithoutSaving = window.pubsubEvents.changeFileWithoutSaving
    changeFileEvent = window.pubsubEvents.changeFile
    PubSub.subscribe changeFileEventWithoutSaving, (msg, data) =>
      @_changeCurrentFile data

    PubSub.subscribe changeFileEvent, (msg, data) =>
      @_saveContent()
      .then =>
        @_changeCurrentFile data

    @IcoNode.init()

    setInterval @_saveContent, 5000


  @_changeCurrentFile: (data) =>
    $icoEditor = $ @icoEditorElement
    icoEditor = $icoEditor[0]

    {newContent, newFileName} = data

    newObjectContent = JSON.parse atob(newContent)
    decodedChildTree = @_importFromObject newObjectContent
    icoEditor.innerHTML = ""
    icoEditor.appendChild(child) for child in decodedChildTree
    icoEditor.dataset.currentFile = newFileName


  @_saveContent: =>

    new Promise (resolve, reject) =>
      $icoEditor = $ @icoEditorElement
      icoEditor = $icoEditor[0]

      objectToSave = @_exportDomTreeToObject icoEditor
      JSONToSave = JSON.stringify objectToSave
      JSONToSaveBase64 = btoa JSONToSave

      fileToSave = icoEditor.dataset.currentFile
      $(".file-cell[data-name=#{fileToSave}]")[0].dataset?.content = JSONToSaveBase64
      resolve()


  @_importFromObject: (object) =>
    icoNodes = []

    for child in object
      for key, value of child
        newIcoNodeElement = new @IcoNode.icoNodeDom()
        newIcoNodeElement.innerHTML = key
        newChild = @_importFromObject(value)
        newIcoNodeElement.classList = @IcoNode.hasIcoChildClass if newChild
        newIcoNodeElement.appendChild(element) for element in newChild
        icoNodes.push newIcoNodeElement

    icoNodes


  @_exportDomTreeToObject: (parent) =>
    currentTreeLayer = []

    for element in parent.childNodes

      if element instanceof @IcoNode.icoNodeDom
        childObject = @_exportDomTreeToObject element
        elementText = element.innerText.split('\n')[0]
        currentTreeLayer.push {"#{elementText}": childObject}

    currentTreeLayer

    