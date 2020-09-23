sap.ui.define(
  ["mmss/PCH04/controller/BaseController", "sap/ui/core/Fragment"],
  function (Controller, Fragment) {
    "use strict";

    return Controller.extend("mmss.PCH04.controller.Main", {
      onInit: function () {
        // Message Init
        var oMessageManager = sap.ui.getCore().getMessageManager();
        this.getView().setModel(oMessageManager.getMessageModel(), "message");
        oMessageManager.registerObject(this.getView(), true);

        this.getModel("localModel").setProperty("/editable", true);

        this.getRouter()
          .getRoute("Edit")
          .attachPatternMatched(this._onObjectMatched, this);
        this.getRouter()
          .getRoute("New")
          .attachPatternMatched(this._onObjectMatched, this);
      },
      _onObjectMatched: function (oEvent) {
        //设置Deferred Group.
        this.getModel().setDeferredGroups([
          "createEntry",
          "changes",
          "draftFunction",
        ]);
        //获取路由名称
        var sRouteName = oEvent.getParameter("name");
        var that = this;
        this.setBusy(true);

        this.getModel()
          .metadataLoaded()
          .then(() => {
            //判断更新或新建
            if (sRouteName === "Edit") {
              //更新
              var ID = "4b7d69cc-8ac5-4a96-9e02-d78732e33452";
              var IsActiveEntity = true;

              //根据ID检查是否有草稿
              this.readReceiveHead(ID).then((oData) => {
                oData.results.forEach(function (result) {
                  if (result.IsActiveEntity === false) {
                    IsActiveEntity = result.IsActiveEntity;
                  }
                });
                that.handleNewContext(
                  that.getModel().createKey("/ReceiveHead", {
                    ID: ID,
                    IsActiveEntity: IsActiveEntity,
                  })
                );
                // Active版本是显示状态
                if (IsActiveEntity) {
                  this.setObjectEditable(false);
                }
                // this.setBusy(false);
              });
            } else {
              //新建
              var newHeaderContext = this.getModel().createEntry(
                "/ReceiveHead",
                {
                  properties: {
                    REH_DATE: new Date(),
                  },
                  groupId: "createEntry",
                }
              );
              this.getView().setBindingContext(newHeaderContext);

              // 更新抬头draft
              this.getModel().submitChanges({
                groupId: "createEntry",
              });
              this.setBusy(false);
            }
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
        //新增行定位...
      },
      /**
       * 删除选中行
       * @param {}} oEvent
       */
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
        this.byId("ReceiveItemTable").clearSelection();
      },
      handleItemCopyPress: function (oEvent) {
        var that = this;
        var selectedIndices = this.byId(
          "ReceiveItemTable"
        ).getSelectedIndices(); // 获取选中行
        var oHeaderContext = this.getView().getBindingContext();
        selectedIndices.forEach((index) => {
          var copyContext = that
            .byId("ReceiveItemTable")
            .getContextByIndex(index);
          var copyData = copyContext.getObject();

          // copyContext
          var newItemContext = that.getModel().createEntry("TO_ITEMS", {
            context: oHeaderContext,
            groupId: "createEntry",
            properties: {
              PCH_D002_ID: copyData.PCH_D002_ID,
              MATERIAL_ID: copyData.MATERIAL_ID,
              PLANT_ID: copyData.PLANT_ID,
              RECE_D_LOCATION: copyData.RECE_D_LOCATION,
              RED_CTN_QTY: copyData.RED_CTN_QTY,
              RED_QTY: copyData.RED_QTY,
              RED_UNIT: copyData.RED_UNIT,
              REMARK: copyData.REMARK,
              SIMP_INFO: copyData.SIMP_INFO,
              SUPPLIER_BATCH_NO: copyData.SUPPLIER_BATCH_NO,
            },
          });
        });
        this.getModel().submitChanges({
          groupId: "createEntry",
        });
        this.byId("ReceiveItemTable").clearSelection();
      },

      handleInvCreatePress: function (oEvent) {
        // 获取采购入库明细表行
        var oItemContext = this._oInvDialog.getBindingContext();

        var SUPPLIER_ID = this.getModel().getProperty(
          oItemContext.getPath() + "/TO_POITEM/TO_HEAD/SUPPLIER_ID"
        );
        var PO_NO = this.getModel().getProperty(
          oItemContext.getPath() + "/TO_POITEM/TO_HEAD/PO_NO"
        );
        var PO_D_NO = this.getModel().getProperty(
          oItemContext.getPath() + "/TO_POITEM/D_NO"
        );
        // var RECEIVE_NO = this.getModel().getProperty(oItemContext.getPath() + "/TO_HEAD")
        // var RECEIVE_D_NO =

        var oItemData = oItemContext.getObject();
        var newInvContext = this.getModel().createEntry("TO_INVS", {
          context: oItemContext,
          groupId: "createEntry",
          properties: {
            PLANT_ID: oItemData.PLANT_ID,
            MATERIAL_ID: oItemData.MATERIAL_ID,
            MATERIAL_MEINS: oItemData.RED_UNIT,
            QTY: oItemData.RED_CTN_QTY,
            SUPPLIER_BATCH_NO: oItemData.SUPPLIER_BATCH_NO,
            SUPPLIER_ID: SUPPLIER_ID,
            DEV_NO: oItemData.DEV_NO,
            DEV_S_NO: oItemData.DEV_S_NO,
            SIMP_INFO: oItemData.SIMP_INFO,
            PCH_D002_ID: oItemData.PCH_D002_ID,
            PO_NO: PO_NO,
            PO_D_NO: PO_D_NO,
            RECEIVE_NO: "",
            RECEIVE_D_NO: oItemData.D_NO,
          },
        });
        this.getModel().submitChanges({
          groupId: "createEntry",
        });
      },

      handleInvDeletePress: function (oEvent) {
        var that = this;
        var selectedIndices = this.byId("InvDialogTable").getSelectedIndices(); // 获取选中行
        selectedIndices.forEach((index) => {
          var deleteContext = this.byId("InvDialogTable").getContextByIndex(
            index
          );
          that.getModel().remove(deleteContext.getPath());
        });
        this.byId("InvDialogTable").clearSelection();
      },

      readReceiveHead: function (ID) {
        var that = this;
        return new Promise(function (resolve, reject) {
          that.getModel().read("/ReceiveHead", {
            filters: [
              new sap.ui.model.Filter({
                path: "ID",
                value1: ID,
                operator: sap.ui.model.FilterOperator.EQ,
              }),
            ],
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

            // 获取新Key
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
       * 退出时检查是否为草稿状态
       * 删除当前草稿
       */
      onExit: function () {
        if (this.checkIsDraft()) {
          this.deleteDrafts();
        }
      },

      /**
       * 检查是否为草稿
       */
      checkIsDraft: function () {
        return (IsActiveEntity = this.getView().getBindingContext().getObject()
          .IsActiveEntity);
      },
      /**
       * 删除草稿(ReceiveHead + ReceiveDetail)
       */
      deleteDrafts: function () {
        //删除抬头草稿
        var sHeaderPath = this.getView().getBindingContext().getPath();
        this.getModel().remove(sHeaderPath);

        // 获取明细行草稿
        var that = this;
        var rows = this.byid("ReceiveItemTable").getRows();
        rows.forEach((row) => {
          //删除明细草稿
          that.getModel().remove(row.getBindingContext().getPath());
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
        var that = this;
        this.getView().bindElement({
          path: sPath,
          parameters: {
            expand:
              "TO_ITEMS,TO_ITEMS/TO_MATERIAL,TO_ITEMS/TO_POITEM,TO_ITEMS/TO_PLANT,TO_ITEMS/TO_LOCATION,TO_ITEMS/TO_POITEM/TO_HEAD,TO_ITEMS/TO_POITEM/TO_HEAD/TO_SUPPLIER",
          },
          events: {
            dataReceived: function () {
              that.setBusy(false);
              that.byId("InvSmartTable").rebindTable();
            },
          },
        });
      },

      setBusy: function (isBusy) {
        this.getModel("localModel").setProperty("/isBusy", isBusy);
      },
      setObjectEditable: function (isEditable) {
        this.getModel("localModel").setProperty("/editable", isEditable);
      },
      /**
       * 消息按钮点击事件
       * @param {} oEvent
       */
      onMessagePopoverPress: function (oEvent) {
        this._getMessagePopover().openBy(oEvent.getSource());
      },
      /**
       * 获得消息栏
       */
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
      /**
       * 消息栏title点击后定位至错误控件事件
       * @param {*} oEvent
       */
      _activeTitlePress: function (oEvent) {
        var oItem = oEvent.getParameter("item"),
          oMessage = oItem.getBindingContext("message").getObject(),
          oControl = sap.ui.getCore().byId(oMessage.getControlId());
        if (oControl && oControl.getDomRef()) {
          oControl.focus();
        } else {
          var sSectionTitle = oItem.getGroupName().split("-")[0];
          _navigateFromMessageToSectionInIconTabBarMode(
            this.oObjectPageLayout,
            sSectionTitle
          );
          oControl.focus();
        }
      },
      onEditInvPress: function (oEvent) {
        var sReceiveDetailPath = oEvent
          .getParameter("item")
          .getBindingContext()
          .getPath();

        var that = this;
        if (!this._oInvDialog) {
          Fragment.load({
            id: this.getView().getId(),
            name: "mmss.PCH04.view.InvDialog",
            controller: this,
          }).then(function (oDialog) {
            that._oInvDialog = oDialog;
            oDialog.bindElement(sReceiveDetailPath);
            that.getView().addDependent(oDialog);
            oDialog.open();
          });
        } else {
          this._oInvDialog.bindElement(sReceiveDetailPath);
          this._oInvDialog.open();
        }
      },

      onInvDialogCloseBTNPress: function () {
        this._oInvDialog.close();
      },

      beforeInvTRebind: function (oEvent) {
        var oHeaderContext = this.getView().getBindingContext();

        var bindingParams = oEvent.getParameter("bindingParams");
        bindingParams.filters.push(
          new sap.ui.model.Filter({
            path: "TO_PCH_D005/TO_HEAD/ID",
            value1: oHeaderContext.getObject().ID,
            operator: sap.ui.model.FilterOperator.EQ,
          })
        );
        bindingParams.filters.push(
          new sap.ui.model.Filter({
            path: "TO_PCH_D005/TO_HEAD/IsActiveEntity",
            value1: oHeaderContext.getObject().IsActiveEntity,
            operator: sap.ui.model.FilterOperator.EQ,
          })
        );
        bindingParams.parameters.expand =
          "TO_PCH_D005,TO_MATERIAL,TO_LOCATION,TO_SUPPLIER";
      },
    });
  }
);
