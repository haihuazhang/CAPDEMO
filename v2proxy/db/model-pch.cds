namespace PCH;

using {
  MST.D005_SUPPLIER as SUPPLIER,
  MST.D004_LOCATION as LOCATION,
  MST.D002_PLANT as PLANT,
  MST.D001_MATERIAL as MATERIAL
} from '../db/model-mst';

using {
  TYPE.COMMON_POST_FILED as COMMON_POST_FILED,
  TYPE.COMMON_CUID_FILED as COMMON_CUID_FILED
} from '../db/model-type';

using {INV.D001_T as INV_T, } from '../db/model-inv';
using {cuid} from '@sap/cds/common';


@title : '{i18n>D001_PO_H}'
entity D001_PO_H : cuid, COMMON_CUID_FILED { //采购订单抬头
  // key ID          : UUID; //KEY
  // @title: '{i18n>}'
  @title : '{i18n>PO_NO}'
  PO_NO         : String(12); //采购订单编号
  @title : '{i18n>SUPPLIER_ID}'
  SUPPLIER_ID   : String(20); //供应商编号
  @title : '{i18n>PO_DATE}'
  PO_DATE       : Date; //発注日
  @title : '{i18n>PO_STATUS}'
  PO_STATUS     : String(20); //采购订单状态
  @title : '{i18n>PO_BUKRS}'
  PO_BUKRS      : String(4); //公司代码
  @title : '{i18n>PO_LOEKZ}'
  PO_LOEKZ      : String(4); //删除标识
  @title : '{i18n>SIMP_INFO}'
  SIMP_INFO     : String(12); //便情報
  @title : '{i18n>PO_ORG}'
  PO_ORG        : String(4); //采购组织
  @title : '{i18n>PO_GROUP}'
  PO_GROUP      : String(3); //采购组
  @title : '{i18n>PO_TYPE}'
  PO_TYPE       : String(10); //采购订单类型

  @title : '{i18n>REMARK}'
  REMARK        : String(1000); //抬头备注

  // CUID_INFO     : COMMON_CUID_FILED; //修改基本信息

  TO_ITEMS      : Composition of many D002_PO_D
                    on TO_ITEMS.PCH_D001_ID = ID; //PO行ITEM信息

  TO_COMPONENTS : Composition of many D003_PO_BOM
                    on TO_COMPONENTS.PCH_D001_ID = ID; //PO组件信息

  TO_SUPPLIER   : Association to one SUPPLIER
                    on TO_SUPPLIER.SUPPLIER_ID = SUPPLIER_ID; //供应商关联信息

// to_language_text : Association to one Countries on to_language_text.code = SUPPLIER_ID;
}

