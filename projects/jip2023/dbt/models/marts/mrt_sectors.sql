SELECT
    mrt_growth.id as id,
    mrt_growth.section_id as section_id,
    mrt_growth.section_name as section_name,
    mrt_growth.year as year,
    mrt_capital__sector.nominal_investment as capital__nominal_investment,
    mrt_capital__sector.real_investment as capital__real_investment,
    mrt_capital__sector.input_index as capital__input_index,
    mrt_capital__sector.quality_index as capital__quality_index,
    mrt_capital__sector.nominal_net_stock as capital__nominal_net_stock,
    mrt_capital__sector.real_net_stock as capital__real_net_stock,
    mrt_capital__sector.nominal_cost as capital__nominal_cost,
    mrt_capital__sector.RS_nominal_investment as RS_nominal_investment,
    mrt_capital__sector.RS_real_investment as RS_real_investment,
    mrt_capital__sector.RS_nominal_capital_stock as RS_nominal_capital_stock,
    mrt_capital__sector.RS_real_capital_stock as RS_real_capital_stock,
    mrt_capital__sector.RS_nominal_capital_cost as RS_nominal_capital_cost,
    mrt_capital__sector.NRS_nominal_investment as NRS_nominal_investment,
    mrt_capital__sector.NRS_real_investment as NRS_real_investment,
    mrt_capital__sector.NRS_nominal_capital_stock as NRS_nominal_capital_stock,
    mrt_capital__sector.NRS_real_capital_stock as NRS_real_capital_stock,
    mrt_capital__sector.NRS_nominal_capital_cost as NRS_nominal_capital_cost,
    mrt_capital__sector.ST_nominal_investment as ST_nominal_investment,
    mrt_capital__sector.ST_real_investment as ST_real_investment,
    mrt_capital__sector.ST_nominal_capital_stock as ST_nominal_capital_stock,
    mrt_capital__sector.ST_real_capital_stock as ST_real_capital_stock,
    mrt_capital__sector.ST_nominal_capital_cost as ST_nominal_capital_cost,
    mrt_capital__sector.LA_nominal_investment as LA_nominal_investment,
    mrt_capital__sector.LA_real_investment as LA_real_investment,
    mrt_capital__sector.LA_nominal_capital_stock as LA_nominal_capital_stock,
    mrt_capital__sector.LA_real_capital_stock as LA_real_capital_stock,
    mrt_capital__sector.LA_nominal_capital_cost as LA_nominal_capital_cost,
    mrt_capital__sector.TE_nominal_investment as TE_nominal_investment,
    mrt_capital__sector.TE_real_investment as TE_real_investment,
    mrt_capital__sector.TE_nominal_capital_stock as TE_nominal_capital_stock,
    mrt_capital__sector.TE_real_capital_stock as TE_real_capital_stock,
    mrt_capital__sector.TE_nominal_capital_cost as TE_nominal_capital_cost,
    mrt_capital__sector.CPE_nominal_investment as CPE_nominal_investment,
    mrt_capital__sector.CPE_real_investment as CPE_real_investment,
    mrt_capital__sector.CPE_nominal_capital_stock as CPE_nominal_capital_stock,
    mrt_capital__sector.CPE_real_capital_stock as CPE_real_capital_stock,
    mrt_capital__sector.CPE_nominal_capital_cost as CPE_nominal_capital_cost,
    mrt_capital__sector.CME_nominal_investment as CME_nominal_investment,
    mrt_capital__sector.CME_real_investment as CME_real_investment,
    mrt_capital__sector.CME_nominal_capital_stock as CME_nominal_capital_stock,
    mrt_capital__sector.CME_real_capital_stock as CME_real_capital_stock,
    mrt_capital__sector.CME_nominal_capital_cost as CME_nominal_capital_cost,
    mrt_capital__sector.OE_nominal_investment as OE_nominal_investment,
    mrt_capital__sector.OE_real_investment as OE_real_investment,
    mrt_capital__sector.OE_nominal_capital_stock as OE_nominal_capital_stock,
    mrt_capital__sector.OE_real_capital_stock as OE_real_capital_stock,
    mrt_capital__sector.OE_nominal_capital_cost as OE_nominal_capital_cost,
    mrt_capital__sector.DE_nominal_investment as DE_nominal_investment,
    mrt_capital__sector.DE_real_investment as DE_real_investment,
    mrt_capital__sector.DE_nominal_capital_stock as DE_nominal_capital_stock,
    mrt_capital__sector.DE_real_capital_stock as DE_real_capital_stock,
    mrt_capital__sector.DE_nominal_capital_cost as DE_nominal_capital_cost,
    mrt_capital__sector.CA_nominal_investment as CA_nominal_investment,
    mrt_capital__sector.CA_real_investment as CA_real_investment,
    mrt_capital__sector.CA_nominal_capital_stock as CA_nominal_capital_stock,
    mrt_capital__sector.CA_real_capital_stock as CA_real_capital_stock,
    mrt_capital__sector.CA_nominal_capital_cost as CA_nominal_capital_cost,
    mrt_capital__sector.RD_nominal_investment as RD_nominal_investment,
    mrt_capital__sector.RD_real_investment as RD_real_investment,
    mrt_capital__sector.RD_nominal_capital_stock as RD_nominal_capital_stock,
    mrt_capital__sector.RD_real_capital_stock as RD_real_capital_stock,
    mrt_capital__sector.RD_nominal_capital_cost as RD_nominal_capital_cost,
    mrt_capital__sector.ME_nominal_investment as ME_nominal_investment,
    mrt_capital__sector.ME_real_investment as ME_real_investment,
    mrt_capital__sector.ME_nominal_capital_stock as ME_nominal_capital_stock,
    mrt_capital__sector.ME_real_capital_stock as ME_real_capital_stock,
    mrt_capital__sector.ME_nominal_capital_cost as ME_nominal_capital_cost,
    mrt_capital__sector.CS_nominal_investment as CS_nominal_investment,
    mrt_capital__sector.CS_real_investment as CS_real_investment,
    mrt_capital__sector.CS_nominal_capital_stock as CS_nominal_capital_stock,
    mrt_capital__sector.CS_real_capital_stock as CS_real_capital_stock,
    mrt_capital__sector.CS_nominal_capital_cost as CS_nominal_capital_cost,
    mrt_capital__sector.AO_nominal_investment as AO_nominal_investment,
    mrt_capital__sector.AO_real_investment as AO_real_investment,
    mrt_capital__sector.AO_nominal_capital_stock as AO_nominal_capital_stock,
    mrt_capital__sector.AO_real_capital_stock as AO_real_capital_stock,
    mrt_capital__sector.AO_nominal_capital_cost as AO_nominal_capital_cost,
    mrt_labor.input_index as labor__input_index,
    mrt_labor.hours_worked_index as labor__hours_worked_index,
    mrt_labor.quality_index as labor__quality_index,
    mrt_labor.number_of_workers as labor__number_of_workers,
    mrt_labor.hours_worked as labor__hours_worked,
    mrt_labor.nominal_costs as labor__nominal_costs,
    mrt_labor.share_of_female as labor__share_of_female,
    mrt_labor.share_of_part_time as labor__share_of_part_time,
    mrt_labor.share_of_55_over as labor__share_of_55_over,
    mrt_growth.Y as Y,
    mrt_growth.YC as YC,
    mrt_growth.YC_share as YC_share,
    mrt_growth.M as M,
    mrt_growth.PM as PM,
    mrt_growth.PM_share as PM_share,
    mrt_growth.V as V,
    mrt_growth.NV as NV,
    mrt_growth.NV_share as NV_share,
    mrt_growth.L as L,
    mrt_growth.H_index as H_index,
    mrt_growth.H as H,
    mrt_growth.LC as LC,
    mrt_growth.WL as WL,
    mrt_growth.K as K,
    mrt_growth.K_T_index as K_T_index,
    mrt_growth.K_T as K_T,
    mrt_growth.KC as KC,
    mrt_growth.RK as RK,
    mrt_growth.Cy_PM as Cy_PM,
    mrt_growth.Cy_WL as Cy_WL,
    mrt_growth.Cy_RK as Cy_RK,
    mrt_growth.Cv_WL as Cv_WL,
    mrt_growth.Cv_RK as Cv_RK,
    mrt_growth.Y_G as Y_G,
    mrt_growth.YConM as YConM,
    mrt_growth.YConH as YConH,
    mrt_growth.YConLC as YConLC,
    mrt_growth.YConK_T as YConK_T,
    mrt_growth.YConKC as YConKC,
    mrt_growth.TFPy as TFPy,
    mrt_growth.V_G as V_G,
    mrt_growth.VConH as VConH,
    mrt_growth.VConLC as VConLC,
    mrt_growth.VConK_T as VConK_T,
    mrt_growth.VConKC as VConKC,
    mrt_growth.TFPva as TFPva,
    mrt_growth.LP_G as LP_G,
    mrt_growth.H_G as H_G,
    mrt_growth.LPConK_T as LPConK_T,
    mrt_intangible_assets.I_RD as I_RD,
    mrt_intangible_assets.I_ME as I_ME,
    mrt_intangible_assets.I_SD as I_SD,
    mrt_intangible_assets.I_AO as I_AO,
    mrt_intangible_assets.I_DS as I_DS,
    mrt_intangible_assets.I_FD as I_FD,
    mrt_intangible_assets.I_BR as I_BR,
    mrt_intangible_assets.I_TR as I_TR,
    mrt_intangible_assets.I_OC as I_OC,
    mrt_intangible_assets.Iq_RD as Iq_RD,
    mrt_intangible_assets.Iq_ME as Iq_ME,
    mrt_intangible_assets.Iq_SD as Iq_SD,
    mrt_intangible_assets.Iq_AO as Iq_AO,
    mrt_intangible_assets.Iq_DS as Iq_DS,
    mrt_intangible_assets.Iq_FD as Iq_FD,
    mrt_intangible_assets.Iq_BR as Iq_BR,
    mrt_intangible_assets.Iq_TR as Iq_TR,
    mrt_intangible_assets.Iq_OC as Iq_OC,
    mrt_intangible_assets.K_RD as K_RD,
    mrt_intangible_assets.K_ME as K_ME,
    mrt_intangible_assets.K_SD as K_SD,
    mrt_intangible_assets.K_AO as K_AO,
    mrt_intangible_assets.K_DS as K_DS,
    mrt_intangible_assets.K_FD as K_FD,
    mrt_intangible_assets.K_BR as K_BR,
    mrt_intangible_assets.K_TR as K_TR,
    mrt_intangible_assets.K_OC as K_OC
FROM
    {{ref('mrt_growth')}} as mrt_growth
LEFT JOIN
    {{ref('mrt_labor')}} as mrt_labor
    ON (mrt_labor.section_id = mrt_growth.section_id)
    AND (mrt_labor.year = mrt_growth.year)
LEFT JOIN
    {{ref('mrt_capital__sector')}} as mrt_capital__sector
    ON (mrt_capital__sector.section_id = mrt_growth.section_id)
    AND (mrt_capital__sector.year = mrt_growth.year)
LEFT JOIN
    {{ref('mrt_intangible_assets')}} as mrt_intangible_assets
    ON (mrt_intangible_assets.section_id = mrt_growth.section_id)
    AND (mrt_intangible_assets.year = mrt_growth.year)
ORDER BY id