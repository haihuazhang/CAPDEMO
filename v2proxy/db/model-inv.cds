namespace INV;

using {
  MST.D005_SUPPLIER as SUPPLIER,
  MST.D004_LOCATION as LOCATION,
  MST.D002_PLANT as PLANT,
  MST.D001_MATERIAL as MATERIAL
} from '../db/model-mst';


using {
  PCH.D001_PO_H as PCH_D001,
  PCH.D002_PO_D as PCH_D002,
  PCH.D005_RECEIVE_D as PCH_D005,
} from '../db/model-pch';

using {
  TYPE.COMMON_POST_FILED as COMMON_POST_FILED,
  TYPE.COMMON_CUID_FILED as COMMON_CUID_FILED
} from '../db/model-type';

using {cuid} from '@sap/cds/common';

entity D001_T : COMMON_CUID_FILED, cuid { //现品票管理表
  @title : '{i18n>T_NO}' T_NO                           : String(15); //现品票号码
  @title : '{i18n>PLANT_ID}' PLANT_ID                   : String(4); //工厂
  @title : '{i18n>MATERIAL_ID}' MATERIAL_ID             : String(20); //品号
  @title : '{i18n>MATERIAL_NAME}' MATERIAL_NAME         : String(5);
  @title : '{i18n>MATERIAL_MEINS}' MATERIAL_MEINS       : String(5); //单位
  @title : '{i18n>QTY}' QTY                             : Decimal(13, 3); //现品数量
  @title : '{i18n>SUPPLIER_BATCH_NO}' SUPPLIER_BATCH_NO : String(30); //供应商序列号
  @title : '{i18n>SUPPLIER_ID}' SUPPLIER_ID             : String(20); //供应商编号
  @title : '{i18n>DEV_NO}' DEV_NO                       : String(30); //納入番号
  @title : '{i18n>DEV_S_NO}' DEV_S_NO                   : String(5); //行番号
  @title : '{i18n>SIMP_INFO}' SIMP_INFO                 : String(200); //便情報
  @title : '{i18n>STATUS}' STATUS                       : String(20); //现品票状态
  @title : '{i18n>REASON}' REASON                       : String(20); //发行理由
  @title : '{i18n>PCH_D002_ID}' PCH_D002_ID             : String(36); //采购明细ID
  @title : '{i18n>PO_NO}' PO_NO                         : String(12); //采购订单编号
  @title : '{i18n>PO_D_NO}' PO_D_NO                     : String(4); //采购订单明细行号
  @title : '{i18n>MNF_D001_ID}' MNF_D001_ID             : String(36); //工单头ID
  @title : '{i18n>CO_NO}' CO_NO                         : String(12); //工单编号
  @title : '{i18n>PCH_D005_ID}' PCH_D005_ID             : String(36); //采购入庫伝票明细ID
  @title : '{i18n>RECEIVE_NO}' RECEIVE_NO               : String(20); //采购入庫编号
  @title : '{i18n>RECEIVE_D_NO}' RECEIVE_D_NO           : String(4); //采购入庫明细行号
  @title : '{i18n>F_T_NO}' F_T_NO                       : String(15); //父现品票号
  @title : '{i18n>OCCY_TYPE}' OCCY_TYPE                 : String(20); //占用单据类型
  @title : '{i18n>OCCY_ID}' OCCY_ID                     : String(36); //占用单据明细ID
  @title : '{i18n>OCCY_NO}' OCCY_NO                     : String(20); //占用单据号
  @title : '{i18n>LOC_CODE}' LOC_CODE                   : String(4); //所在仓库
  @title : '{i18n>IN_A_DATE}' IN_A_DATE                 : Date; //入库账期
  @title : '{i18n>IN_D_DATE}' IN_D_DATE                 : Date; //入库日
  @title : '{i18n>OUT_A_DATE}' OUT_A_DATE               : Date; //出库账期
  @title : '{i18n>OUT_D_DATE}' OUT_D_DATE               : Date; //出库日
  @title : '{i18n>SER_NO}' SER_NO                       : String(20); //序列号
  @title : '{i18n>ORIGINAL_T_NO}' ORIGINAL_T_NO         : String(15); //原始现品票号
  // CUID_INFO                                             : COMMON_CUID_FILED; //修改基本信息

  @title : '{i18n>REMARK}'
  REMARK                                                : String(40);
  TO_PCH_D005                                           : Association to one PCH_D005
                                                            on TO_PCH_D005.ID = PCH_D005_ID; //入荷明细
  TO_MATERIAL                                           : Association to one MATERIAL
                                                            on TO_MATERIAL.MATERIAL_ID = MATERIAL_ID;
  TO_LOCATION                                           : Association to one LOCATION
                                                            on  TO_LOCATION.PLANT_ID    = PLANT_ID
                                                            and TO_LOCATION.LOCATION_ID = LOC_CODE;
  TO_SUPPLIER                                           : Association to one SUPPLIER
                                                            on TO_SUPPLIER.SUPPLIER_ID = SUPPLIER_ID;

}