@title : '{i18n>D002_PO_D}'
entity D002_PO_D : cuid, COMMON_CUID_FILED { //采购订单明细表
  // key ID                 : UUID; //采购订单明细表UID
  @title : '{i18n>PCH_D001_ID}'
  PCH_D001_ID                                               : String(36) not null; //采购订单主表UID
  @title : '{i18n>PO_D_NO}'
  D_NO                                                      : String(6) not null; //采购订单明细行号
  @title : '{i18n>MATERIAL_ID}'
  MATERIAL_ID                                               : String(20); //物料编号
  @title : '{i18n>PO_D_TXZ01}'
  PO_D_TXZ01                                                : String(120); //物料名称
  @title : '{i18n>PO_D_QTY}'
  PO_D_QTY                                                  : Decimal(13, 3); //采购数量
  @title : '{i18n>PO_REC_QTY}'
  PO_REC_QTY                                                : Decimal(13, 3) default 0; //已入库数量
  @title : '{i18n>PO_REC_POST_QTY}'
  PO_REC_POST_QTY                                           : Decimal(13, 3) default 0; //已入库发送数量
  @title : '{i18n>PO_GR_V_QTY}'
  PO_GR_V_QTY                                               : Decimal(13, 3) default 0; //122退货发送数量
  @title : '{i18n>PO_GR_V_POST_QTY}'
  PO_GR_V_POST_QTY                                          : Decimal(13, 3) default 0; //122退货发送数量(已过账)
  @title : '{i18n>PO_D_UNIT}'
  PO_D_UNIT                                                 : String(10); //单位
  @title : '{i18n>PO_D_STATUS}'
  PO_D_STATUS                                               : String(20); //PO明细状态
  @title : '{i18n>PO_D_DELIVERY_DATE}'
  PO_D_DELIVERY_DATE                                        : String(10); //指定纳期
  @title : '{i18n>PO_D_LOEKZ}'
  PO_D_LOEKZ                                                : String(1); //删除标识
  @title : '{i18n>PO_D_BUKRS}'
  PO_D_BUKRS                                                : String(4); //公司代码
  @title : '{i18n>PO_D_WERKS}'
  PO_D_WERKS                                                : String(4); //工厂
  @title : '{i18n>PO_D_LGORT}'
  PO_D_LGORT                                                : String(4); //库存地点
  @title : '{i18n>PO_D_RETPO}'
  PO_D_RETPO                                                : String(1); //退货标识
  @title : '{i18n>PO_D_ELIKZ}'
  PO_D_ELIKZ                                                : String(1); //交货已完成标识
  @title : '{i18n>PO_ARV_EXCESS_RATE}' PO_ARV_EXCESS_RATE   : Decimal(13, 3) default 0; //允许收货差异值-过剩纳入率
  @title : '{i18n>PO_ARV_INSU_RATE}' PO_ARV_INSU_RATE       : Decimal(13, 3) default 0; //允许收货差异值-不足纳入率
  @title : '{i18n>PO_ARV_EXCESS_VALUE}' PO_ARV_EXCESS_VALUE : Decimal(13, 3) default 0; //允许收货差异值-过剩纳入值
  @title : '{i18n>PO_ARV_INSU_VALUE}' PO_ARV_INSU_VALUE     : Decimal(13, 3) default 0; //允许收货差异值-不足纳入值
  @title : '{i18n>REMARK}'
  REMARK                                                    : String(1000); //备注

  TO_HEAD                                                   : Association to one D001_PO_H
                                                                on TO_HEAD.ID = PCH_D001_ID; //po头信息
  TO_COMPONENTS                                             : Composition of many D003_PO_BOM
                                                                on TO_COMPONENTS.PCH_D002_ID = ID;
  TO_PLANT                                                  : Association to one PLANT
                                                                on TO_PLANT.PLANT_ID = PO_D_WERKS;
  TO_LOCATION                                               : Association to one LOCATION
                                                                on  TO_LOCATION.PLANT_ID    = PO_D_WERKS
                                                                and TO_LOCATION.LOCATION_ID = PO_D_LGORT;
  TO_MATERIAL                                               : Association to MATERIAL
                                                                on TO_MATERIAL.MATERIAL_ID = MATERIAL_ID; // 物料组基本信息


}


@title : '{i18n>D003_PO_BOM}'
entity D003_PO_BOM : cuid, COMMON_CUID_FILED { //采购订单组件表
  // key ID                : UUID; //采购单组件ID
  @title : '{i18n>PCH_D001_ID}'
  PCH_D001_ID       : String(36); //采购订单主表UID （原则上不为空）
  @title : '{i18n>PCH_D002_ID}'
  PCH_D002_ID       : String(36) not null; //采购订单明细表UID
  @title : '{i18n>D003_PO_BOM_D_NO}'
  D_NO              : String(6) not null; //单据行号
  @title : '{i18n>PBOM_RSNUM}'
  PBOM_RSNUM        : String(10) not null; //PO预留号
  @title : '{i18n>PBOM_RSPOS}'
  PBOM_RSPOS        : String(5) not null; //PO预留行号
  @title : '{i18n>PBOM_RSART}'
  PBOM_RSART        : String(20); //记录类型
  @title : '{i18n>PBOM_QTY}'
  PBOM_QTY          : Decimal(13, 3); //采购单组件数量
  @title : '{i18n>MATERIAL_ID}'
  MATERIAL_ID       : String(20); //采购单组件物料
  @title : '{i18n>PBOM_UNIT}'
  PBOM_UNIT         : String(10); //采购单组件数量单位
  @title : '{i18n>PBOM_OUT_QTY}'
  PBOM_OUT_QTY      : Decimal(13, 3) default 0; //出库数量
  @title : '{i18n>PBOM_OUT_POST_QTY}'
  PBOM_OUT_POST_QTY : Decimal(13, 3) default 0; //出库发送数量
  @title : '{i18n>PBOM_RE_QTY}'
  PBOM_RE_QTY       : Decimal(13, 3) default 0; //返库数量
  @title : '{i18n>PBOM_RE_POST_QTY}'
  PBOM_RE_POST_QTY  : Decimal(13, 3) default 0; //返库发送成功数量
  @title : '{i18n>PBOM_LOCATION}'
  PBOM_LOCATION     : String(20); //组件保管场所
  @title : '{i18n>PBOM_LOEKZ}'
  PBOM_LOEKZ        : String(1); //删除标识
  @title : '{i18n>REMARK}'
  REMARK            : String(1000); //备注
  // @title : '{i18n>CUID_INFO}'
  // CUID_INFO         : COMMON_CUID_FILED; //修改基本信息
  @title : '{i18n>TO_ITEM}'
  TO_ITEM           : Association to one D002_PO_D
                        on TO_ITEM.ID = PCH_D002_ID;
  @title : '{i18n>TO_HEAD}'
  TO_HEAD           : Association to one D001_PO_H
                        on TO_HEAD.ID = PCH_D001_ID;
}

