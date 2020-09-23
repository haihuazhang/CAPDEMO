namespace TYPE;


  @title : '{i18n>COMMON_POST_FILED}'
aspect COMMON_POST_FILED {
  @title : '{i18n>POST_STATUS}'
  POST_STATUS         : String(20); //当前状态
  @title : '{i18n>POST_ACCOUNT_DATE}'
  POST_ACCOUNT_DATE   : Date; //发送账期时间
  @title : '{i18n>POST_TIME}'
  POST_TIME           : DateTime; //发送成功时间
  @title : '{i18n>POST_PERSON}'
  POST_PERSON         : String(20); //发送人
  @title : '{i18n>POST_ERP_NO}'
  POST_ERP_NO         : String(10); //发送成功SAP传票号
  @title : '{i18n>POST_ERP_SUB_NO}'
  POST_ERP_SUB_NO     : String(8); //传票SUB号
  @title : '{i18n>POST_ERP_YEAR}'
  POST_ERP_YEAR       : String(4); //传票账期年度
  @title : '{i18n>CANCEL_ACCOUNT_DATE}'
  CANCEL_ACCOUNT_DATE : Date; //取消发送账期
  @title : '{i18n>CANCEL_TIME}'
  CANCEL_TIME         : DateTime; //取消成功时间
  @title : '{i18n>CANCEL_PERSON}'
  CANCEL_PERSON       : String(20); //取消人
  @title : '{i18n>CANCEL_ERP_NO}'
  CANCEL_ERP_NO       : String(10); //取消的SAP传票号
  @title : '{i18n>CANCEL_ERP_SUB_NO}'
  CANCEL_ERP_SUB_NO   : String(8); //取消的SAP传票明细号
  @title : '{i18n>CANCEL_ERP_YEAR}'
  CANCEL_ERP_YEAR     : String(4); //取消的账期年度
  @title : '{i18n>POST_MSG}'
  POST_MSG            : String(4000); //错误消息
  @title : '{i18n>CANCEL_REASON}'
  CANCEL_REASON       : String(200); //冲销理由

}

  @title : '{i18n>COMMON_CUID_FILED}'
aspect COMMON_CUID_FILED {
  @title : '{i18n>COMMON_CREATEDAT}'
  CREATEDAT   : DateTime; //创建时间
  @title : '{i18n>COMMON_MODIFIEDAT}'
  MODIFIEDAT  : DateTime; //修改时间
  @title : '{i18n>COMMON_CREATEDBY}'
  CREATEDBY   : String(20); //创建人
  @title : '{i18n>COMMON_MODIFIEDBY}'
  MODIFIEDBY  : String(20); //修改人
  UPDATE_FLAG : String(20) default 'U'; //修改标记
  DELETE_FLAG : String(20); //删除标记
}
