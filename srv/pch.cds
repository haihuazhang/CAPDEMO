using {MST} from '../db/model-mst';
using {PCH} from '../db/model-pch';
using {INV} from '../db/model-inv';
// using {MST} from '../db/model-mst';

service PCHService {
    entity POHead         as projection on PCH.D001_PO_H;
    entity POItems        as projection on PCH.D002_PO_D;
    entity POComponents   as projection on PCH.D003_PO_BOM;
    entity ReceiveHead    as projection on PCH.D004_RECEIVE_H;
    entity ReceiveDetail  as projection on PCH.D005_RECEIVE_D;
    entity InvT           as projection on INV.D001_T;
    entity Material       as projection on MST.D001_MATERIAL;
    entity MaterialGroup  as projection on MST.D003_MATERIAL_GROUP;
    entity Location       as projection on MST.D004_LOCATION;
    entity Supplier       as projection on MST.D005_SUPPLIER;
    // @odata.draft.enabled
    entity Plant          as projection on MST.D002_PLANT;

    // value help entity
    entity POItemsVH      as
        select from POItems {
            key ID,
                TO_HEAD.PO_NO,
                D_NO,
                MATERIAL_ID,
                TO_MATERIAL.MATERIAL_NAME,
                TO_MATERIAL.MATERIAL_BISMT,
                PO_D_QTY,
                PO_D_UNIT,
                PO_D_WERKS,
                TO_PLANT.PLANT_NAME,
                PO_D_LGORT,
                TO_LOCATION.LOCATION_NAME,
                TO_HEAD.SUPPLIER_ID,
                TO_HEAD.TO_SUPPLIER.SUPPLIER_NAME1,
                TO_HEAD.SIMP_INFO,
                @title : '{i18n>PO_CAN_QTY}'
                (
                    PO_D_QTY - PO_REC_QTY
                ) as PO_CAN_QTY : Decimal(13, 3)
        };

    entity ReceiveHistory as projection on PCH.D008_POST_HISTORY;


}


annotate PCHService.POItems with @(UI : {LineItem : [
{Value : ID},
{
    Value : TO_HEAD.PO_NO,
    Label : '{i18n>PCH_D001_ID}'
},
{
    Value : TO_HEAD.PO_DATE,
    Label : '{i18n>PO_DATE}'
},
{
    Value : D_NO,
    Label : '{i18n>D_NO}'
},
{
    Value : MATERIAL_ID,
    Label : '{i18n>MATERIAL_ID}'
},
// Old Material Number
{
    Value : PO_D_TXZ01,
    Label : '{i18n>PO_D_TXZ01}'
},

{
    Value : PO_D_QTY,
    Label : '{i18n>PO_D_QTY}'
},
{
    Value : PO_REC_QTY,
    Label : '{i18n>PO_REC_QTY}'
},
{
    Value : PO_D_UNIT,
    Label : '{i18n>PO_D_UNIT}'
},
{
    Value : PO_D_WERKS,
    Label : '{i18n>PO_D_WERKS}'
},
{
    Value : PO_D_LGORT,
    Label : '{i18n>PO_D_LGORT}'
},
// Supplier
{
    Value : TO_HEAD.SUPPLIER_ID,
    Label : '{i18n>SUPPLIER_ID}'
},
{
    Value : DELETE_FLAG,
    Label : '{i18n>DELETE_FLAG}'
}
]});


annotate PCHService.POComponents with @(UI : {LineItem : [
{Value : ID},
{
    Value : TO_HEAD.PO_NO,
    Label : '{i18n>PCH_D001_ID}'
},
{
    Value : TO_HEAD.PO_DATE,
    Label : '{i18n>PO_DATE}'
},
{
    Value : D_NO,
    Label : '{i18n>D_NO}'

},
{
    Value : MATERIAL_ID,
    Label : '{i18n>MATERIAL_ID}'

}


]});


annotate PCHService.POItems with {
    PO_D_WERKS @(Common : {
        Text      : {$value : TO_PLANT.PLANT_NAME},
        ValueList : {entity : 'Plant'}
    })
};

annotate PCHService.ReceiveHead with {
    PLANT_ID @(Common : {
        FieldControl : #Mandatory,
        ValueList    : {entity : 'Plant'}
    });
    REH_DATE @(Common : {FieldControl : #Mandatory});
};

// annotate PCHService.ReceiveDetail with @odata.draft.enabled;
annotate PCHService.ReceiveHead with @odata.draft.enabled;

annotate PCHService.ReceiveDetail with {
    PCH_D002_ID     @(Common : {ValueList : {
        entity     : 'POItemsVH',
        Parameters : [
        {
            $Type             : 'Common.ValueListParameterInOut',
            LocalDataProperty : 'PCH_D002_ID',
            ValueListProperty : 'ID'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'MATERIAL_ID',
            ValueListProperty : 'MATERIAL_ID'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'TO_MATERIAL/MATERIAL_NAME',
            ValueListProperty : 'MATERIAL_NAME'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'TO_POITEM/PO_D_QTY',
            ValueListProperty : 'PO_D_QTY'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'RED_UNIT',
            ValueListProperty : 'PO_D_UNIT'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'TO_MATERIAL/MATERIAL_BISMT',
            ValueListProperty : 'MATERIAL_BISMT'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'PLANT_ID',
            ValueListProperty : 'PO_D_WERKS'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'RECE_D_LOCATION',
            ValueListProperty : 'PO_D_LGORT'
        },

        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'TO_POITEM/TO_HEAD/SUPPLIER_ID',
            ValueListProperty : 'SUPPLIER_ID'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'TO_POITEM/TO_HEAD/TO_SUPPLIER/SUPPLIER_NAME1',
            ValueListProperty : 'SUPPLIER_NAME1'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'SIMP_INFO',
            ValueListProperty : 'SIMP_INFO'

        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'RED_QTY',
            ValueListProperty : 'PO_CAN_QTY'
        }
        ]
    }});
    // MATERIAL_ID     @ValueList : {entity : 'Material'};
    RECE_D_LOCATION @(Common : {ValueList : {
        entity     : 'Location',
        Parameters : [
        {
            $Type             : 'Common.ValueListParameterIn',
            LocalDataProperty : 'PLANT_ID',
            ValueListProperty : 'PLANT_ID'
        },
        {
            $Type             : 'Common.ValueListParameterOut',
            LocalDataProperty : 'RECE_D_LOCATION',
            ValueListProperty : 'LOCATION_ID'
        }
        ]
    }})
};