@title : '{i18n>D004_RECEIVE_H}'
entity D004_RECEIVE_H : cuid, COMMON_CUID_FILED { //采购入庫伝票头表
  @title : '{i18n>D004_RECEIVE_H_NO}'
  NO       : String(20); //入库单号
  @title : '{i18n>PLANT_ID}'
  PLANT_ID : String(4); //工厂
  @title : '{i18n>REH_DATE}'
  REH_DATE : Date; //入庫日
  @title : '{i18n>REMARK}'
  REMARK   : String(1000); //备注
  @title : '{i18n>EXT_DN}'
  EXT_DN   : String(16);

  // CUID_INFO : COMMON_CUID_FILED; //修改基本信息
  TO_PLANT : Association to one PLANT
               on TO_PLANT.PLANT_ID = PLANT_ID;
  TO_ITEMS : Composition of many D005_RECEIVE_D
               on TO_ITEMS.PCH_D004_ID = ID;
}

@title : '{i18n>D005_RECEIVE_D}'
entity D005_RECEIVE_D : cuid, COMMON_POST_FILED, COMMON_CUID_FILED { //采购入庫伝票明细表
  @title : '{i18n>PCH_D004_ID}'
  PCH_D004_ID       : String(36) not null; //入库主表ID
  @title : '{i18n>RECEIVE_D_NO}'
  D_NO              : String(6) not null; //入库单明细行号
  @title : '{i18n>PCH_D002_ID}'
  PCH_D002_ID       : String(36); //采购订单明细表UID
  @title : '{i18n>PLANT_ID}'
  PLANT_ID          : String(4); //重复存储工厂
  @title : '{i18n>MATERIAL_ID}'
  MATERIAL_ID       : String(20); //物料编号
  @title : '{i18n>RECE_D_LOCATION}'
  RECE_D_LOCATION   : String(4); //入库保管场所
  @title : '{i18n>SUPPLIER_BATCH_NO}'
  SUPPLIER_BATCH_NO : String(30); //供应商序列号
  @title : '{i18n>RED_QTY}'
  RED_QTY           : Decimal(13, 3) not null; //入库数量
  @title : '{i18n>RED_CTN_QTY}'
  RED_CTN_QTY       : Decimal(13, 3); //捆包数量
  @title : '{i18n>RED_UNIT}'
  RED_UNIT          : String(10);
  @title : '{i18n>RED_TP_S}'
  RED_TP_S          : String(15); //现品票号开始
  @title : '{i18n>RED_TP_F}'
  RED_TP_F          : String(15); //现品票号结束
  @title : '{i18n>RED_TP_NUM}'
  RED_TP_NUM        : Integer; //现品票张数
  @title : '{i18n>DEV_NO}'
  DEV_NO            : String(30); //納入番号
  @title : '{i18n>DEV_S_NO}'
  DEV_S_NO          : String(5); //行番号
  @title : '{i18n>REMARK}'
  REMARK            : String(200); //备注
  @title : '{i18n>SIMP_INFO}'
  SIMP_INFO         : String(12); //便情報

  //  POST_INFO         : COMMON_POST_FILED; //过账信息
  // CUID_INFO         : COMMON_CUID_FILED; //修改基本信息

  TO_HEAD           : Association to one D004_RECEIVE_H
                        on TO_HEAD.ID = PCH_D004_ID; //入库头部信息

  TO_LOCATION       : Association to one LOCATION
                        on  TO_LOCATION.PLANT_ID    = PLANT_ID
                        and TO_LOCATION.LOCATION_ID = RECE_D_LOCATION; //保管场所

  TO_MATERIAL       : Association to one MATERIAL
                        on TO_MATERIAL.MATERIAL_ID = MATERIAL_ID; // 物料组基本信息

  TO_PLANT          : Association to one PLANT
                        on TO_PLANT.PLANT_ID = PLANT_ID; //工厂信息

  TO_POITEM         : Association to one D002_PO_D
                        on TO_POITEM.ID = PCH_D002_ID; //采购明细

  TO_INVTS          : Composition of many INV_T
                        on TO_INVTS.PCH_D005_ID = ID; //入库明细生成的现品票信息

}


