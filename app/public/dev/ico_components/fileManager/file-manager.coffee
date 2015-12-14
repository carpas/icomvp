{KEYBOARD_CODES} = window.constants


class FileManager

  @fileManagerElement: "file-manager"
  @addFileButtonID: "#add-file-button"

  @_newFileCellName_default: ""
  @_newFileCellContent_default: "W3siTm92byI6W119XQ=="


  @init: =>
    @fileManagerDom = document.registerElement @fileManagerElement
    @_setEventListeners()

    importContentEvent = window.pubsubEvents.importContent
    PubSub.subscribe importContentEvent, (msg, files) =>
      @_importFiles files


  @_importFiles: (files) =>
    $fileManagerContent = $("file-manager .content")
    $fileManagerContent.empty()

    for file in files
      newFileCellHtml = @_newFileCellElement file.fileName, file.content
      $fileManagerContent.append newFileCellHtml
      Loader.turnOff()

    @_changeCurrentFile $fileManagerContent[0].firstChild.firstChild


  @_setEventListeners: =>
    $(document).on 'click', '.file-cell', (event) =>
      target = event.target
      @_changeCurrentFile target

    $(document).on 'click', '#add-file-button', (event) =>
      @_onAddNewFileClick()

    $(document).on 'click', '#delete-file-cell', (event) =>
      @_onDeleteFileClick event.target


  @_changeCurrentFile: (newFileCellElement) =>
    selectedFileContent = newFileCellElement.dataset.content
    selectedFileName = newFileCellElement.dataset.name

    window.location.hash = selectedFileName

    eventToPublish = window.pubsubEvents.changeFile
    PubSub.publish eventToPublish, {newContent: selectedFileContent, newFileName: selectedFileName}


  @_onAddNewFileClick: =>
    $fileManagerContent = $("file-manager .content")

    newFileCellHtml = @_newFileCellElement @_newFileCellName_default, @_newFileCellContent_default
    $fileManagerContent.append newFileCellHtml
    @_changeFileName $fileManagerContent[0]
    

  @_newFileCellElement: (name, content) =>
    newFileCellTemplate = Handlebars.compile($('#file-cell-wrapper-template').html())
    newFileElement = newFileCellTemplate {name, content}

    newFileElement


  @_onDeleteFileClick: (target) =>
    fileToDelete = $(target).closest("button")[0].dataset.fileToDelete
    fileCellWrapperToDelete = $(".file-cell-wrapper[data-name='#{fileToDelete}']")[0]

    fileCellWrapperToDeleteParent = fileCellWrapperToDelete.parentNode
    fileCellWrapperToDeleteParent.removeChild(fileCellWrapperToDelete) if fileCellWrapperToDeleteParent.children.length > 1

    @_changeCurrentOpenFileWithoutSaving fileCellWrapperToDeleteParent.firstChild


  @_changeCurrentOpenFileWithoutSaving: (newFileWrapper) =>
    newFile = newFileWrapper.firstChild

    {name, content} = newFile.dataset

    newFileName = name
    newContent = content

    window.location.hash = newFileName

    eventToPublish = window.pubsubEvents.changeFileWithoutSaving
    PubSub.publish eventToPublish, {newFileName, newContent}


  @_changeFileName: (fileCell) =>
    fileNameElement = fileCell.lastChild.firstChild
    fileNameElement.contentEditable = true
    fileNameElement.focus()

    $(document).on "keypress", (event) =>

      pressedKey = event.keyCode

      switch pressedKey
        when KEYBOARD_CODES.enter

          fileName = fileNameElement.innerHTML
          if @_isValidFileName fileName
            fileNameElement.contentEditable = false
            fileNameElement.dataset.name = fileName

            parent = fileNameElement.parentNode
            parent.dataset.name = fileName

            deleteButton = parent.lastChild
            deleteButton.dataset.fileToDelete = fileName

            $(document).off "keypress"

          else 
            return false

        when KEYBOARD_CODES.spaceBar
          return false


  @_isValidFileName: (fileName) =>
    fileName isnt "" and fileName.split(" ").length = 1