entity D002_STK : COMMON_CUID_FILED { //库存管理主表(当前实际、实物 在库)
  @title : '{i18n>PLANT_ID}' key PLANT_ID               : String(4); //工厂
  @title : '{i18n>MATERIAL_ID}' key MATERIAL_ID         : String(20); //物料编号
  @title : '{i18n>STK_STATUS}' key STK_STATUS           : String(20); //库存状态
  @title : '{i18n>STK_FLAG}' key STK_FLAG               : String(1); //特殊库存标记
  @title : '{i18n>STK_FLAG_REMARK}' key STK_FLAG_REMARK : String(30); //特殊库存标记信息
  @title : '{i18n>STK_LOCATION}' key STK_LOCATION       : String(4); //库存保管场所
  @title : '{i18n>STK_QTY}' STK_QTY                     : Decimal(13, 3) default 0; //库存数量
  @title : '{i18n>L_D_DATE}' L_D_DATE                   : Date; //最新的凭证日期
  @title : '{i18n>L_A_DATE}' L_A_DATE                   : Date; //最新的记账日期
// CUID_INFO                                             : COMMON_CUID_FILED; //修改基本信息
}
entity D003_STK_ACC : COMMON_CUID_FILED { //历史库存表 (按照记账日期)
  @title : '{i18n>ACC_DATE}' key ACC_DATE               : Date; //记账日期
  @title : '{i18n>PLANT_ID}' key PLANT_ID               : String(4); //工厂
  @title : '{i18n>MATERIAL_ID}' key MATERIAL_ID         : String(20); //物料编号
  @title : '{i18n>STK_STATUS}' key STK_STATUS           : String(20); //库存状态
  @title : '{i18n>STK_FLAG}' key STK_FLAG               : String(1); //特殊库存标记
  @title : '{i18n>STK_FLAG_REMARK}' key STK_FLAG_REMARK : String(20); //特殊库存标记信息
  @title : '{i18n>STK_LOCATION}' key STK_LOCATION       : String(4); //库存保管场所
  @title : '{i18n>STK_QTY}' STK_QTY                     : Decimal(13, 3) default 0; //库存数量
// CUID_INFO                                             : COMMON_CUID_FILED; //修改基本信息
}
entity D004_STK_DOC : COMMON_CUID_FILED { //历史库存表 (按照凭证日期)
  @title : '{i18n>DOC_DATE}' key DOC_DATE               : Date; //凭证日期
  @title : '{i18n>PLANT_ID}' key PLANT_ID               : String(4); //工厂
  @title : '{i18n>MATERIAL_ID}' key MATERIAL_ID         : String(20); //物料编号
  @title : '{i18n>STK_STATUS}' key STK_STATUS           : String(20); //库存状态
  @title : '{i18n>STK_FLAG}' key STK_FLAG               : String(1); //特殊库存标记
  @title : '{i18n>STK_FLAG_REMARK}' key STK_FLAG_REMARK : String(20); //特殊库存标记信息
  @title : '{i18n>STK_LOCATION}' key STK_LOCATION       : String(4); //库存保管场所
  @title : '{i18n>STK_QTY}' STK_QTY                     : Decimal(13, 3) default 0; //库存数量
// CUID_INFO                                             : COMMON_CUID_FILED; //修改基本信息
}
entity D005_STK_LOG_H : cuid, COMMON_CUID_FILED { //在库增减履历(MB51）
  @title : '{i18n>RELA_ID}' RELA_ID           : String(36); //关联ID,关联各个业务明细表
  @title : '{i18n>MMSS_NO}' MMSS_NO           : String(25); //关联各个业务传票号码
  @title : '{i18n>MMSS_D_NO}' MMSS_D_NO       : String(6); //关联各个业务传票号码
  @title : '{i18n>TYPE}' TYPE                 : String(20); //过账、取消标记：
  @title : '{i18n>PLANT_ID}' PLANT_ID         : String(20); //工厂
  @title : '{i18n>TRANS_CODE}' TRANS_CODE     : String(5); //移动类型
  @title : '{i18n>PO_NO}' PO_NO               : String(12); //采购订单编号
  @title : '{i18n>PO_D_NO}' PO_D_NO           : String(6); //采购订单明细行号
  @title : '{i18n>CO_NO}' CO_NO               : String(12); //工单编号
  @title : '{i18n>CO_D_NO}' CO_D_NO           : String(6); //工单行号
  @title : '{i18n>DN_NO}' DN_NO               : String(12); //DN单号
  @title : '{i18n>DN_D_NO}' DN_D_NO           : String(6); //DN行号
  @title : '{i18n>SAP_DOC}' SAP_DOC           : String(12); //SAP物料凭证号-行号
  @title : '{i18n>SAP_DOC_D_NO}' SAP_DOC_D_NO : String(6); //SAP物料凭证行号
  @title : '{i18n>SAP_DOC_YEAR}' SAP_DOC_YEAR : String(4); //SAP物料凭证年度
  @title : '{i18n>DOC_DATE}' DOC_DATE         : Date; //凭证日期
  @title : '{i18n>ACCOUNT_DATE}' ACCOUNT_DATE : Date; //过账日期
  @title : '{i18n>COST}' COST                 : String(15); //成本中心
  @title : '{i18n>REASON}' REASON             : String(40); //移动理由
  @title : '{i18n>HEAD_REMARK}' HEAD_REMARK   : String(1000); //抬头备注
  @title : '{i18n>D_REMARK}' D_REMARK         : String(200); //明细备注
// CUID_INFO                                   : COMMON_CUID_FILED; //修改基本信息
}
entity D006_STK_LOG_D : cuid { //在库增减履历(MB51-明细）
  @title : '{i18n>INV_D005_ID}' INV_D005_ID         : String(36); //关联ID,关联各个业务明细表
  @title : '{i18n>TYPE}' TYPE                       : String(1); //入、出库标记。
  @title : '{i18n>PLANT_ID}' PLANT_ID               : String(4); //工厂
  @title : '{i18n>MATERIAL_ID}' MATERIAL_ID         : String(20); //物料
  @title : '{i18n>STK_STATUS}' STK_STATUS           : String(20); //状态
  @title : '{i18n>STK_FLAG}' STK_FLAG               : String(1); //库存标记
  @title : '{i18n>STK_LOCATION}' STK_LOCATION       : String(4); //保管场所
  @title : '{i18n>STK_FLAG_REMARK}' STK_FLAG_REMARK : String(30); //特殊库存单号
  @title : '{i18n>STK_SEQ}' STK_SEQ                 : String(20); //序列号
  @title : '{i18n>QTY}' QTY                         : Decimal(13, 3); //数量
  @title : '{i18n>T_NO}' T_NO                       : String(15); //现品票号码
}