@title : '{i18n>D006_OUT_H}'
entity D006_OUT_H : cuid, COMMON_CUID_FILED { //購買発注入庫取消/返品発注出庫伝票

  @title : '{i18n>NO}'
  NO         : String(20); //入庫取消单号
  @title : '{i18n>PLANT_ID}'
  PLANT_ID   : String(4); //工厂
  @title : '{i18n>DOC_DATE}'
  DOC_DATE   : Date; //出库日期
  @title : '{i18n>TYPE}'
  TYPE       : String(1); //类型
  @title : '{i18n>REMARK}'
  REMARK     : String(1000); //备注

  TO_PLANT   : Association to one PLANT
                 on TO_PLANT.PLANT_ID = PLANT_ID;
  TO_DETAILS : Composition of many D007_OUT_D
                 on TO_DETAILS.PCH_D006_ID = ID;
}

@title : '{i18n>D007_OUT_D}'
entity D007_OUT_D : cuid, COMMON_POST_FILED, COMMON_CUID_FILED { //購買発注入庫取消/返品発注出庫伝票明细表

  @title : '{i18n>PCH_D006_ID}'
  PCH_D006_ID : String(36); //入库取消传票ID
  @title : '{i18n>D_NO}'
  D_NO        : String(6); //入库单明细行号
  @title : '{i18n>T_NO}'
  T_NO        : String(15); //现品票号码
  @title : '{i18n>PCH_D002_ID}'
  PCH_D002_ID : String(36); //采购订单明细表UID
  @title : '{i18n>PO_NO}'
  PO_NO       : String(12); //采购订单编号
  @title : '{i18n>PO_D_NO}'
  PO_D_NO     : String(4); //采购订单明细行号
  @title : '{i18n>QTY}'
  QTY         : Decimal(13, 3); //数量
  @title : '{i18n>MATERIAL_ID}'
  MATERIAL_ID : String(20); //物料编号
  @title : '{i18n>PLANT_ID}'
  PLANT_ID    : String(4); //工厂
  @title : '{i18n>LOCATION}'
  LOCATION    : String(4); //保管场所
  @title : '{i18n>REMARK}'
  REMARK      : String(200); //备注

  TO_HEAD     : Association to one D006_OUT_H
                  on TO_HEAD.ID = PCH_D006_ID; //头部信息

  TO_PLANT    : Association to one PLANT
                  on TO_PLANT.PLANT_ID = PLANT_ID;

  TO_LOCATION : Association to one LOCATION
                  on  TO_LOCATION.PLANT_ID    = PLANT_ID
                  and TO_LOCATION.LOCATION_ID = LOCATION; //保管场所

  TO_MATERIAL : Association to one MATERIAL
                  on TO_MATERIAL.MATERIAL_ID = MATERIAL_ID; // 物料组基本信息

  TO_POITEM   : Association to one D002_PO_D
                  on TO_POITEM.ID = PCH_D002_ID; //采购明细

  TO_INVT     : Composition of one INV_T
                  on TO_INVT.T_NO = T_NO; //现品票

}


entity D008_POST_HISTORY : cuid, COMMON_POST_FILED, COMMON_CUID_FILED {
  HEAD_ID : String(20);
  D_NO    : String(6);
}
