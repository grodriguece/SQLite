--
--
DROP TABLE IF EXISTS baselinesite;
CREATE TABLE baselinesite AS
SELECT DISTINCT
b.SITIO AS Sitio, b.AMBIENTE_COBERTURA, b.REGION AS Region,	b.DEPARTAMENTO AS Departamento,	b.MUNICIPIO AS Municipio, b.LOCALIDAD AS LocalidadCRC,
b.GEO_REFERENCIA AS Cluster, b.UBICACION AS Ubicacion, b.LATITUD AS Latitud, b.LONGITUD AS Longitud, b.ALTURA_ESTRUCTURA AS Altura_Estructura
FROM baseline AS b;
--
--
DROP TABLE IF EXISTS Baseline_UMTS;
CREATE TABLE Baseline_UMTS AS
SELECT DISTINCT
b.BTS_NAME,b.BSC_NAME,b.SECTOR,b.ANTENA_TYPE,b.ALTURA_ANTENA, b.AZIMUTH,b.TILT_ELECTRICO, b.TILT_MECANICO,
b.TWIST, b.CELLID,b.GRUPO,b.LAC,b.TECNOLOGIA,b.ESTADO,b.FECHA_ESTADO,b.PROVEEDOR,b.REGIONALCLUSTER,
b.TIPO_AREA_COBERTURA,b.OWA
FROM baseline AS b
WHERE b.TECNOLOGIA = 'UMTS';
--
--
--
DROP TABLE IF EXISTS Sites_L651;
CREATE TABLE Sites_L651 AS
SELECT DISTINCT
L.LNBTSname, L.earfcnDL, 'Baja' AS Escenario_1900
FROM LNCEL_Full AS L
WHERE L.earfcnDL = 651 AND L.LNBTSname IS NOT NULL;
--
DROP TABLE IF EXISTS Sites_L626;
CREATE TABLE Sites_L626 AS
SELECT DISTINCT
L.LNBTSname, L.earfcnDL, 'Alta' AS Escenario_1900
FROM LNCEL_Full AS L
WHERE L.earfcnDL = 626 AND L.LNBTSname IS NOT NULL;
--
--
DROP TABLE IF EXISTS Sites_L1900;
CREATE TABLE Sites_L1900 AS
SELECT * FROM Sites_L651
UNION ALL
SELECT * FROM Sites_L626
ORDER BY
    LNBTSname;
