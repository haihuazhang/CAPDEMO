sap.ui.define([
  "sap/ui/test/Opa5",
  "mmss/PCH04/test/integration/arrangements/Startup",
  "mmss/PCH04/test/integration/BasicJourney"
], function(Opa5, Startup) {
  "use strict";

  Opa5.extendConfig({
    arrangements: new Startup(),
    pollingInterval: 1
  });

});
