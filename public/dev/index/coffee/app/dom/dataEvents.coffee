class DataEvents

  @init: =>
    @_dataToggle()


  @_dataToggle: =>
    $(document).on 'click', '[data-toggle]', (event) =>

      targetButton = $(event.target).closest('[data-toggle]')[0]
      elementToToggle = targetButton.dataset.toggle
      $("\##{elementToToggle}").toggleClass window.cssClass.isActive