--
--
--
--WCEL_FULL1
DROP TABLE IF EXISTS WCEL_FULL1;
CREATE TABLE WCEL_FULL1 AS
SELECT DISTINCT
WCEL.name AS WCELName, B.Cluster, B.Region, B.Departamento AS Depto, B.Municipio AS Mun, substr(WCEL.name,1,3) AS Prefijo, B.Latitud, B.Longitud, BL.Azimuth, S.Escenario_1900, WCEL.UARFCN, CASE WHEN WCEL.UARFCN < 9685 THEN 850 ELSE 1900 END Banda, WBTS.name AS WBTSName, WCEL.PLMN_id, RNC.name AS RNCName, RNC.RNC_id, WBTS.WBTS_id, WCEL.WCEL_id, WCEL_URAID.Value AS URAid,
SUBSTR(WCEL.name, INSTR(WCEL.name, '_') + 1, LENGTH(WCEL.name) - INSTR(WCEL.name, '_')) AS Sector, "PLMN-PLMN/RNC-" || WCEL.RNC_id || "/WBTS-" || WCEL.WBTS_Id || "/WCEL-" || WCEL.WCEL_id AS CellDN, WBTS.name || "_" ||WCEL.SectorID AS SectorIdName, WCEL.moVersion,WCEL.WCELMCC,WCEL.WCELMNC,WCEL.ACBarredList,WCEL.AICHTraTime,WCEL.AMROverSC,WCEL.AMROverTransmission,WCEL.AMROverTxNC,WCEL.AMROverTxNonHSPA,WCEL.AMROverTxTotal,WCEL.AMRSF,WCEL.AMRTargetSC,WCEL.AMRTargetTransmission,WCEL.AMRTargetTxNC,WCEL.AMRTargetTxNonHSPA,WCEL.AMRTargetTxTotal,WCEL.AMRUnderSC,WCEL.AMRUnderTransmission,WCEL.AMRUnderTxNC,
WCEL.AMRUnderTxNonHSPA,WCEL.AMRUnderTxTotal,WCEL.ATOSRBsOnHSPA,WCEL.AbsPrioCellReselec,WCEL.ActivationTimeOffset,WCEL.AdminCellState,WCEL.AdminPICState,WCEL.AllowedRACHSubChannels,WCEL.AltScramblingCodeCM,WCEL.AssignedPICPool,WCEL.BlindHOEcNoThrTarget,WCEL.BlindHORSCPThrTarget,WCEL.CCHSetupEnabled,WCEL.CIRForFDPCH,WCEL.CId,WCEL.CPCEnabled,WCEL.CPICHEcNoSRBMapRRC,WCEL.CPICHRSCPSRBMapRRC,WCEL.CPICHtoRefRABoffset,WCEL.CSAMRModeSET,WCEL.CSAMRModeSETWB,WCEL.CSGroupId,WCEL.CTCHCapaHighPri,WCEL.CUCEcNoThreshold,WCEL.CUCRSCPThreshold,WCEL.CableLoss,WCEL.CellAdditionalInfo,WCEL.CellBarred,
WCEL.CellRange,WCEL.CellSelQualMeas,WCEL.CellWeightForHSDPALayering,WCEL.Cell_Reserved,WCEL.CodeTreeOptTimer,WCEL.CodeTreeOptimisation,WCEL.CodeTreeOptimisationGuardTime,WCEL.CodeTreeUsage,WCEL.DLLoadStateTTT,WCEL.DPCHOverHSPDSCHThreshold,WCEL.DPCModeChangeSupport,WCEL.DRRCprxMargin,WCEL.DRRCprxOffset,WCEL.DRRCptxMargin,WCEL.DRRCptxOffset,WCEL.DefMeasCtrlReading,WCEL.DeltaPrxMaxDown,WCEL.DeltaPrxMaxUp,WCEL.DeltaPtxMaxDown,WCEL.DeltaPtxMaxUp,WCEL.DirectSCCEnabled,WCEL.DirectedRRCEnabled,WCEL.DirectedRRCForHSDPALayerEnabled,WCEL.DynVCPFunctionalityControl,WCEL.DynVCPMinHSDPAUsers,
WCEL.DynVoiceCallPriorityEnabled,WCEL.EDCHCapability,WCEL.EDCHMinSetETFCIT0,WCEL.EDCHMinimumSetETFCI,WCEL.EDCHOpState,WCEL.EbNoSetIdentifier,WCEL.FDPCHCodeChangeEnabled,WCEL.FDPCHEnabled,WCEL.FDPCHSetup,WCEL.FMCLIdentifier,WCEL.FachLoadMarginCCH,WCEL.FachLoadThresholdCCH,WCEL.FastActOfTargetServCell,WCEL.FastCompletionOfSCC,WCEL.FastHSPAMobilityEnabled,WCEL.GSMCellReselection,WCEL.HCS_PRIO,WCEL.HHoMaxAllowedBitrateDL,WCEL.HHoMaxAllowedBitrateUL,WCEL.HSCapabilityHONumbUE,WCEL.HSCapabilityHOPeriod,WCEL.HSDPA64QAMallowed,WCEL.HSDPACPICHAveWindow,WCEL.HSDPACPICHReportPeriod,
WCEL.HSDPACellChangeMinInterval,WCEL.HSDPAFmcgIdentifier,WCEL.HSDPAFmciIdentifier,WCEL.HSDPAFmcsIdentifier,WCEL.HSDPALayeringCommonChEnabled,
WCEL.HSDPAMaxCellChangeRepetition,WCEL.HSDPASRBWindow,WCEL.HSDPAServCellWindow,WCEL.HSDPAcapability,WCEL.HSDPAenabled,WCEL.HSDSCHOpState,
WCEL.HSLoadStateHSDBRLimit,WCEL.HSLoadStateHSDOffset,WCEL.HSLoadStateHSUBRLimit,WCEL.HSLoadStateHSUOffset,WCEL.HSLoadStateHSUResThr,
WCEL.HSPA128UsersPerCell,WCEL.HSPA72UsersPerCell,WCEL.HSPACapaHO,WCEL.HSPAFmcsIdentifier,WCEL.HSPAQoSEnabled,WCEL.HSPASCCSpecificATO,
WCEL.HSPDSCHCodeSet,WCEL.HSPDSCHMarginSF128,WCEL.HSPwrOffsetUpdateDelay,WCEL.HSUPA16QAMAllowed,WCEL.HSUPA2MSTTIEnabled,WCEL.HSUPAEnabled,
WCEL.HSUPAUserLimit16QAM,WCEL.HspaMultiNrtRabSupport,WCEL.IncomingLTEISHO,WCEL.InitialBitRateDL,WCEL.InitialBitRateUL,WCEL.InterFreqScaleTresel,
WCEL.InterRATScaleTresel,WCEL.IntraFreq_Cell_Reselect_Ind,WCEL.KforCTCH,WCEL.LAC,WCEL.LHOCapaReqRejRateDL,WCEL.LHOCapaReqRejRateUL,
WCEL.LHODelayOFFCapaReqRejRate,WCEL.LHODelayOFFHardBlocking,WCEL.LHODelayOFFInterference,WCEL.LHODelayOFFResRateSC,WCEL.LHOHardBlockingBaseLoad,
WCEL.LHOHardBlockingRatio,WCEL.LHOHystTimeCapaReqRejRate,WCEL.LHOHystTimeHardBlocking,WCEL.LHOHystTimeInterference,WCEL.LHOHystTimeResRateSC,
WCEL.LHONRTTrafficBaseLoad,WCEL.LHONumbUEInterFreq,WCEL.LHONumbUEInterRAT,WCEL.LHOPwrOffsetDL,WCEL.LHOPwrOffsetUL,WCEL.LHOResRateSC,
WCEL.LHOWinSizeOFFCapaReqRejRate,WCEL.LHOWinSizeOFFHardBlocking,WCEL.LHOWinSizeOFFInterference,WCEL.LHOWinSizeOFFResRateSC,
WCEL.LHOWinSizeONCapaReqRejRate,WCEL.LHOWinSizeONHardBlocking,WCEL.LHOWinSizeONInterference,WCEL.LHOWinSizeONResRateSC,WCEL.LTECellReselection,
WCEL.LTELayerCellHSLoad,WCEL.LTELayeringMeasActivation,WCEL.LoadBasedCPICHEcNoSRBHSPA,WCEL.LoadBasedCPICHEcNoThreEDCH2MS,WCEL.MBLBEnhancementsEnabled,
WCEL.MBLBInactivityEnabled,WCEL.MBLBLoadInfoDistr,WCEL.MBLBMobilityEnabled,WCEL.MBLBRABSetupEnabled,WCEL.MBLBRABSetupMultiRAB,WCEL.MBLBStateTransEnabled,
WCEL.MEHHSDPAUserNbrCQI,WCEL.MEHHSUPAUserNbr2msTTI,WCEL.MEHLoadStateTtT,WCEL.MEHMaxHSUPAUsers,WCEL.MEHQueueThreshold,WCEL.MEHULLHSDPAUALimit,
WCEL.MHA,WCEL.MassEventHandler,WCEL.MaxBitRateDLPSNRT,WCEL.MaxBitRateULPSNRT,WCEL.MaxCodeReleases,WCEL.MaxDLPowerCapability,WCEL.MaxIncrInterferenceUL,
WCEL.MaxNbrOfHSSCCHCodes,WCEL.MaxNumberEDCHCell,WCEL.MaxNumberHSDPAUsers,WCEL.MaxNumberHSDSCHMACdFlows,WCEL.MaxNumberUECmHO,WCEL.MaxNumberUECmSLHO,
WCEL.MaxNumberUEHSPACmHO,WCEL.MaxNumberUEHSPACmNCHO,WCEL.MaxTotalUplinkSymbolRate,WCEL.MinAllowedBitRateDL,WCEL.MinAllowedBitRateUL,WCEL.N300,
WCEL.N312,WCEL.N312Conn,WCEL.N313,WCEL.N315,WCEL.NASsignVolThrDL,WCEL.NASsignVolThrUL,WCEL.NCr,WCEL.NbrOfSCCPCHs,WCEL.NforCTCH,WCEL.NonHCSNcr,
WCEL.NonHCSTcrMax,WCEL.NonHCSTcrMaxHyst,WCEL.NrtFmcgIdentifier,WCEL.NrtFmciIdentifier,WCEL.NrtFmcsIdentifier,WCEL.NumberEDCHReservedSHOBranchAdditions,
WCEL.OCULNRTDCHGrantedMinAllocT,WCEL.OCdlNrtDCHgrantedMinAllocT,WCEL.PBSHSMinAllocEqual,WCEL.PBSHSMinAllocHigher,WCEL.PBSHSMinAllocLower,
WCEL.PBSgrantedMinDCHallocTequalP,WCEL.PBSgrantedMinDCHallocThigherP,WCEL.PBSgrantedMinDCHallocTlowerP,WCEL.PCH24kbpsEnabled,WCEL.PFLIdentifier,
WCEL.PICState,WCEL.PI_amount,WCEL.PRACHDelayRange,WCEL.PRACHRequiredReceivedCI,WCEL.PRACHScramblingCode,WCEL.PRACH_preamble_retrans,WCEL.PSGroupId,
WCEL.PTxPICH,WCEL.PWSMAVLimitNRTHSDPA,WCEL.PWSMAVLimitRTDCH,WCEL.PWSMAVLimitRTHSDPA,WCEL.PWSMAVPwrNRTHSDPA,WCEL.PWSMAVPwrRTHSDPA,WCEL.PWSMCellGroup,
WCEL.PWSMEXPwrLimit,WCEL.PWSMEXUsrLimit,WCEL.PWSMSDLimitNRTDCH,WCEL.PWSMSDLimitNRTHSDPA,WCEL.PWSMSDLimitRTDCH,WCEL.PWSMSDLimitRTHSDPA,
WCEL.PWSMSDPwrNRTHSDPA,WCEL.PWSMSDPwrRTDCH,WCEL.PWSMSDPwrRTHSDPA,WCEL.PWSMShutdownOrder,WCEL.PWSMShutdownRemCell,WCEL.PowerOffsetLastPreamblePRACHmessage,
WCEL.PO1_15,WCEL.PO1_30,WCEL.PO1_60,WCEL.PowerOffsetUpdMsgSize,WCEL.PowerRampStepPRACHpreamble,WCEL.PowerSaveHSPAType,WCEL.PriScrCode,
WCEL.PrxLoadMarginDCH,WCEL.PrxLoadMarginEDCH,WCEL.PrxLoadMarginMaxDCH,WCEL.PrxMaxOrigTargetBTS,WCEL.PrxMaxTargetBTS,WCEL.PrxMeasFilterCoeff,
WCEL.PrxNoise,WCEL.PrxNoiseAutotuning,WCEL.PrxOffset,WCEL.PrxOffsetWPS,WCEL.PrxTarget,WCEL.PrxTargetMax,WCEL.PrxTargetPSMax,WCEL.PrxTargetPSMin,
WCEL.PrxTargetPSStepDown,WCEL.PrxTargetPSStepUp,WCEL.PtxAICH,WCEL.PtxCellMax,WCEL.PtxDLabsMax,WCEL.PtxFDPCHMax,WCEL.PtxFDPCHMin,WCEL.PtxHighHSDPAPwr,
WCEL.PtxMarginCCH,WCEL.PtxMaxEHICH,WCEL.PtxMaxHSDPA,WCEL.PtxMeasFilterCoeff,WCEL.PtxOffset,WCEL.PtxOffsetEAGCH,WCEL.PtxOffsetEAGCHDPCCH,
WCEL.PtxOffsetEHICHDPCCH,WCEL.PtxOffsetERGCH,WCEL.PtxOffsetERGCHDPCCH,WCEL.PtxOffsetExxCH2ms,WCEL.PtxOffsetExxCHSHO,WCEL.PtxOffsetFDPCHSHO,
WCEL.PtxOffsetWPS,WCEL.PtxPSstreamAbsMax,WCEL.PtxPrimaryCCPCH,WCEL.PtxPrimaryCPICH,WCEL.PtxPrimarySCH,WCEL.PtxSCCPCH1,WCEL.PtxSCCPCH2,
WCEL.PtxSCCPCH2SF128,WCEL.PtxSCCPCH3,WCEL.PtxSecSCH,WCEL.PtxTarget,WCEL.PtxTargetPSAdjustPeriod,WCEL.PtxTargetPSMax,WCEL.PtxTargetPSMin,
WCEL.PtxTargetPSStepDown,WCEL.PtxTargetPSStepUp,WCEL.PtxTargetTotMax,WCEL.PtxTargetTotMin,WCEL.PtxThresholdCCH,WCEL.QHCS,WCEL.Qhyst1,
WCEL.Qhyst1FACH,WCEL.Qhyst1PCH,WCEL.Qhyst2,WCEL.Qhyst2FACH,WCEL.Qhyst2PCH,WCEL.QqualMin,WCEL.QrxlevMin,WCEL.RAC,WCEL.RACHCapacity,
WCEL.RACHInterFreqMesQuant,WCEL.RACHIntraFreqMesQuant,WCEL.RACHPreambleSignatures,WCEL.RACH_Tx_NB01max,WCEL.RACH_Tx_NB01min,WCEL.RACH_tx_Max,
WCEL.RACHmeasFilterCoeff,WCEL.RNARGroupId,WCEL.TargetsystemBackgroundCall,WCEL.TargetsystemConversationalCall,WCEL.TargetsystemDetach,
WCEL.TargetsystemEmergencyCall,WCEL.TargetsystemHighPrioritySignalling,WCEL.TargetsystemInteractiveCall,WCEL.TargetsystemLowPrioritySignalling,
WCEL.TargetsystemMBMSrbrequest,WCEL.TargetsystemMBMSreception,WCEL.TargetsystemStreamingCall,WCEL.TargetsystemSubscribedTraffic,
WCEL.TargetsysteminterRATchangeorder,WCEL.TargetsysteminterRATreselection,WCEL.Targetsystemreestablishment,WCEL.Targetsystemregistration,
WCEL.Targetsystemunknown,WCEL.RRCconnRepTimer1,WCEL.RRCconnRepTimer2,WCEL.RTWithHSDPAFmcgIdentifier,WCEL.RTWithHSDPAFmciIdentifier,
WCEL.RTWithHSDPAFmcsIdentifier,WCEL.RTWithHSPAFmcsIdentifier,WCEL.RachLoadMarginCCH,WCEL.RachLoadThresholdCCH,WCEL.RefServForCodePower,WCEL.RelocComm_in_InterRNC_HHO,WCEL.RsrvdSignaturesOffset,WCEL.RtFmcgIdentifier,WCEL.RtFmciIdentifier,WCEL.RtFmcsIdentifier,WCEL.RxDivIndicator,WCEL.SABEnabled,WCEL.SAC,WCEL.SACB,WCEL.SHCS_RAT,WCEL.SHCS_RATConn,WCEL.SIB11Length,WCEL.SIB11bisLength,WCEL.SIB12Length,WCEL.SIB4Indicator,WCEL.SIB7factor,WCEL.SIRDPCCHOffsetEDPCH,WCEL.SRBBitRateRRCSetupEC,WCEL.SRBDCHFmcsId,WCEL.SRBHSPAFmcsId,WCEL.SRBMapRRCSetupEC,WCEL.SectorID,WCEL.ServHONumbUEInterFreq,WCEL.ServHONumbUEInterRAT,WCEL.ServHOPeriodInterFreq,WCEL.ServHOPeriodInterRAT,WCEL.ShutdownStepAmount,WCEL.ShutdownWindow,WCEL.Sintersearch,WCEL.SintersearchConn,WCEL.Sintrasearch,WCEL.SintrasearchConn,WCEL.Slimit_SearchRAT,WCEL.Slimit_SearchRATConn,WCEL.SmartLTELayeringEnabled,WCEL.SmartLTELayeringRSCP,WCEL.SmartLTELayeringTSysSel,WCEL.SmartLTELayeringUA,WCEL.SmartTrafVolThrDL,WCEL.SmartTrafVolThrUL,WCEL.SpeedScaleTresel,WCEL.Sprioritysearch1,WCEL.Sprioritysearch2,WCEL.SsearchHCS,WCEL.SsearchHCSConn,WCEL.Ssearch_RAT,WCEL.Ssearch_RATConn,WCEL.T300,WCEL.T312,WCEL.T312Conn,WCEL.T313,WCEL.T315,WCEL.TBarred,WCEL.TCrmax,WCEL.TCrmaxHyst,WCEL.TPCCommandERTarget,WCEL.TargetNSEDCHToTotalEDCHPR,WCEL.Tcell,WCEL.Threshservlow,WCEL.Threshservlow2,WCEL.ToAWE_CCH,WCEL.ToAWS_CCH,WCEL.TrafVolThresholdDLLow,WCEL.Treselection,WCEL.TreselectionFACH,WCEL.TreselectionPCH,WCEL.UEtxPowerMaxDPCH,WCEL.UEtxPowerMaxPRACH,WCEL.UEtxPowerMaxPRACHConn,WCEL.ULLoadStateHSUBRLimit,WCEL.ULLoadStateHSUOffset,WCEL.UTRAN_DRX_length,WCEL.UseOfHCS,WCEL.VCPMaxHSDPAUsers,WCEL.VCPPtxOffset,WCEL.VoiceCallPriority,WCEL.VoiceOverrideSTHSUPA,WCEL.WACSetIdentifier,WCEL.WCDMACellReselection,WCEL.WCELChangeOrigin,WCEL.WCelState,WCEL.NumofEagch,WCEL.NumofErgHich,WCEL.angle,WCEL.cellLevel,WCEL.siteTemplateName,WCEL.AppAwareRANCapability,WCEL.EVAMCapability,WCEL.HSFACHCapability,WCEL.HSRACHCapability,WCEL.ICRCapability,WCEL.UEDRXCapability,WCEL.DCellHSDPACapaHO,WCEL.DCellHSDPAEnabled,WCEL.DCellHSDPAFmcsId,WCEL.MDTPeriodicMeasEnabled,WCEL.MaxNumbHSDPAUsersS,WCEL.MaxNumbHSDSCHMACdFS,WCEL.PWSMAVLimitDCHSDPA,WCEL.PWSMSDLimitDCHSDPA,WCEL.oldDN,WCEL.radioCapacity,WCEL.EMEHCellStates,WCEL.EMEHEnabled,WCEL.EMEHLowHSUPATput,WCEL.EMEHNormalHSUPATput,WCEL.EMEHOptions,WCEL.EMEHPreventivePrxOffset,WCEL.EMEHReactivePrxOffset,WCEL.HSDPA64UsersEnabled,WCEL.PredWCDMALTELoadBalEnabled,WCEL.GuaranteedVoiceDLCode,WCEL.LTEHandoverEnabled,WCEL.InterfRedAppliedCell,WCEL.WCDMALTELoadBalEnabled,WCEL.ICBDLDowngradeThreshold,WCEL.ICBDLHSDPAUSersInCell,WCEL.ICBDLMaxDecrease,WCEL.ICBDLUpgradeThreshold,WCEL.ICBEnabled,WCEL.ICBULHSUPAUserLimit,WCEL.ICBULMaxIncrease,WCEL.ICBULSurrCellLoadOffset,WCEL.ProgLTELayeringEnabled,WCEL.AppAwareRANEnabled,WCEL.LayeringRRCRelEnabled,WCEL.AmpliRatioOptHSRACH,WCEL.DRXCycleHSFACH,WCEL.DRXInactiveTimerHSFACH,WCEL.DRXInterruptHSDSCHData,WCEL.HSFACHActTimeToTrigger,WCEL.HSFACHActivityAveWin,WCEL.HSFACHActivityThr,WCEL.HSFACHDRXEnabled,WCEL.HSFACHEnabled,WCEL.HSFACHRABDRAEnabled,WCEL.HSFACHRLCTimeToTrigger,WCEL.HSFACHRel7ConSetupEC,WCEL.HSFACHRel8ConSetupEC,WCEL.HSFACHVolThrDL,WCEL.HSRACHActTimeToTrigger,WCEL.HSRACHActivityAveWin,WCEL.HSRACHActivityThr,WCEL.HSRACHCommonEDCHRes,WCEL.HSRACHEnabled,WCEL.HSRACHExtendedAI,WCEL.HSRACHImplicitRelease,WCEL.HSRACHMPO,WCEL.HSRACHMaxAllocTimeCCCH,WCEL.HSRACHMaxPeriodCollis,WCEL.HSRACHMaxTotSymbolRate,WCEL.HSRACHSubChannelNumber,WCEL.HSRACHTimeToTrigger,WCEL.HSRACHTransmisBackOff,WCEL.HSRACHVolThrUL,WCEL.HappyBitDelayConHSRACH,WCEL.PowerOffsetPreamHSRACH,WCEL.PrxTargetPSMaxtHSRACH,WCEL.PtxBCCHHSPDSCH,WCEL.PtxBCCHHSSCCH,WCEL.PtxTargetPSMaxtHSRACH,WCEL.RXBurstHSFACH,WCEL.T321,WBTS.BTSSupportForHSPACM,
WBTS.NEType, CASE WHEN (WCEL.AdminCellState=1 AND WCEL.WCelState=0) THEN 1 ELSE 0 END AS Estado
FROM (((((RNC LEFT JOIN WBTS ON RNC.RNC_id = WBTS.RNC_id) LEFT JOIN WCEL ON (WBTS.WBTS_Id = WCEL.WBTS_Id) AND (WBTS.RNC_id = WCEL.RNC_id))
LEFT JOIN WCEL_URAID ON (WCEL.WCEL_id = WCEL_URAID.wcel_ID) AND (WCEL.WBTS_Id = WCEL_URAID.WBTS_Id) AND (WCEL.RNC_id = WCEL_URAID.RNC_id))
LEFT JOIN baselinesite AS B ON (B.Sitio = WBTS.name COLLATE NOCASE)) LEFT JOIN Baseline_UMTS AS BL ON (WCEL.name = BL.BTS_Name COLLATE NOCASE))
LEFT JOIN Sites_L1900 AS S ON (WBTS.name = S.LNBTSname)
ORDER BY WCEL.name;
--
--
CREATE INDEX u_wcel ON WCEL_FULL1 (RNC_id, WBTS_id, WCEL_id);
--
--WCEL parametros importantes, OK
--
DROP TABLE IF EXISTS WCEL_PARAM1;
CREATE TABLE WCEL_PARAM1 AS
SELECT W.WCELName, W.WBTSName, W.Cluster, W.Region, W.Depto, W.Mun, W.Prefijo, W.Banda, W.PLMN_id, W.Sector, W.WCEL_id, W.RNCName, W.RNC_id, W.WBTS_id, W.CId, W.Latitud, W.Longitud, W.Azimuth, W.PriScrCode, (W.angle)/10 AS tilt, W.LAC, W.RAC, W.AdminCellState, W.WCelState, W.moversion AS version , W.URAid, W.PCH24kbpsEnabled, W.NbrOfSCCPCHs,
W.Tcell, W.PrxTarget, W.PtxPrimaryCPICH, W.PtxCellMax, W.MaxDLPowerCapability, W.PtxHighHSDPAPwr, W.PtxTarget, W.PtxTargetPSMax, W.PtxTargetPSMin, W.PtxMaxHSDPA,
W.PtxDLabsMax, W.MaxNbrOfHSSCCHCodes, W.InitialBitRateDL, W.InitialBitRateUL, W.MinAllowedBitRateDL, W.MinAllowedBitRateUL, W.T300, W.T312, W.T313, W.N300,
W.N312, W.N313, W.N315, W.T315, W.RtFmcsIdentifier, W.NrtFmcsIdentifier, W.RTWithHSDPAFmcgIdentifier, W.RTWithHSDPAFmciIdentifier,
W.RTWithHSDPAFmcsIdentifier, W.NrtFmcgIdentifier, W.NrtFmciIdentifier, W.RtFmcgIdentifier, W.RtFmciIdentifier, W.FMCLIdentifier, W.LTELayeringMeasActivation, W.UARFCN, W.SHCS_RAT, W.SsearchHCS,
W.SHCS_RATConn, W.SsearchHCSConn, W.PrxOffset, W.PrxNoise, W.CSAMRModeSET, W.CSAMRModeSETWB,  W.CellBarred, W.HSPA128UsersPerCell, W.SectorID,
W.HSDPAFmciIdentifier, W.HSDPAFmcsIdentifier, W.HSPAFmcsIdentifier, W.HSDPAFmcgIdentifier,
W.WCDMACellReselection, W.LTECellReselection, W.GSMCellReselection, W.QqualMin, W.QrxlevMin, W.AbsPrioCellReselec, W.RACHInterFreqMesQuant,
W.BlindHORSCPThrTarget, W.BlindHOEcNoThrTarget, W.Sprioritysearch1, W.Sprioritysearch2, W.Threshservlow, W.Threshservlow2,
W.AdminPICState, W.ULLoadStateHSUOffset, W.MaxNumberEDCHCell, W.MaxNumberHSDPAUsers, W.SmartLTELayeringEnabled, W.LTEHandoverEnabled, W.SmartLTELayeringRSCP,
W.IncomingLTEISHO, W.CellDN, W.SectorIdName, W.Escenario_1900,
W.Latitud AS Deci_Lat, W.Longitud AS Deci_Lon, W.WBTS_id AS Mtx_Site, W.CId AS Mtx_Site_ID, W.SectorID*1 AS sector_ID, W.WCELName AS Site_Name,
W.BTSSupportForHSPACM, W.NEType, W.Estado
FROM WCEL_FULL1 AS W LEFT JOIN Baseline_UMTS AS G ON (W.WCELName = G.BTS_Name COLLATE NOCASE)
WHERE W.WCEL_id IS NOT NULL
ORDER BY W.WCELName IS NULL OR W.WCELName='', W.WCELName;
--
--
--
-- UMTS ADJ inbound outbound count
--
DROP TABLE IF EXISTS adjsct;
CREATE TABLE adjsct AS
SELECT
w.RNC_id, w.WBTS_id, w.WCEL_id, COUNT(a.ADJS_id) AS adjscount
FROM WCEL_PARAM1 w LEFT JOIN ADJS a ON (w.RNC_id = a.RNC_id AND w.WCEL_id = a.WCEL_id)
GROUP BY w.RNC_id||w.WCEL_id;
--
DROP TABLE IF EXISTS adjict;
CREATE TABLE adjict AS
SELECT
w.RNC_id, w.WBTS_id, w.WCEL_id, COUNT(a.ADJI_id) AS adjicount
FROM WCEL_PARAM1 w LEFT JOIN ADJI a ON (w.RNC_id = a.RNC_id AND w.WCEL_id = a.WCEL_id)
GROUP BY w.RNC_id||w.WCEL_id;
--
DROP TABLE IF EXISTS adjlct;
CREATE TABLE adjlct AS
SELECT
w.RNC_id, w.WBTS_id, w.WCEL_id, COUNT(a.ADJL_id) AS adjlcount
FROM WCEL w LEFT JOIN ADJL a ON (w.RNC_id = a.RNC_id AND w.WCEL_id = a.WCEL_id)
GROUP BY w.RNC_id||w.WCEL_id;
--
DROP TABLE IF EXISTS adjgct;
CREATE TABLE adjgct AS
SELECT
w.RNC_id, w.WBTS_id, w.WCEL_id, COUNT(a.ADJG_id) AS adjgcount
FROM WCEL_PARAM1 w LEFT JOIN ADJG a ON (w.RNC_id = a.RNC_id AND w.WCEL_id = a.WCEL_id)
GROUP BY w.RNC_id||w.WCEL_id;
--
DROP TABLE IF EXISTS adjscti;
CREATE TABLE adjscti AS
SELECT
w.RNC_id, w.WBTS_id, w.WCEL_id, COUNT(a.ADJS_id) AS adjscounti
FROM WCEL_PARAM1 w LEFT JOIN ADJS a ON (w.CellDN = a.TargetCellDN)
GROUP BY w.RNC_id||w.WCEL_id;
--
DROP TABLE IF EXISTS adjicti;
CREATE TABLE adjicti AS
SELECT
w.RNC_id, w.WBTS_id, w.WCEL_id, COUNT(a.ADJI_id) AS adjicounti
FROM WCEL_PARAM1 w LEFT JOIN ADJI a ON (w.CellDN = a.TargetCellDN)
GROUP BY w.RNC_id||w.WCEL_id;
--
DROP TABLE IF EXISTS adjwcti;
CREATE TABLE adjwcti AS
SELECT
w.RNC_id, w.WBTS_id, w.WCEL_id, COUNT(a.ADJW_id) AS adjwcounti
FROM WCEL_PARAM1 w LEFT JOIN ADJW a ON (w.CellDN = a.TargetCellDN)
GROUP BY w.RNC_id||w.WCEL_id;
--
DROP TABLE IF EXISTS ADJcount3G;
CREATE TABLE ADJcount3G AS
SELECT DISTINCT
w.WCELName, w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.Banda, w.PLMN_id, w.Sector, w.WBTSName,
w.RNCName, w.RNC_id, w.WBTS_id, w.WCEL_id,w.SectorID, a.adjscount, i.adjicount, g.adjgcount, a1.adjscounti, i1.adjicounti, w1.adjwcounti, l1.adjlcount
FROM (((((WCEL_PARAM1 w LEFT JOIN adjsct a ON (w.RNC_id = a.RNC_id AND w.WCEL_id = a.WCEL_id))
LEFT JOIN adjict i ON (w.RNC_id = i.RNC_id AND w.WCEL_id = i.WCEL_id))
LEFT JOIN adjgct g ON (w.RNC_id = g.RNC_id AND w.WCEL_id = g.WCEL_id))
LEFT JOIN adjscti a1 ON (w.RNC_id = a1.RNC_id AND w.WCEL_id = a1.WCEL_id))
LEFT JOIN adjicti i1 ON (w.RNC_id = i1.RNC_id AND w.WCEL_id = i1.WCEL_id))
LEFT JOIN adjwcti w1 ON (w.RNC_id = w1.RNC_id AND w.WCEL_id = w1.WCEL_id)
LEFT JOIN adjlct l1 ON (w.RNC_id = l1.RNC_id AND w.WCEL_id = l1.WCEL_id)
ORDER BY w.WCELName IS NULL OR w.WCELName='', w.WCELName;
--
--
-- ADJI info
DROP TABLE IF EXISTS adjicustom;
CREATE TABLE adjicustom AS
SELECT
w.WCELName, w1.WCELName AS Target, w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.Banda, w1.Banda AS Bandat, w.Sector, w.WBTSName,
w.RNCName, w.SectorID,i.moVersion,i.distName,i.PLMN_id,i.RNC_id,i.WBTS_id,i.WCEL_id,i.ADJI_id,i.AdjiMCC,i.AdjiMNC,i.TargetCellDN,i.name,
i.AdjiCI,i.AdjiCPICHTxPwr,i.AdjiComLoadMeasDRNCCellNCHO,i.AdjiEcNoOffsetNCHO,
i.AdjiHandlingBlockedCellSLHO,i.AdjiLAC,i.AdjiNCHOHSPASupport,i.AdjiRAC,i.AdjiRNCid,i.AdjiSIB,i.AdjiScrCode,
i.AdjiTxDiv,i.AdjiTxPwrDPCH,i.AdjiTxPwrRACH,i.AdjiUARFCN,i.BlindHOTargetCell,i.NrtHopiIdentifier,i.RtHopiIdentifier,w.UARFCN AS uarfcns,
w1.UARFCN AS uarfcnt
FROM (ADJI i LEFT JOIN WCEL_PARAM1 w ON (i.RNC_id = w.RNC_id AND i.WBTS_id = w.WBTS_id AND i.WCEL_id = w.WCEL_id))
LEFT JOIN WCEL_PARAM1 w1 ON (i.TargetCellDN = w1.CellDN)
ORDER BY w.WCELName IS NULL OR w.WCELName='', w.WCELName;
--
-- ADJI combinations
DROP TABLE IF EXISTS ADJI_COMB;
CREATE TABLE ADJI_COMB AS
SELECT DISTINCT
b.WCELName, w.WCELName AS Target, b.Cluster, b.Region, b.Depto, b.Mun, b.Prefijo, b.Banda, w.Banda AS Bandat, b.Sector, b.WBTSName,
b.RNCName, b.SectorID, b.PLMN_id,b.RNC_id,b.WBTS_id,b.WCEL_id, w.CellDN AS TargetCellDN, w.WCELName AS name, w.CId AS AdjiCI,
w.PtxPrimaryCPICH AS AdjiCPICHTxPwr, w.LAC AS AdjiLAC, w.RAC AS AdjiRAC, w.RNC_id AS AdjiRNCid, w.PriScrCode AS AdjiScrCode,
w.UARFCN AS AdjiUARFCN, b.UARFCN AS uarfcns, a.adjicount, b.AdminCellState, b.WCelState, w.AdminCellState AS AdminCellStateT,
w.WCelState AS WCelStateT
FROM (WCEL_PARAM1 b INNER JOIN WCEL_PARAM1 w ON b.WBTSName = w.WBTSName COLLATE NOCASE)
LEFT JOIN ADJcount3G a ON b.PLMN_id = a.PLMN_id AND b.RNC_id = a.RNC_id AND b.WBTS_id = a.WBTS_id AND b.WCEL_id = a.WCEL_id
WHERE b.WCELName <> w.WCELName AND b.UARFCN <> w.UARFCN
;
--
DROP TABLE IF EXISTS ADJI_Miss;
CREATE TABLE ADJI_Miss AS
SELECT DISTINCT
b.WCELName, b.Target, b.Cluster, b.Region, b.Depto, b.Mun, b.Prefijo, b.Banda, b.Bandat, b.Sector, b.WBTSName,
b.RNCName, b.SectorID, b.PLMN_id,b.RNC_id,b.WBTS_id,b.WCEL_id, b.TargetCellDN, b.name, b.AdjiCI,
b.AdjiCPICHTxPwr, b.AdjiLAC, b.AdjiRAC, b.AdjiRNCid, b.AdjiScrCode,
b.AdjiUARFCN, b.uarfcns, b.adjicount, b.AdminCellState, b.WCelState, b.AdminCellStateT, b.WCelStateT,
w.TargetCellDN AS TargetCellDN_found, w.ADJI_id
FROM ADJI_COMB b LEFT JOIN adjicustom w ON b.PLMN_id = w.PLMN_id AND b.RNC_id = w.RNC_id
AND b.WBTS_id = w.WBTS_id AND b.WCEL_id = w.WCEL_id AND b.TargetCellDN = w.TargetCellDN
WHERE w.ADJI_id IS NULL AND b.AdminCellState = 1 AND b.WCelState = 0 AND b.AdminCellStateT = 1 AND b.WCelStateT = 0
ORDER BY b.Region DESC, b.WCELName;
--
--
DROP TABLE IF EXISTS adjscustom;
CREATE TABLE adjscustom AS
SELECT
w.WCELName, w1.WCELName AS Target, w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.Banda, w1.Banda AS Bandat, w.Sector, w.WBTSName,
w.RNCName, w.SectorID, ad.moVersion, ad.distName, ad.PLMN_id, ad.RNC_id, ad.WBTS_id, ad.WCEL_id, ad.ADJS_id, ad.AdjsMCC, ad.AdjsMNC, ad.TargetCellDN, ad.name,
ad.ADJSChangeOrigin, ad.AdjsCI, ad.AdjsCPICHTxPwr, ad.AdjsDERR, ad.AdjsEcNoOffset, ad.AdjsLAC, ad.AdjsRAC, ad.AdjsRNCid, ad.AdjsSIB,
ad.AdjsScrCode, ad.AdjsTxDiv, ad.AdjsTxPwrRACH, ad.HSDPAHopsIdentifier, ad.NrtHopsIdentifier, ad.RTWithHSDPAHopsIdentifier,
ad.RtHopsIdentifier, ad.SRBHopsIdentifier, w.UARFCN AS uarfcns, w1.UARFCN AS uarfcnt
FROM (ADJS ad LEFT JOIN WCEL_PARAM1 w ON (ad.RNC_id = w.RNC_id AND ad.WBTS_id = w.WBTS_id AND ad.WCEL_id = w.WCEL_id))
LEFT JOIN WCEL_PARAM1 w1 ON (ad.TargetCellDN = w1.CellDN)
ORDER BY w.WCELName IS NULL OR w.WCELName='', w.WCELName;
--
-- ADJS combinations
DROP TABLE IF EXISTS ADJS_COMB;
CREATE TABLE ADJS_COMB AS
SELECT DISTINCT
b.WCELName, w.WCELName AS Target, b.Cluster, b.Region, b.Depto, b.Mun, b.Prefijo, b.Banda, w.Banda AS Bandat, b.Sector, b.WBTSName,
b.RNCName, b.SectorID, b.PLMN_id, b.RNC_id, b.WBTS_id,b.WCEL_id, w.CellDN AS TargetCellDN, w.WCELName AS name, w.CId AS AdjsCI,
w.PtxPrimaryCPICH AS AdjsCPICHTxPwr, w.LAC AS AdjsLAC, w.RAC AS AdjsRAC, w.RNC_id AS AdjsRNCid, w.PriScrCode AS AdjsScrCode,
w.UARFCN AS uarfcnt, b.UARFCN AS uarfcns, a.adjscount, b.AdminCellState, b.WCelState, w.AdminCellState AS AdminCellStateT,
w.WCelState AS WCelStateT
FROM (WCEL_PARAM1 b INNER JOIN WCEL_PARAM1 w ON b.WBTSName = w.WBTSName COLLATE NOCASE)
LEFT JOIN ADJcount3G a ON b.PLMN_id = a.PLMN_id AND b.RNC_id = a.RNC_id AND b.WBTS_id = a.WBTS_id AND b.WCEL_id = a.WCEL_id
WHERE b.WCELName <> w.WCELName AND b.UARFCN = w.UARFCN
;
--
DROP TABLE IF EXISTS ADJS_Miss;
CREATE TABLE ADJS_Miss AS
SELECT DISTINCT
b.WCELName, b.Target, b.Cluster, b.Region, b.Depto, b.Mun, b.Prefijo, b.Banda, b.Bandat, b.Sector, b.WBTSName,
b.RNCName, b.SectorID, b.PLMN_id,b.RNC_id,b.WBTS_id,b.WCEL_id, b.TargetCellDN, b.name, b.AdjsCI,
b.AdjsCPICHTxPwr, b.AdjsLAC, b.AdjsRAC, b.AdjsRNCid, b.AdjsScrCode,
b.uarfcnt, b.uarfcns, b.adjscount, b.AdminCellState, b.WCelState, b.AdminCellStateT, b.WCelStateT,
w.TargetCellDN AS TargetCellDN_found, w.ADJS_id
FROM ADJS_COMB b LEFT JOIN adjscustom w ON b.PLMN_id = w.PLMN_id AND b.RNC_id = w.RNC_id
AND b.WBTS_id = w.WBTS_id AND b.WCEL_id = w.WCEL_id AND b.TargetCellDN = w.TargetCellDN
WHERE w.ADJS_id IS NULL AND b.AdminCellState = 1 AND b.WCelState = 0 AND b.AdminCellStateT = 1 AND b.WCelStateT = 0
ORDER BY b.Region DESC, b.WCELName;
--
