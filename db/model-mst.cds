using {
  cuid,
  managed
} from '@sap/cds/common';


context MST {


  @title : '{i18n>D001_MATERIAL}'
  entity D001_MATERIAL {
        @title : '{i18n>MATERIAL_ID}'
    key MATERIAL_ID         : String(21); //物料编号
        @title : '{i18n>MATERIAL_UNIT}'
        MATERIAL_UNIT       : String(20); //物料基本单位
        @title : '{i18n>MATERIAL_MEINS}'
        MATERIAL_MEINS      : String(5); //物料单位
        @title : '{i18n>MATERIAL_STYLE}'
        MATERIAL_STYLE      : String(20); //物料类型区分
        @title : '{i18n>MATERIAL_MTART}'
        MATERIAL_MTART      : String(5); //物料类型区别字符
        @title : '{i18n>MATERIAL_MATKL}'
        MATERIAL_MATKL      : String(10); //物料组
        @title : '{i18n>MATERIAL_LVORM}'
        MATERIAL_LVORM      : String(1); //状态
        @title : '{i18n>MATERIAL_ZEINR}'
        MATERIAL_ZEINR      : String(40); //图号
        @title : '{i18n>MATERIAL_BISMT}'
        MATERIAL_BISMT      : String(40);
        @title : '{i18n>MATERIAL_NTGEW}'
        MATERIAL_NTGEW      : Decimal(13, 3); //净重
        @title : '{i18n>MATERIAL_BASIC_TEXT}'
        MATERIAL_BASIC_TEXT : String(250); //物料基本文本
        @title : '{i18n>DELETE_FLAG}'
        DELETE_FLAG         : String(20); //删除标记
        @title : '{i18n>MATERIAL_NAME}'
        MATERIAL_NAME       : localized String(120);


        @title : '{i18n>TO_GROUP}'
        TO_GROUP            : Association to D003_MATERIAL_GROUP
                                on TO_GROUP.GROUP_ID = MATERIAL_MATKL; // 物料组基本信息
  }


  @title       : '{i18n>D002_PLANT}'
  @description : '{i18n>D002_PLANT}'
  entity D002_PLANT {
    key PLANT_ID   : String(4); //工厂
        @title : '{i18n>PLANT_NAME}'
        PLANT_NAME : localized String(20);
  }

  @title       : '{i18n>D003_MATERIAL_GROUP}'
  @description : '{i18n>D003_MATERIAL_GROUP}'
  entity D003_MATERIAL_GROUP {
    key GROUP_ID       : String(10); //物料组
        IS_LOT_MANAGER : String(20); //供应商批次是否管理
        UPDATE_FLAG    : String(20); //修改标记
        DELETE_FLAG    : String(20); //删除标记
        TEXT           : localized String(20);
  }


  @title       : '{i18n>D004_LOCATION}'
  @description : '{i18n>D004_LOCATION}'
  entity D004_LOCATION { //保管场所表
    key PLANT_ID      : String(4); //工厂
    key LOCATION_ID   : String(4); //保管场所编号
        IS_T_MANAGER  : String(20); //现品票是否管理
        UPDATE_FLAG   : String(20); //修改标记
        DELETE_FLAG   : String(20); //删除标记
        @title : '{i18n>LOCATION_NAME}'
        LOCATION_NAME : localized String(120);
  }


  @title       : '{i18n>D005_SUPPLIER}'
  @description : '{i18n>D005_SUPPLIER}'
  entity D005_SUPPLIER { //供应商基本信息
    key SUPPLIER_ID    : String(20); //供应商编号
        SUPPLIER_BUKRS : String(4); //公司代码
        SUPPLIER_LAND1 : String(3); //国家代码
        @title : '{i18n>SUPPLIER_NAME1}'
        SUPPLIER_NAME1 : String(70); //名称 1
        SUPPLIER_NAME2 : String(70); //名称 2
        SUPPLIER_NAME3 : String(70); //名称 3
        SUPPLIER_NAME4 : String(70); //名称 4
        SUPPLIER_ADRNR : String(70); //地址
        SUPPLIER_EKORG : String(4); //采购组织
        SUPPLIER_ZTERM : String(4); //付款条件代码
        SUPPLIER_TELF1 : String(70); //第一电话
  }
}
