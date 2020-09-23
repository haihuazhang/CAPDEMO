sap.ui.define(["sap/ui/core/mvc/Controller"], function (Controller) {
  "use strict";

  return Controller.extend("mmss.PCH04.controller.App", {
    onInit: function () {
      this.getView().addStyleClass("sapUiSizeCompact");
    }
  });
});
