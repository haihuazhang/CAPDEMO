sap.ui.define(
  ["mmss/PCH04/controller/BaseController", "sap/ui/comp/smartfield/SmartField"],
  function (Controller, SmartField) {
    "use strict";

    return Controller.extend("mmss.PCH04.controller.Main", {
      onInit: function () {
        // Message Init
        var oMessageManager = sap.ui.getCore().getMessageManager();
        this.getView().setModel(oMessageManager.getMessageModel(), "message");
        oMessageManager.registerObject(this.getView(), true);

        this.getModel("localModel").setProperty("/editable", true);

        this.getRouter()
          .getRoute("Main")
          .attachPatternMatched(this._onObjectMatched, this);
      },
      _onObjectMatched: function (oEvent) {
        //设置Deferred Group.
        this.getModel().setDeferredGroups([
          "createEntry",
          "changes",
          "draftFunction",
        ]);

        this.getModel()
          .metadataLoaded()
          .then(() => {
            var newHeaderContext = this.getModel().createEntry("/ReceiveHead", {
              properties: {
                // PLANT_ID: "1234",
                REH_DATE: new Date(),
                // TO_ITEMS: [],
              },
              groupId: "createEntry",
            });
            this.getView().setBindingContext(newHeaderContext);

            // 更新抬头draft
            this.getModel().submitChanges({
              groupId: "createEntry",
            });
          });
      },
      onBeforeRendering: function () {},

      /**
       * 明细行新增
       * 新增明细行草稿
       * @param {*} oEvent
       */
      handleItemCreatePress: function (oEvent) {
        var oHeaderContext = this.getView().getBindingContext();
        var newItemContext = this.getModel().createEntry("TO_ITEMS", {
          context: oHeaderContext,
          groupId: "createEntry",
        });
        this.getModel().submitChanges({
          groupId: "createEntry",
        });

        // 新建Item明细
        // var oParentContext = this.getView().getBindingContext();
        // var newItemContext = this.getModel().createEntry("/ReceiveDetail", {
        //   context: oParentContext,
        // });
        // var itemPaths = this.getModel().getProperty("TO_ITEMS");
        // if (!itemPaths) {
        //   itemPaths = [];
        // }
        // itemPaths.push(newItemContext.getPath().substring(1));
        // this.getView()
        //   .getModel()
        //   .setProperty("TO_ITEMS", itemPaths, oParentContext);
        // // 新建模板
        // var newRow = new sap.m.ColumnListItem({
        //   type: sap.m.ListType.Inactive,
        //   unread: false,
        //   vAlign: "Middle",
        //   cells: [
        //     new SmartField({
        //       value: "{D_NO}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{PCH_D002_ID}",
        //       fetchValueListReadOnly: false,
        //     }),
        //     new SmartField({
        //       value: "{MATERIAL_ID}",
        //     }),
        //     new SmartField({
        //       value: "{TO_MATERIAL/MATERIAL_NAME}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{TO_MATERIAL/MATERIAL_BISMT}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{TO_POITEM/PO_D_QTY}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{RED_QTY}",
        //     }),
        //     new SmartField({
        //       value: "{RED_UNIT}",
        //     }),
        //     new SmartField({
        //       value: "{PLANT_ID}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{TO_PLANT/PLANT_NAME}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{RECE_D_LOCATION}",
        //     }),
        //     new SmartField({
        //       value: "{TO_LOCATION/LOCATION_NAME}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{SUPPLIER_BATCH_NO}",
        //     }),
        //     new SmartField({
        //       value: "{RED_CTN_QTY}",
        //     }),
        //     new SmartField({
        //       value: "{TO_POITEM/TO_HEAD/SUPPLIER_ID}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{TO_POITEM/TO_HEAD/TO_SUPPLIER/SUPPLIER_NAME1}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{POST_INFO_POST_STATUS}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{POST_INFO_POST_ACCOUNT_DATE}",
        //     }),
        //     new SmartField({
        //       value: "{POST_INFO_CANCEL_ACCOUNT_DATE}",
        //     }),
        //     new SmartField({
        //       value: "{POST_INFO_CANCEL_REASON}",
        //     }),
        //     new SmartField({
        //       value: "{DEV_NO}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{DEV_S_NO}",
        //       editable: false,
        //     }),
        //     new SmartField({
        //       value: "{REMARK}",
        //     }),
        //   ],
        // });
        // newRow.setBindingContext(newItemContext);
        // this.getView().byId("ReceiveItemTable").addItem(newRow);
      },
      handleItemDeletePress: function (oEvent) {
        var that = this;
        var selectedIndices = this.byId(
          "ReceiveItemTable"
        ).getSelectedIndices(); // 获取选中行
        selectedIndices.forEach((index) => {
          var deleteContext = this.byId("ReceiveItemTable").getContextByIndex(
            index
          );
          that.getModel().remove(deleteContext.getPath());
        });
      },

      /**
       * 保存当前页面数据
       */
      onSave: function () {
        // 保存当前页面更改
        var that = this;
        this.setBusy(true);
        this.entitySaveChanges()
          .then((oData) => {
            // draft激活
            console.log(oData);
            return that.callDraftActivate();
          })
          .then((result) => {
            console.log(result);
            //
            var sPath = that.getModel().createKey("/ReceiveHead", {
              ID: result.ID,
              IsActiveEntity: result.IsActiveEntity,
            });

            that.handleNewContext(sPath);

            that.setObjectEditable(false);
          })
          .catch((oError) => {
            console.log(oError);
          })
          .finally(() => {
            that.setBusy(false);
          });
      },

      onEdit: function () {
        //消除更改记录
        this.getModel().resetChanges();

        var that = this;
        this.setBusy(true);
        this.callDraftEdit()
          .then((oData) => {
            var sPath = that.getModel().createKey("/ReceiveHead", {
              ID: oData.ID,
              IsActiveEntity: oData.IsActiveEntity,
            });

            that.handleNewContext(sPath);

            that.setObjectEditable(true);
          })
          .catch((oError) => {
            console.log(oError);
          })
          .finally(() => {
            that.setBusy(false);
          });
      },

      /**
       * 保存页面变更数据
       * OData groupId : changes
       */
      entitySaveChanges: function () {
        var that = this;
        return new Promise(function (resolve, reject) {
          that.getModel().submitChanges({
            groupId: "changes",
            success: function (oData) {
              resolve(oData);
            },
            error: function (oError) {
              reject(oError);
            },
          });
        });
      },

      /**
       * 激活草稿
       */
      callDraftActivate: function () {
        var that = this;
        var sHeaderObject = this.getView().getBindingContext().getObject();
        return new Promise(function (resolve, reject) {
          that.getModel().callFunction("/ReceiveHead_draftActivate", {
            urlParameters: {
              ID: sHeaderObject.ID,
              IsActiveEntity: sHeaderObject.IsActiveEntity,
            },
            method: "POST",
            success: function (oData) {
              resolve(oData);
            },
            error: function (oError) {
              reject(oError);
            },
          });
        });
      },

      /**
       * 编辑生效版本并生成新版本草稿
       */
      callDraftEdit: function () {
        var that = this;
        var sHeaderObject = this.getView().getBindingContext().getObject();
        return new Promise(function (resolve, reject) {
          that.getModel().callFunction("/ReceiveHead_draftEdit", {
            urlParameters: {
              ID: sHeaderObject.ID,
              IsActiveEntity: sHeaderObject.IsActiveEntity,
            },
            method: "POST",
            success: function (oData) {
              resolve(oData);
            },
            error: function (oError) {
              reject(oError);
            },
          });
        });
      },

      /**
       *  重新绑定新版本数据
       *  1) 草稿激活后生成的新版本数据
       *  2) 生效版本编辑后生成的新草稿数据
       */
      handleNewContext: function (sPath) {
        // var newContext = this.getModel().createBindingContext(sPath);

        // this.getView().setBindingContext(newContext);
        this.getView().bindElement(sPath);
      },

      setBusy: function (isBusy) {
        this.getModel("localModel").setProperty("/isBusy", isBusy);
      },
      setObjectEditable: function (isEditable) {
        this.getModel("localModel").setProperty("/editable", isEditable);
      },
      onMessagePopoverPress: function (oEvent) {
        this._getMessagePopover().openBy(oEvent.getSource());
      },
      _getMessagePopover: function () {
        // create popover lazily (singleton)
        if (!this._oMessagePopover) {
          // create popover lazily (singleton)
          this._oMessagePopover = sap.ui.xmlfragment(
            this.getView().getId(),
            "mmss.PCH04.view.MessagePopover",
            this
          );
          this.getView().addDependent(this._oMessagePopover);
        }
        return this._oMessagePopover;
      },
    });
  }
);
