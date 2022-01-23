--
-- daily info
--
DROP TABLE IF EXISTS baselinesite;
CREATE TABLE baselinesite AS
SELECT DISTINCT
b.SITIO AS Sitio, b.AMBIENTE_COBERTURA, b.REGION AS Region,	s.Zona, b.DEPARTAMENTO AS Departamento,	b.MUNICIPIO AS Municipio, b.LOCALIDAD AS LocalidadCRC,
b.GEO_REFERENCIA AS Cluster, b.UBICACION AS Ubicacion, b.LATITUD AS Latitud, b.LONGITUD AS Longitud, b.ALTURA_ESTRUCTURA AS Altura_Estructura,
s."Escenario Configuracion Banda 1900"
FROM baseline AS b LEFT JOIN baseline_Site AS s ON b.SITIO = s.Sitio COLLATE NOCASE;
--
--
DROP TABLE IF EXISTS Baseline_GSM;
CREATE TABLE Baseline_GSM AS
SELECT DISTINCT
b.BTS_NAME,b.BSC_NAME,b.SECTOR,g.Antena,b.ANTENA_TYPE,b.ALTURA_ANTENA,b.AZIMUTH,b.TILT_ELECTRICO,b.TILT_MECANICO,b.TWIST,g.'Map Length',
g.'Map Beam',b.CELLID,b.GRUPO,b.LAC,b.TECNOLOGIA,b.ESTADO,b.FECHA_ESTADO,b.PROVEEDOR,b.REGIONALCLUSTER,b.TIPO_AREA_COBERTURA,b.OWA
FROM baseline AS b LEFT JOIN BaselineGSM AS g ON b.BTS_NAME = g.BTS_Name COLLATE NOCASE
WHERE b.TECNOLOGIA = 'GSM';
--
--
--
DROP TABLE IF EXISTS Baseline_UMTS;
CREATE TABLE Baseline_UMTS AS
SELECT DISTINCT
b.BTS_NAME,b.BSC_NAME,b.SECTOR,g.Antena,b.ANTENA_TYPE,b.ALTURA_ANTENA AS "Altura Antena",b.AZIMUTH,b.TILT_ELECTRICO AS "Tilt Electrico",
b.TILT_MECANICO AS "Tilt Mecanico",b.TWIST,g.'Map Length',
g.'Map Beam',b.CELLID,b.GRUPO,b.LAC,b.TECNOLOGIA,b.ESTADO,b.FECHA_ESTADO,b.PROVEEDOR,b.REGIONALCLUSTER,b.TIPO_AREA_COBERTURA,b.OWA
FROM baseline AS b LEFT JOIN BaselineUMTS AS g ON b.BTS_NAME = g.BTS_Name COLLATE NOCASE
WHERE b.TECNOLOGIA = 'UMTS';
--
--
DROP TABLE IF EXISTS Baseline_LTE;
CREATE TABLE Baseline_LTE AS
SELECT DISTINCT
b.BTS_NAME AS LNB,b.BSC_NAME,b.SECTOR,g.Antena,b.ANTENA_TYPE,b.ALTURA_ANTENA AS "Altura Antena",b.AZIMUTH,b.TILT_ELECTRICO AS "Tilt Electrico",
b.TILT_MECANICO AS "Tilt Mecanico",b.TWIST,g.'Map Length',
g.'Map Beam',b.CELLID,b.GRUPO,b.LAC,b.TECNOLOGIA,b.ESTADO,b.FECHA_ESTADO,b.PROVEEDOR,b.REGIONALCLUSTER,b.TIPO_AREA_COBERTURA,b.OWA
FROM baseline AS b LEFT JOIN BaselineLTE AS g ON b.BTS_NAME = g.LNB COLLATE NOCASE
WHERE b.TECNOLOGIA = 'LTE';
--
--
--BTS parameters importantes OK
--
--
DROP TABLE IF EXISTS adjwcto;
CREATE TABLE adjwcto AS
SELECT
b.PLMN_id, b.BSC_id, b.BCF_id, b.BTS_id, COUNT(a.ADJW_id) AS adjwcounto
FROM BTS b LEFT JOIN ADJW a ON b.PLMN_id = a.PLMN_id AND b.BSC_id = a.BSC_id AND b.BCF_id = a.BCF_id AND b.BTS_id = a.BTS_id
GROUP BY b.PLMN_id||b.BSC_id||b.BCF_id||b.BTS_id;
--
--half radius for caberera sites
--
DROP TABLE IF EXISTS BTS_PARAM;
CREATE TABLE BTS_PARAM AS
SELECT DISTINCT
BTS.name AS BTSname, B.Cluster, B.Region, B.Departamento AS Depto, B.Municipio AS Mun,
substr(BTS.name,1,3) AS Prefijo, substr(BTS.name,-1,1) AS sector,
BTS.PLMN_Id, BTS.bsc_Id, BTS.bcf_Id, BTS.bts_Id, BTS.cellId, POC.bsTxPwrMax, POC.bsTxPwrMax1x00, BTS.segmentId, BTS.nwName, BSC.name AS BSCname, BCF.name AS BCFname,
TRX.initialFrequency, 1*(BTS.bsIdentityCodeNCC || BTS.bsIdentityCodeBCC) AS BSIC, BTS.bsIdentityCodeNCC, BTS.bsIdentityCodeBCC, BTS.locationAreaIdLAC,
BTS.usedMobileAllocation, BCF.adminState AS BCF_AdSt, BTS.adminState AS BTS_AdSt, BTS.rac, CASE WHEN TRX.initialFrequency < 512 THEN 850 ELSE 1900 END AS BandName,
"PLMN-" || BTS.PLMN_Id || "/BSC-" || BTS.BSC_Id || "/BCF-" || BTS.BCF_Id || "/BTS-" || BTS.BTS_Id AS DistName,
BTS.gsmPriority, BTS.wcdmaPriority, BTS.utranQualRxLevelMargin, BTS.utranThresholdReselection, BTS.timeHysteresis, BTS.qSearchI, BTS.qSearchP, BTS.fddQOffset,
BTS.fddQMin, BTS.rxLevAccessMin, BTS.gprsRxlevAccessMin, BTS.radioLinkTimeout, BTS.radioLinkTimeoutAmr, BTS.msMaxDistInCallSetup,
B.Latitud AS Deci_Lat, B.Longitud AS Deci_Lon, BTS.bcf_Id AS Mtx_Site, BTS.bts_Id AS Mtx_Site_ID, BTS.name AS Site_Name,
h.hoPeriodPbgt, h.hoPeriodUmbrella, h.qSearchC, h.rxLevel,
CASE WHEN substr(BTS.name,-1,1) = 'A' THEN 1 ELSE (CASE WHEN substr(BTS.name,-1,1) = 'B' THEN 2 ELSE (CASE WHEN substr(BTS.name,-1,1) = 'C' THEN 3
ELSE (CASE WHEN substr(BTS.name,-1,1) = 'D' THEN 4 ELSE (CASE WHEN substr(BTS.name,-1,1) = 'E'
THEN 5 ELSE (CASE WHEN (1*substr(BTS.name,-1,1)) < 9 THEN substr(BTS.name,-1,1) ELSE NULL END)END)END)END)END)END AS sector_ID,
CASE WHEN TRX.initialFrequency < 512 THEN
(CASE WHEN G.'Map Length' < 3 THEN
(CASE WHEN B.Zona = 'Cabecera' THEN 40 ELSE 80 END)
ELSE
(CASE WHEN B.Zona = 'Cabecera' THEN 17*G.'Map Length' ELSE 35*G.'Map Length' END) END)
ELSE
(CASE WHEN G.'Map Length' < 3 THEN
(CASE WHEN B.Zona = 'Cabecera' THEN 30 ELSE 60 END)
ELSE
(CASE WHEN B.Zona = 'Cabecera' THEN (17*G.'Map Length' - 15) ELSE (35*G.'Map Length' - 30) END) END)
END AS Radius,
CASE WHEN TRX.initialFrequency < 512 THEN (CASE WHEN G.'Map Beam' < 65 THEN 40 ELSE (G.'Map Beam' - 15) END) ELSE (CASE WHEN G.'Map Beam' < 65 THEN 50
ELSE G.'Map Beam' END) END AS Beamwidth, G.Azimuth, a.adjwcounto
FROM ((((((BTS LEFT JOIN POC ON (BTS.BSC_Id = POC.BSC_Id) AND (BTS.BCF_Id = POC.BCF_Id) AND (BTS.BTS_Id = POC.BTS_Id))
LEFT JOIN BCF ON (BTS.BSC_Id = BCF.BSC_Id) AND (BTS.BCF_Id = BCF.BCF_Id)) LEFT JOIN BSC ON (BTS.BSC_Id = BSC.BSC_Id))
LEFT JOIN HOC h ON (BTS.BSC_Id = h.BSC_Id) AND (BTS.BCF_Id = h.BCF_Id) AND (BTS.BTS_Id = h.BTS_Id))
LEFT JOIN baselinesite AS B ON (BCF.Name = B.Sitio COLLATE NOCASE)) LEFT JOIN Baseline_GSM AS G ON (BTS.name = G.BTS_NAME COLLATE NOCASE))
LEFT JOIN TRX ON (BTS.BSC_Id = TRX.BSC_Id) AND (BTS.BCF_Id = TRX.BCF_Id) AND  (BTS.BTS_Id = TRX.BTS_Id)
LEFT JOIN adjwcto a ON (BTS.BSC_Id = a.BSC_Id) AND (BTS.BCF_Id = a.BCF_Id) AND  (BTS.BTS_Id = a.BTS_Id)
WHERE ((TRX.channel0Type)=4)
ORDER BY BTS.name;
--
--
--
--
--NR
--
--
DROP TABLE IF EXISTS NRBTS_Full;
CREATE TABLE NRBTS_Full AS
SELECT DISTINCT
N.name AS NRBTSname, B.Cluster, B.Region, B.Departamento AS Depto, B.Municipio AS Mun,
substr(N.name,1,3) AS Prefijo,
N.PLMN_id,N.MRBTS_id,N.NRBTS_id,N.moVersion,N.siteTemplateName AS siteTemplateNameB ,N.gNbCuName,N.actA2SgnbRelease,N.actBlacklistingEutranCell,N.actCMAS,N.actCarrierAggregation,N.actCellTraceReport,N.actConflictConfiguration,N.actCoverageNonCoherentUes,N.actDataDuplicationForMobility,N.actDataDuplicationForSAMobility,N.actDlDataForwardingX2,N.actDlDataForwardingX2Limit,N.actEcpriPhase2,N.actEcpriPhase3,N.actEmergencyFallback,N.actEnhancedLinkAdaptation,N.actFdmScheduling,N.actGeneralConnectivityBronze,N.actGeneralConnectivityGold,N.actGeneralConnectivitySilver,N.actGnbInitRlf,N.actGrflShdn,N.actInactDetNSAUe,N.actIncXn,N.actInterFreqHoSA,N.actInterFreqInterGnbMobilityNSA,N.actInterFreqIntraGnbMobilityNSA,N.actInterMeNBMobility,N.actInterRatHoSA,N.actInterRatHoSADlDataForward,N.actIntraFreqHoSA,N.actIntraFreqInterGnbMobilityNSA3x,N.actIntraFreqIntraGnbMobilityNSA,N.actIntraMeNBMobility,N.actLteNrDss,N.actMFBIEutra,N.actMicroDTX,N.actMobilityRetryToSecondBestCell,N.actMultVlan,N.actMultiDrbNSA,N.actNgcFlexSaMode,N.actNonGbrServiceDiff,N.actNormVCFallback,N.actOAMResiliency,N.actPCMDReport,N.actPaging,N.actPrachMultiplexing,N.actRanSharing,N.actRedirect,N.actRrcInactiveState,N.actSACallProcessingDU,N.actSecDataUsageRep,N.actSrvcAvaReporting,N.actTddPrePooling,N.actTimeAlignExtension,N.actTrsNetworkSlicing,N.actTrsSepaNSARanSharing,N.actTrsSepaSARanSharing,N.actUECapaHandlingSAMode,N.actUESpecificULResCoordination,N.actUeDeltaConfigOptimize,N.actUeInitRlf,N.activityNotificationLevelSA,N.cPlaneDscp,N.caConfigurationSupport,N.drbInactivityTimerSA,N.drxDefaultPaging,N.enDcX2SetupReqTmr,N.endMarkerTimer,N.forceSingleTxModeSupportEnabled,N.gNbCuType,N.gNbIdLength,N.gtpuManagementDscp,N.keyRefrMarg,N.maxNumF1Links,N.maxNumX2Links,N.maxNumXnLinks,N.maxNumXnSetupRetry,N.maxParallelXnSetup,N.maxX2EnDcCfUpRetry,N.maxX2PartialResetReqRetry,N.maxXnNgRanCfUpRetry,N.mcc,N.mnc,N.mncLength,N.n310,N.n311,N.ngSetupRespTmr,N.ngUeRetentionEnabled,N.ngUeRetentionTmr,N.nsaActivityNotificationLevel,N.nsaCellActivationAlarmTimer,N.nsaInactivityTimer,N.nullFallback,N.operationalState,N.pdschRat0RbgConfig,N.pduSessionEndMarkerTimer,N.periodicBSRTimer,N.periodicalDataUsageReportTimer,N.pfaTargetPRACH,N.retryXnSetupTmr,N.rrcReestabTypeSA,N.sCCNumber,N.saCellActivationAlarmTimer,N.sgnbRelForNoHandoverEnabled,N.shutdownNoX2TrafficTmr,N.shutdownNoXnTrafficTmr,N.shutdownNogNBCellTmr,N.shutdownStepAmount,N.shutdownWindow,N.singleTXModeSupportEnabled,N.srb1Config,N.srb3SupportEnabled,N.srbInactivityTimerSA,N.srvcDownDetectTimer,N.t304,N.t310,N.t311,N.tDCoverall,N.tDiscardLteTimer,N.tRLFindForDU,N.tWaitingRlRecover,N.timerHOGuard,N.timerNGSignalingConnGuard,N.timerRRCGuard,N.timerRejectWait,N.timerX2UeProcGuard,N.timerXnUeProcGuard,N.tmpParam7,N.variableSourceUdpPortEnabled,N.waitForRecovBeforeCellBarringTimer,N.x2EnDcCfUpNbInfoBackOffTmr,N.x2EnDcCfUpRdmDelayTmr,N.x2EnDcCfUpRspTmr,N.x2EndMarkerTimer,N.x2LinkReestabTmr,N.x2LinkSupervisionTmr,N.x2PartialResetCnfTmr,N.x2ResetRspTmr,N.xnLinkReestabTmr,N.xnNgRanCfUpNbInfoBackOffTmr,N.xnNgRanCfUpRdmDelayTmr,N.xnNgRanCfUpRspTmr,N.xnResetRespTmr,N.xnSetupReqTmr,N.xnSetupRespTmr,N.actDrbProfNonGbrServiceDiff,N.actInterFreqInterGnbMobilitySA,N.timerX2DataFwdGuard,N.actCpclResiliency,N.actCpnrtResiliency,N.actNetworkSlicing,N.actVemResiliency,N.cpclRedundancyLevel,N.e1CLinkStatusCuCp,N.mPlaneDscp,N.maxNoCPUEVMs,N.maxNumOfUsersPerCpCell,N.maxParallelIncXnSetup,N.ratType,N.rlResumeBackOffTmr,N.rrcGuardTimer
FROM NRBTS AS N LEFT JOIN baselinesite AS B ON (B.Sitio = N.name COLLATE NOCASE)
ORDER BY N.name IS NULL OR N.name='', N.name;
--
--
DROP TABLE IF EXISTS NRCELL_Full;
CREATE TABLE NRCELL_Full AS
SELECT DISTINCT
N1.name AS NRCELLNAME, N.NRBTSname, N.Cluster, N.Region, N.Depto, N.Mun, N.Prefijo, N1.physCellId, N1.nrCellIdentity,N1.nrCellType,N1.prachConfigurationIndex,N1.prachRootSequenceIndex, N1.pMax,N1.pMaxNROwnCell, N1.freqBandIndicatorNR, N1.lcrId, N1.timingAdvanceOffset,N1.totalNumberOfRAPreambles,N1.chBw,N1.nrarfcn,N2.chBwDl,N2.chBwUl,N2.nrarfcnDl,N2.nrarfcnUl,
N.siteTemplateNameB,N.gNbCuName, N1.siteTemplateName AS siteTemplateNameC, N1.cellName,
N1.PLMN_id,N1.MRBTS_id,N1.NRBTS_id,N1.NRCELL_id,N1.moVersion,N1.a1MeashoEnabled,N1.a2MeasRedirectEnabled,N1.a2MeashoEnabled,N1.a3MeasEnabled,N1.a5MeasEnabled,N1.absThreshSsbRsrpConsolidation,N1.actAperCsi,N1.actBeamforming,N1.actCDrx,N1.actDl256Qam,N1.actDlMuMimo,N1.actDynUlDataSplitMode,N1.actEirpControl,N1.actExternalAntennaBF,N1.actPRBBlanking,N1.actPcsiOnF2Fdm,N1.actRrcReconfigAtBeamSwitch,N1.actSUL,N1.actSrsBmGoB,N1.actUlMuMimo,N1.administrativeState,N1.aggregationLevel,N1.beamManagementType,N1.cbraPreamblesPerSsb,N1.ccLoadThreshold,N1.cellBarred,N1.cellDepType,N1.cellIndividualSsbRsrpOffset,N1.cellIndividualSsbRsrqOffset,N1.cellReselectionPriority,N1.cellReservedForOperatorUse,N1.cellReservedForOtherUse,N1.cellTechnology,N1.configuredEpsTac,N1.dciSiAggregationLevel,N1.dedicatedSib1,N1.dlDMRSAdditionalPosition,N1.dlMimoMode,N1.dlMuMaxNumPairedUEs,N1.dlQam256PowerBackoffSub6,N1.dllaBlerTarget,N1.dllaDeltaCqiMax,N1.dllaDeltaCqiMin,N1.dllaDeltaCqiStepdown,N1.dllaIniMcs,N1.dmrsTypeAPosition,N1.drxWactDlEnabled,N1.drxWactUlEnabled,N1.eirpControlTimeAveragingWindowStepSize,N1.enDcSyncStatus,N1.expectedCellSize,N1.filterCoeffSsbRsrp,N1.filterCoeffSsbRsrq,N1.frequencyDensityThresNrb0,N1.frequencyDensityThresNrb1,N1.gapOffset,N1.gscn,N1.ifhoSsbSmtcOffset,N1.initialPreambleReceivedTargetPower,N1.intraFreqReselection,N1.lteNrDssMode,N1.lteToNrTimeOffset,N1.mMimoAntArrayMode,N1.maxNumOfNonGBRBearersSA,N1.maxNumOfRrcSA,N1.maxNumOfSCellAlloc,N1.maxNumOfUsersNRCell,N1.maxNumOfUsersPerCell,N1.mcsIndexForArtificialLoad,N1.measGapSelection,N1.modPeriodCoeff,N1.msg1FrequencyStart,N1.msg3DeltaPreamble,N1.n310,N1.n311,N1.nbrOfBlankedPRBsHighEdgeDL,N1.nbrOfBlankedPRBsHighEdgeUL,N1.nbrOfBlankedPRBsLowEdgeDL,N1.nbrOfBlankedPRBsLowEdgeUL,N1.nbrOfSsbPerRachOccasion,N1.nrofHARQProcessesForPDSCH,N1.numOfPagingFrames,N1.numOfSubSectors,N1.numPagingOccsnPagingFrame,N1.operationalState,N1.pagingOffset,N1.powerRampingStep,N1.powerRampingStepHighPriorityCfra,N1.prachSequenceType,N1.preambleTransMax,N1.proceduralStatus,N1.pucchDataDtxNumOfSamples,N1.pucchF3MaxCodeRate,N1.pucchF3ModulationScheme,N1.pucchModeSelect,N1.puschDataDtxNumOfSamples,N1.puschMappingType,N1.qRxLevMin,N1.raContentionResolutionTmr,N1.raResponseWindow,N1.reportAmount,N1.reportInterval,N1.reportOnLeave,N1.reqMinNumPuschPrb,N1.rlResumeBackOffTmr,N1.rlResumePathLossThreshold,N1.rlResumeSinrThreshold,N1.rloConsecDtxThreshold,N1.rloDtxRatioThreshold,N1.rloPathLossThreshold,N1.rloSinrThreshold,N1.rlpDetCsiBsiThreshold,N1.rlpDetDlHarqThreshold,N1.rlpRecCsiBsiThreshold,N1.rlpRecDlHarqThreshold,N1.rsrpThresholdSSB,N1.sMeasConfigSsbRsrp,N1.srPeriodicity,N1.srsBmCombOffset,N1.srsBmCyclicShiftOffset,N1.srsBmNumCyclicShiftsPerComb,N1.srsBmSubbandOffset,N1.ssPbchBlockPower,N1.ssbScs,N1.t300,N1.t301,N1.t310,N1.t311,N1.t319,N1.targetSUOMeNBULSubframes,N1.targetTotalLoad,N1.trsMutingInBlankedPRBsEnabled,N1.type0CoresetConfigurationIndex,N1.type0SearchSpaceConfigurationIndex,N1.ulDMRSAdditionalPosition,N1.ulMimoMode,N1.ulMuLowSinrThreshold,N1.ulMuMaxNumPairedUEs,N1.ulMuPairingThreshold,N1.ullaBlerTarget,N1.ullaDeltaSinrMax,N1.ullaDeltaSinrMin,N1.ullaDeltaSinrStepdown,N1.ullaIniMcs,N1.voiceFBMode,N1.zeroCorrelationZoneConfig,N1.a2MeasReleaseEnabled,N1.oldDN,N1.availabilityStatus,N1.fiveGsTac,N1.ssbSmtc1Duration,N1.ssbSmtc1Offset,N1.ssbSmtc1Periodicity,N1.trackingAreaDN,
N4.a3HysteresisSsbRsrp,N4.a3OffsetSsbRsrp,N4.a3TimeToTriggerSsbRsrp,
N5.actUlOpenLoopPwrCtrl,N5.alpha,N5.alphaSrs,N5.p0NominalPucch,N5.p0NominalPucchF1F3,N5.p0NominalPusch,N5.p0NominalSrs,N5.pucchF1DeltaF,N5.pucchF3DeltaF,
N6.drxInactivityTimer,N6.drxLongCycle,N6.drxOnDurationTimer,N6.drxRetransTimerDl,N6.drxRetransTimerUl,
N3.csirsTrackingPeriod,N3.rbAllocation,N3.firstRE,N3.numUeSupportedTrsOverall,N3.numUeSupportedTrsPerCarrier,N3.startRB,
N2.NRCELL_FDD_id,N2.moVersion
FROM (((((NRBTS_Full AS N LEFT JOIN NRCELL AS N1 ON (N.PLMN_id = N1.PLMN_id AND N.MRBTS_id = N1.MRBTS_id AND N.NRBTS_id = N1.NRBTS_id)) LEFT JOIN NRCELL_A3MEASSSBRSRP AS N4 ON (N4.PLMN_id = N1.PLMN_id AND N4.MRBTS_id = N1.MRBTS_id AND N4.NRBTS_id = N1.NRBTS_id AND N4.NRCELL_id = N1.NRCELL_id)) LEFT JOIN NRCELL_ULPOWERCONTROLCOMMON AS N5 ON (N5.PLMN_id = N1.PLMN_id AND N5.MRBTS_id = N1.MRBTS_id AND N5.NRBTS_id = N1.NRBTS_id AND N5.NRCELL_id = N1.NRCELL_id)) LEFT JOIN NRCELL_DRXPROFILE1 AS N6 ON (N6.PLMN_id = N1.PLMN_id AND N6.MRBTS_id = N1.MRBTS_id AND N6.NRBTS_id = N1.NRBTS_id AND N6.NRCELL_id = N1.NRCELL_id)) LEFT JOIN NRCELL_CSIRSFORTRACKING AS N3 ON (N3.PLMN_id = N1.PLMN_id AND N3.MRBTS_id = N1.MRBTS_id AND N3.NRBTS_id = N1.NRBTS_id AND N3.NRCELL_id = N1.NRCELL_id)) LEFT JOIN NRCELL_fdd AS N2 ON (N2.PLMN_id = N1.PLMN_id AND N2.MRBTS_id = N1.MRBTS_id AND N2.NRBTS_id = N1.NRBTS_id AND N2.NRCELL_id = N1.NRCELL_id)
ORDER BY N1.name IS NULL OR N1.name='', N1.name;
--
--
--
--
--WBTS_Full1
DROP TABLE IF EXISTS WBTS_Full1;
CREATE TABLE WBTS_Full1 AS
SELECT DISTINCT
substr(WBTS.name,1,3) AS Prefijo, RNC.name AS RNCName, B.Cluster, B.Region, B.Departamento AS Depto, B.Municipio AS Mun, WBTS.PLMN_id,WBTS.RNC_id,WBTS.WBTS_id,WBTS.moVersion,WBTS.BTSAdditionalInfo,WBTS.BTSIPAddress,WBTS.BTSSupportForHSPACM,WBTS.BlindHOIntraBTSQCheck,WBTS.Cell240kmCapability,WBTS.DCNLinkStatus,WBTS.DCNSecurityStatus,WBTS.DLORLAveragingWindowSize,WBTS.DSCPHigh,WBTS.DSCPLow,WBTS.DSCPMedDCH,WBTS.DSCPMedHSPA,WBTS.DediMeasRepPeriodCSdata,WBTS.DediMeasRepPeriodPSdata,WBTS.DedicatedMeasReportPeriod,WBTS.DelayThresholdMax,WBTS.DelayThresholdMax2msTTI,WBTS.DelayThresholdMid,WBTS.DelayThresholdMid2msTTI,WBTS.DelayThresholdMin,WBTS.DelayThresholdMin2msTTI,WBTS.FreqChangeCapability,WBTS.HARQRVConfiguration,WBTS.HSDPA14MbpsPerUser,WBTS.HSDPACCEnabled,WBTS.HSDPAULCToDSCP,WBTS.HSUPACCEnabled,WBTS.HSUPADLCToDSCP,WBTS.HSUPAXUsersEnabled,WBTS.IPBasedRouteIdIub,WBTS.IPBasedRouteIdIub2,WBTS.IPBasedRouteIdIub3,WBTS.IPBasedRouteIdIub4,WBTS.IPNBId,WBTS.InactCACThresholdATM,WBTS.InactCACThresholdIP,WBTS.InactUsersCIDThreshold,WBTS.IntelligentSDPrioHO,WBTS.IubTransportSharing,WBTS.LoadControlPeriodPS,WBTS.MaxBTSOMFrameSize,WBTS.MaxFPDLFrameSizeForIPv6Iub,WBTS.MaxFPDLFrameSizeIub,WBTS.MaxNumberEDCHLCG,WBTS.MeasFiltCoeff,WBTS.MinUDPPortIub,WBTS.NESWVersion,WBTS.NEType,WBTS.NodeBRABReconfigSupport,WBTS.OverbookingSwitch,WBTS.PDUSize656WithHSDSCH,WBTS.PSAveragingWindowSize,WBTS.PSRLAveragingWindowSize,WBTS.PWSMAVTrafficVERLogic,WBTS.PWSMEnableWakeUpTime,WBTS.PWSMInUse,WBTS.PWSMRemCellSDBeginHour,WBTS.PWSMRemCellSDBeginMin,WBTS.PWSMRemCellSDEndHour,WBTS.PWSMRemCellSDEndMin,WBTS.PWSMShutdownBeginHour,WBTS.PWSMShutdownBeginMin,WBTS.PWSMShutdownEndHour,WBTS.PWSMShutdownEndMin,WBTS.PWSMWeekday,WBTS.ProbabilityFactorMax,WBTS.ProbabilityFactorMax2msTTI,WBTS.PrxAlpha,WBTS.PrxMeasAveWindow,WBTS.PrxTargetPSAdjustPeriod,WBTS.PtxAlpha,WBTS.PtxDPCHmax,WBTS.PtxDPCHmin,WBTS.PtxMeasAveWindow,WBTS.RACHloadIndicationPeriod,WBTS.RFSharingState,WBTS.RRIndPeriod,WBTS.RRMULDCHActivityFactorCSAMR,WBTS.RRMULDCHActivityFactorCSNTData,WBTS.RRMULDCHActivityFactorCSTData,WBTS.RRMULDCHActivityFactorPSBackgr,WBTS.RRMULDCHActivityFactorPSStream,WBTS.RRMULDCHActivityFactorPSTHP1,WBTS.RRMULDCHActivityFactorPSTHP2,WBTS.RRMULDCHActivityFactorPSTHP3,WBTS.RRMULDCHActivityFactorSRB,WBTS.SchedulingPeriod,WBTS.TQMId,WBTS.TQMId2,WBTS.TQMId3,WBTS.TQMId4,WBTS.ToAWEOffsetNRTDCHIP,WBTS.ToAWEOffsetRTDCHIP,WBTS.ToAWSOffsetNRTDCHIP,WBTS.ToAWSOffsetRTDCHIP,WBTS.WBTSChangeOrigin,WBTS.WBTSName,WBTS.WBTSSWBuildId,WBTS.WinACRABsetupDL,WBTS.WinACRABsetupUL,WBTS.WinLCHSDPA,WBTS.WinLCHSUPA,WBTS.siteTemplateName,WBTS.SBTSId,WBTS.DLCECapacity,WBTS.HSDPACodeCapacity,WBTS.ULCECapacity,WBTS.bburruFlag,WBTS.nbrRepeater,WBTS.numFa,WBTS.type,WBTS.linkedMrsiteDN,WBTS.BTSRACHCapaIncCapability,WBTS.autoConfMode,WBTS.autoConfPlanReady,WBTS.autoConfStatus,WBTS.autoConfPlanName,WBTS.ATMInterfaceID,WBTS.COCOId,WBTS.IubTransportMedia,WBTS.NbrOfOverbookedHSDPAUsers,WBTS.ReleaseTimerForSharedHSDPAallocation,WBTS.SharedHSDPAVCCSelectionMethod,WBTS.SharedHSDPAallocation,WBTS.VCI,WBTS.VPI,WBTS.BroadcastSIB15,WBTS.BroadcastSIB15_2,WBTS.BroadcastSIB15_3,WBTS.EnhOLPCRTWPEnabled,WBTS.MDCBufferingTime,WBTS.SatelliteIubUsage,WBTS.ICBULUPHReportPeriod,WBTS.oldDN,WBTS.ManagedBy,WBTS.UserDefinedState
FROM (RNC LEFT JOIN WBTS ON RNC.RNC_id = WBTS.RNC_id) LEFT JOIN baselinesite AS B ON (B.Sitio = WBTS.name COLLATE NOCASE)
ORDER BY WBTS.name;
--
--
--
--
--LNBTS full
DROP TABLE IF EXISTS LNBTS_Full;
CREATE TABLE LNBTS_Full AS
SELECT DISTINCT
LNBTS.name AS LNBTSname, B.Cluster, B.Region, B.Departamento AS Depto, B.Municipio AS Mun,
substr(LNBTS.name,1,3) AS Prefijo, LNBTS.PLMN_id, LNBTS.MRBTS_id,LNBTS.LNBTS_id,LNBTS_FDD.LNBTS_FDD_id,LNBTS_FDD.moVersion,LNBTS_FDD.act1xSrvcc,LNBTS_FDD.actConvVoice,LNBTS_FDD.actDedFreqListsLB,LNBTS_FDD.actDedVoLteInterFreqHo,LNBTS_FDD.actDlIntShaping,LNBTS_FDD.actDualBand,LNBTS_FDD.actFlexBbUsage,LNBTS_FDD.actHighPrioServices,LNBTS_FDD.actHighRrc,LNBTS_FDD.actIMSEmerSessR9,LNBTS_FDD.actInDevCoexLaa,LNBTS_FDD.actInterFreqServiceBasedHo,LNBTS_FDD.actMFBI,LNBTS_FDD.actMultefire,LNBTS_FDD.actPeriodicCarrierBlinking,LNBTS_FDD.actPubSafetyBearers,LNBTS_FDD.actSfn,LNBTS_FDD.actSrvccToGsm,LNBTS_FDD.actSrvccToWcdma,LNBTS_FDD.actTempRadioMaster,LNBTS_FDD.actUnlicensedAcc,LNBTS_FDD.actUnlicensedDfs,LNBTS_FDD.actUtranLoadBal,LNBTS_FDD.numTxWithHighNonGbr,LNBTS_FDD.preventPsHOtoWcdma,LNBTS_FDD.actOptimizedBbUsage,LNBTS_FDD.actProSeComm,LNBTS_FDD.actUnlicensedDcs,LNBTS_FDD.maxBtsTimeError,LNBTS_FDD.actDistributedSite,LNBTS_FDD.tempRadioMasterRecovTime,LNBTS_FDD.tempRadioMasterTriggerTime,LNBTS_FDD.actLaaDpc,LNBTS_FDD_CIOTEPSPLMNIDLIST.attachNoPDNConn,LNBTS_FDD_CIOTEPSPLMNIDLIST.mcc,LNBTS_FDD_CIOTEPSPLMNIDLIST.mnc,LNBTS_FDD_CIOTEPSPLMNIDLIST.mncLength,LNBTS.moVersion,LNBTS.mcc,LNBTS.mnc, LNBTS.siteTemplateName,LNBTS.act1xCsfb,LNBTS.act8EpsBearers,LNBTS.actA3ScellSelect,LNBTS.actAcSrvcc,LNBTS.actAdvScellMeas,LNBTS.actAnrRtt,LNBTS.actArpBasedQosProfiling,LNBTS.actAutoAcBarring,LNBTS.actAutoPlmnRemoval,LNBTS.actCMAS,LNBTS.actCSFBRedir,LNBTS.actCellTrace,LNBTS.actCellTraceWithIMSI,LNBTS.actCiphering,LNBTS.actCompChecks,LNBTS.actCplaneOvlHandling,LNBTS.actCsfbPsHoToUtra,LNBTS.actCsgS1Mobility,LNBTS.actDLCAggr,LNBTS.actDualRx1xCsfb,LNBTS.actERabModify,LNBTS.actETWS,LNBTS.actEmerCallRedir,LNBTS.actEnhAcAndGbrServices,LNBTS.actExtMeasCtrl,LNBTS.actFlexQCIARPPMProfiles,LNBTS.actFlexScellSelect,LNBTS.actGsmRedirWithSI,LNBTS.actHOtoHrpd,LNBTS.actHOtoWcdma,LNBTS.actHeNBMobility,LNBTS.actHeNBS1Mobility,LNBTS.actHoFromUtran,LNBTS.actIdleLB,LNBTS.actIdleLBCaAware,LNBTS.actIfHo,LNBTS.actImmHRPD,LNBTS.actImmXrtt,LNBTS.actInterEnbDLCAggr,LNBTS.actInterFreqRstdMeasSupp,LNBTS.actL1PM,LNBTS.actLBPowerSaving,LNBTS.actLPPaEcid,LNBTS.actLPPaOtdoa,LNBTS.actLTES1Ho,LNBTS.actLocRep,LNBTS.actMBMS,LNBTS.actMDTCellTrace,LNBTS.actMDTSubscriberTrace,LNBTS.actMDTloggedCellTrace,LNBTS.actMeasBasedIMLB,LNBTS.actMmecPlmnIdMmeSelection,LNBTS.actMroInterRatUtran,LNBTS.actMultBearers,LNBTS.actMultGbrBearers,LNBTS.actMultipleCarrier,LNBTS.actNonGbrServiceDiff,LNBTS.actNwReqUeCapa,LNBTS.actOTNRecovery,LNBTS.actOperatorQCI,LNBTS.actOperatorQCIGBR,LNBTS.actOptMmeSelection,LNBTS.actPartialAcHo,LNBTS.actPdcpRohc,LNBTS.actQCIPLMNIDProfiles,LNBTS.actRIMforGSM,LNBTS.actRIMforUTRAN,LNBTS.actRLFReportEval,LNBTS.actRLFbasedRCR,LNBTS.actRRCConnReestablRLF,LNBTS.actRSRPRSRQHist,LNBTS.actRadioPosFlexibility,LNBTS.actRedirect,LNBTS.actRrcConnNoActivity,LNBTS.actRsrqInterFreqMobility,LNBTS.actRtPerfMonitoring,LNBTS.actS1Flex,LNBTS.actS1OlHandling,LNBTS.actSatBackhaul,LNBTS.actSdl,LNBTS.actSelMobPrf,LNBTS.actServBasedMobThr,LNBTS.actSubscriberTrace,LNBTS.actTaHistCounters,LNBTS.actTempHoBlacklisting,LNBTS.actUeBasedAnrInterFreqLte,LNBTS.actUeBasedAnrIntraFreqLte,LNBTS.actUeBasedAnrUtran,LNBTS.actUeLevelMro,LNBTS.actUeLocInfo,LNBTS.actUeThroughputMeas,LNBTS.actUplaneOvlHandling,LNBTS.actUserLayerTcpMssClamping,LNBTS.actVendSpecCellTraceEnh,LNBTS.actZUC,LNBTS.actZson,LNBTS.acteNACCtoGSM,LNBTS.amRlcPBTab1dlPollByte,LNBTS.amRlcPBTab1ueCategory,LNBTS.amRlcPBTab1ulPollByte,LNBTS.amRlcPBTab2dlPollByte,LNBTS.amRlcPBTab2ueCategory,LNBTS.amRlcPBTab2ulPollByte,LNBTS.amRlcPBTab3dlPollByte,LNBTS.amRlcPBTab3ueCategory,LNBTS.amRlcPBTab3ulPollByte,LNBTS.amRlcPBTab4dlPollByte,LNBTS.amRlcPBTab4ueCategory,LNBTS.amRlcPBTab4ulPollByte,LNBTS.amRlcPBTab5dlPollByte,LNBTS.amRlcPBTab5ueCategory,LNBTS.amRlcPBTab5ulPollByte,LNBTS.anrOmExtEnable,LNBTS.btsType,LNBTS.caMinDlAmbr,LNBTS.eea0,LNBTS.eea1,LNBTS.eea2,LNBTS.eea3,LNBTS.congWeightAlg,LNBTS.cpovlhaenableInHoRed,LNBTS.cpovlhaenableRrcConnRed,LNBTS.defProfIdxAM,LNBTS.defProfIdxUM,LNBTS.dynBlacklistingHoTimer,LNBTS.enableAutoLock,LNBTS.enableBwCombCheck,LNBTS.enableGrflShdn,LNBTS.enbName,LNBTS.etwsPrimNotifBcDur,LNBTS.forcedPlanFileActivation,LNBTS.geranDtmCap,LNBTS.eia0,LNBTS.eia1,LNBTS.eia2,LNBTS.eia3,LNBTS.keyRefrMarg,LNBTS.maxNumAnrMoiAllowed,LNBTS.maxNumOfLnadjLimit,LNBTS.maxNumPreEmptions,LNBTS.mmeAssignmentMode,LNBTS.moProfileSelect,LNBTS.multScellReleaseTimer,LNBTS.nConsecHOPrepTimeouts,LNBTS.nCqiDtx,LNBTS.nCqiRec,LNBTS.neighbCellChkPeriodicity,LNBTS.neighbCellChkStartTime,LNBTS.nullFallback,LNBTS.operationalState,LNBTS.otnRecoveryPeriod,LNBTS.pbrNonGbr,LNBTS.pdcpProf1pdcpProfileId,LNBTS.pdcpProf1snSize,LNBTS.pdcpProf1statusRepReq,LNBTS.pdcpProf1tDiscard,LNBTS.pdcpProf101pdcpProfileId,LNBTS.pdcpProf101rohcMaxCid,LNBTS.pdcpProf101snSize,LNBTS.pdcpProf101tDiscard,LNBTS.pdcpProf102pdcpProfileId,LNBTS.pdcpProf102snSize,LNBTS.pdcpProf102tDiscard,LNBTS.pdcpProf103pdcpProfileId,LNBTS.pdcpProf103snSize,LNBTS.pdcpProf103tDiscard,LNBTS.pdcpProf104pdcpProfileId,LNBTS.pdcpProf104snSize,LNBTS.pdcpProf104tDiscard,LNBTS.pdcpProf2pdcpProfileId,LNBTS.pdcpProf2snSize,LNBTS.pdcpProf2statusRepReq,LNBTS.pdcpProf2tDiscard,LNBTS.pdcpProf3pdcpProfileId,LNBTS.pdcpProf3snSize,LNBTS.pdcpProf3statusRepReq,LNBTS.pdcpProf3tDiscard,LNBTS.pdcpProf4pdcpProfileId,LNBTS.pdcpProf4snSize,LNBTS.pdcpProf4statusRepReq,LNBTS.pdcpProf4tDiscard,LNBTS.pdcpProf5pdcpProfileId,LNBTS.pdcpProf5snSize,LNBTS.pdcpProf5statusRepReq,LNBTS.pdcpProf5tDiscard,LNBTS.planFileActivationMode,LNBTS.prioTopoHO,LNBTS.prohibitLBHOTimer,LNBTS.qciTab1delayTarget,LNBTS.qciTab1drxProfileIndex,LNBTS.qciTab1dscp,LNBTS.qciTab1enforceTtiBundling,LNBTS.qciTab1lcgid,LNBTS.qciTab1maxGbrDl,LNBTS.qciTab1maxGbrUl,LNBTS.qciTab1pdcpProfIdx,LNBTS.qciTab1prio,LNBTS.qciTab1qci,LNBTS.qciTab1qciSupp,LNBTS.qciTab1resType,LNBTS.qciTab1rlcMode,LNBTS.qciTab1rlcProfIdx,LNBTS.qciTab1schedulBSD,LNBTS.qciTab1schedulPrio,LNBTS.qciTab2delayTarget,LNBTS.qciTab2drxProfileIndex,LNBTS.qciTab2dscp,LNBTS.qciTab2enforceTtiBundling,LNBTS.qciTab2l2OHFactorDL,LNBTS.qciTab2l2OHFactorUL,LNBTS.qciTab2lcgid,LNBTS.qciTab2maxGbrDl,LNBTS.qciTab2maxGbrUl,LNBTS.qciTab2pdcpProfIdx,LNBTS.qciTab2prio,LNBTS.qciTab2qci,LNBTS.qciTab2qciSupp,LNBTS.qciTab2resType,LNBTS.qciTab2rlcMode,LNBTS.qciTab2rlcProfIdx,LNBTS.qciTab2schedulBSD,LNBTS.qciTab2schedulPrio,LNBTS.qciTab3delayTarget,LNBTS.qciTab3drxProfileIndex,LNBTS.qciTab3dscp,LNBTS.qciTab3enforceTtiBundling,LNBTS.qciTab3l2OHFactorDL,LNBTS.qciTab3l2OHFactorUL,LNBTS.qciTab3lcgid,LNBTS.qciTab3maxGbrDl,LNBTS.qciTab3maxGbrUl,LNBTS.qciTab3pdcpProfIdx,LNBTS.qciTab3prio,LNBTS.qciTab3qci,LNBTS.qciTab3qciSupp,LNBTS.qciTab3resType,LNBTS.qciTab3rlcMode,LNBTS.qciTab3rlcProfIdx,LNBTS.qciTab3schedulBSD,LNBTS.qciTab3schedulPrio,LNBTS.qciTab4delayTarget,LNBTS.qciTab4drxProfileIndex,LNBTS.qciTab4dscp,LNBTS.qciTab4enforceTtiBundling,LNBTS.qciTab4l2OHFactorDL,LNBTS.qciTab4l2OHFactorUL,LNBTS.qciTab4lcgid,LNBTS.qciTab4maxGbrDl,LNBTS.qciTab4maxGbrUl,LNBTS.qciTab4pdcpProfIdx,LNBTS.qciTab4prio,LNBTS.qciTab4qci,LNBTS.qciTab4qciSupp,LNBTS.qciTab4resType,LNBTS.qciTab4rlcMode,LNBTS.qciTab4rlcProfIdx,LNBTS.qciTab4schedulBSD,LNBTS.qciTab4schedulPrio,LNBTS.qciTab5drxProfileIndex,LNBTS.qciTab5dscp,LNBTS.qciTab5enforceTtiBundling,LNBTS.qciTab5lcgid,LNBTS.qciTab5pdcpProfIdx,LNBTS.qciTab5prio,LNBTS.qciTab5qci,LNBTS.qciTab5qciSupp,LNBTS.qciTab5resType,LNBTS.qciTab5rlcMode,LNBTS.qciTab5rlcProfIdx,LNBTS.qciTab5schedulBSD,LNBTS.qciTab5schedulPrio,LNBTS.qciTab5schedulType,LNBTS.qciTab5schedulWeight,LNBTS.qciTab6drxProfileIndex,LNBTS.qciTab6dscp,LNBTS.qciTab6enforceTtiBundling,LNBTS.qciTab6lcgid,LNBTS.qciTab6pdcpProfIdx,LNBTS.qciTab6prio,LNBTS.qciTab6qci,LNBTS.qciTab6qciSupp,LNBTS.qciTab6resType,LNBTS.qciTab6rlcMode,LNBTS.qciTab6rlcProfIdx,LNBTS.qciTab6rlcProfIdx3cc,LNBTS.qciTab6schedulBSD,LNBTS.qciTab6schedulPrio,LNBTS.qciTab6schedulWeight,LNBTS.qciTab65delayTarget,LNBTS.qciTab65drxProfileIndex,LNBTS.qciTab65dscp,LNBTS.qciTab65enforceTtiBundling,LNBTS.qciTab65lcgid,LNBTS.qciTab65maxGbrDl,LNBTS.qciTab65maxGbrUl,LNBTS.qciTab65pdcpProfIdx,LNBTS.qciTab65prio,LNBTS.qciTab65qci,LNBTS.qciTab65qciSupp,LNBTS.qciTab65resType,LNBTS.qciTab65rlcMode,LNBTS.qciTab65rlcProfIdx,LNBTS.qciTab65schedulBSD,LNBTS.qciTab65schedulPrio,LNBTS.qciTab66delayTarget,LNBTS.qciTab66drxProfileIndex,LNBTS.qciTab66dscp,LNBTS.qciTab66enforceTtiBundling,LNBTS.qciTab66lcgid,LNBTS.qciTab66maxGbrDl,LNBTS.qciTab66maxGbrUl,LNBTS.qciTab66pdcpProfIdx,LNBTS.qciTab66prio,LNBTS.qciTab66qci,LNBTS.qciTab66qciSupp,LNBTS.qciTab66resType,LNBTS.qciTab66rlcMode,LNBTS.qciTab66rlcProfIdx,LNBTS.qciTab66schedulBSD,LNBTS.qciTab66schedulPrio,LNBTS.qciTab69drxProfileIndex,LNBTS.qciTab69dscp,LNBTS.qciTab69enforceTtiBundling,LNBTS.qciTab69lcgid,LNBTS.qciTab69pdcpProfIdx,LNBTS.qciTab69prio,LNBTS.qciTab69qci,LNBTS.qciTab69qciSupp,LNBTS.qciTab69resType,LNBTS.qciTab69rlcMode,LNBTS.qciTab69rlcProfIdx,LNBTS.qciTab69schedulBSD,LNBTS.qciTab69schedulPrio,LNBTS.qciTab7drxProfileIndex,LNBTS.qciTab7dscp,LNBTS.qciTab7enforceTtiBundling,LNBTS.qciTab7lcgid,LNBTS.qciTab7pdcpProfIdx,LNBTS.qciTab7prio,LNBTS.qciTab7qci,LNBTS.qciTab7qciSupp,LNBTS.qciTab7resType,LNBTS.qciTab7rlcMode,LNBTS.qciTab7rlcProfIdx,LNBTS.qciTab7rlcProfIdx3cc,LNBTS.qciTab7schedulBSD,LNBTS.qciTab7schedulPrio,LNBTS.qciTab7schedulWeight,LNBTS.qciTab70drxProfileIndex,LNBTS.qciTab70dscp,LNBTS.qciTab70enforceTtiBundling,LNBTS.qciTab70lcgid,LNBTS.qciTab70pdcpProfIdx,LNBTS.qciTab70prio,LNBTS.qciTab70qci,LNBTS.qciTab70qciSupp,LNBTS.qciTab70resType,LNBTS.qciTab70rlcMode,LNBTS.qciTab70rlcProfIdx,LNBTS.qciTab70rlcProfIdx3cc,LNBTS.qciTab70schedulBSD,LNBTS.qciTab70schedulPrio,LNBTS.qciTab70schedulWeight,LNBTS.qciTab8drxProfileIndex,LNBTS.qciTab8dscp,LNBTS.qciTab8enforceTtiBundling,LNBTS.qciTab8lcgid,LNBTS.qciTab8pdcpProfIdx,LNBTS.qciTab8prio,LNBTS.qciTab8qci,LNBTS.qciTab8qciSupp,LNBTS.qciTab8resType,LNBTS.qciTab8rlcMode,LNBTS.qciTab8rlcProfIdx,LNBTS.qciTab8rlcProfIdx3cc,LNBTS.qciTab8schedulBSD,LNBTS.qciTab8schedulPrio,LNBTS.qciTab8schedulWeight,LNBTS.qciTab9drxProfileIndex,LNBTS.qciTab9dscp,LNBTS.qciTab9enforceTtiBundling,LNBTS.qciTab9lcgid,LNBTS.qciTab9pdcpProfIdx,LNBTS.qciTab9prio,LNBTS.qciTab9qci,LNBTS.qciTab9qciSupp,LNBTS.qciTab9resType,LNBTS.qciTab9rlcMode,LNBTS.qciTab9rlcProfIdx,LNBTS.qciTab9rlcProfIdx3cc,LNBTS.qciTab9schedulBSD,LNBTS.qciTab9schedulPrio,LNBTS.qciTab9schedulWeight,LNBTS.rachAccessForHoFromUtran,LNBTS.recoveryResetDelay,LNBTS.reportTimerIMLBA4,LNBTS.rlcProf1pollPdu,LNBTS.rlcProf1rlcProfileId,LNBTS.rlcProf1tPollRetr,LNBTS.rlcProf1tProhib,LNBTS.rlcProf1tReord,LNBTS.rlcProf101rlcProfileId,LNBTS.rlcProf101snFieldLengthDL,LNBTS.rlcProf101snFieldLengthUL,LNBTS.rlcProf101tReord,LNBTS.rlcProf102rlcProfileId,LNBTS.rlcProf102snFieldLengthDL,LNBTS.rlcProf102snFieldLengthUL,LNBTS.rlcProf102tReord,LNBTS.rlcProf103rlcProfileId,LNBTS.rlcProf103snFieldLengthDL,LNBTS.rlcProf103snFieldLengthUL,LNBTS.rlcProf103tReord,LNBTS.rlcProf104rlcProfileId,LNBTS.rlcProf104snFieldLengthDL,LNBTS.rlcProf104snFieldLengthUL,LNBTS.rlcProf104tReord,LNBTS.rlcProf2pollPdu,LNBTS.rlcProf2rlcProfileId,LNBTS.rlcProf2tPollRetr,LNBTS.rlcProf2tProhib,LNBTS.rlcProf2tReord,LNBTS.rlcProf3pollPdu,LNBTS.rlcProf3rlcProfileId,LNBTS.rlcProf3tPollRetr,LNBTS.rlcProf3tProhib,LNBTS.rlcProf3tReord,LNBTS.rlcProf4pollPdu,LNBTS.rlcProf4rlcProfileId,LNBTS.rlcProf4tPollRetr,LNBTS.rlcProf4tProhib,LNBTS.rlcProf4tReord,LNBTS.rlcProf5pollPdu,LNBTS.rlcProf5rlcProfileId,LNBTS.rlcProf5tPollRetr,LNBTS.rlcProf5tProhib,LNBTS.rlcProf5tReord,LNBTS.rlcProf6pollPdu,LNBTS.rlcProf6rlcProfileId,LNBTS.rlcProf6tPollRetr,LNBTS.rlcProf6tProhib,LNBTS.rlcProf6tReord,LNBTS.rlfBasedRCRdefault,LNBTS.rrcGuardTimer,LNBTS.s1InducedCellDeactDelayTime,LNBTS.sCellActivationCyclePeriod,LNBTS.sCellActivationMethod,LNBTS.sCellDeactivationTimereNB,LNBTS.sCellpCellHARQFdbkUsage,LNBTS.scellActivationLevel,LNBTS.scellMeasCycle,LNBTS.shutdownStepAmount,LNBTS.shutdownWindow,LNBTS.sibUpdateRateThreshold,LNBTS.supportedNumOfAnrMoi,LNBTS.supportedNumOfLnadj,LNBTS.tChangeMobilityReq,LNBTS.tRsrInitWait,LNBTS.tRsrResFirst,LNBTS.tS1RelPrepG,LNBTS.tS1RelPrepL,LNBTS.tS1RelPrepU,LNBTS.tagMaxAM,LNBTS.tagMaxUM,LNBTS.timDelACContPreempt,LNBTS.timeConnFailureThreshold,LNBTS.txPathFailureMode,LNBTS.ulpcRachPwrRipOffset,LNBTS.ulpcRachTgtPwrDelta,LNBTS.ulpcRssiMaxIAw,LNBTS.upovlhaenableERabSetupRed,LNBTS.upovlhaenableInHoRed,LNBTS.upovlhaenableRrcConnRed,LNBTS.upovlhaenableSuspendSrs,LNBTS.upovlhaenableTxDivTransmission,LNBTS.voiceSuppMatchInd,LNBTS.actAmle,LNBTS.actCaIntraCellHo,LNBTS.actConvVoice,LNBTS.actDistributedSite,LNBTS.actDlIntShaping,LNBTS.actDualBand,LNBTS.actFlexBbUsage,LNBTS.actHighPrioServices,LNBTS.actHighRrc,LNBTS.actIMSEmerSessR9,LNBTS.actInterEnbULCAggr,LNBTS.actInterFreqLB,LNBTS.actInterFreqServiceBasedHo,LNBTS.actIntraFreqLoadBal,LNBTS.actLBRTXPowerSaving,LNBTS.actMFBI,LNBTS.actOptimizedBbUsage,LNBTS.actPcellSwap,LNBTS.actPeriodicCarrierBlinking,LNBTS.actProSeComm,LNBTS.actPubSafetyBearers,LNBTS.actRfChaining,LNBTS.actSrvccToGsm,LNBTS.actSrvccToWcdma,LNBTS.actTempRadioMaster,LNBTS.actULCAggr,LNBTS.actUlCoMp,LNBTS.caClusterNumEnb,LNBTS.caMinUlAmbr,LNBTS.caUlIntraBandAmpr,LNBTS.dlCaPreferred,LNBTS.enableCombRsrpRsrq,LNBTS.numTxWithHighNonGbr,LNBTS.pcellSwapBlockTimer,LNBTS.preventPsHOtoWcdma,LNBTS.qciTab6rlcProfIdx4cc5cc,LNBTS.qciTab7rlcProfIdx4cc5cc,LNBTS.qciTab70rlcProfIdx4cc5cc,LNBTS.qciTab8rlcProfIdx4cc5cc,LNBTS.qciTab9rlcProfIdx4cc5cc,LNBTS.rlcProf7pollPdu,LNBTS.rlcProf7rlcProfileId,LNBTS.rlcProf7tPollRetr,LNBTS.rlcProf7tProhib,LNBTS.rlcProf7tReord,LNBTS.tOverbookingAc,LNBTS.ulCaPathlossThr,LNBTS.act1xSrvcc,LNBTS.actCRAN,LNBTS.actDedVoLteInterFreqHo,LNBTS.actUtranLoadBal,LNBTS.tempRadioMasterRecovTime,LNBTS.tempRadioMasterTriggerTime,LNBTS.actAutoLteNeighRemoval,LNBTS.actAutoUtranNeighRemoval,LNBTS.actDualCarrier,LNBTS.idleTimeThresLteNR,LNBTS.idleTimeThresNbEnbExch,LNBTS.idleTimeThresNbeNB,LNBTS.idleTimeThresX2,LNBTS.nbEnbExchWaitTmr,LNBTS.anrIfTRSC,LNBTS.anrRobLevel,LNBTS.anrRobLevelUtran,LNBTS.anrUtraTRSCFS,LNBTS.consecHoFailThres,LNBTS.consecUtranHoFailThres,LNBTS.idleTimeThresUtranNR,LNBTS.maxNumX2LinksIn,LNBTS.maxNumX2LinksOut,LNBTS.minNotActivatedUtraRSCFS,LNBTS.nRimRirG,LNBTS.nRimRirU,LNBTS.pollPdu,LNBTS.rlcProfileId,LNBTS.tPollRetr,LNBTS.tProhib,LNBTS.tReord,LNBTS.s1PrdRevalWaitTmr,LNBTS.tRimKaG,LNBTS.tRimKaU,LNBTS.tRimPollG,LNBTS.tRimPollU,LNBTS.tRimRirG,LNBTS.tRimRirU,LNBTS.utranPrdRevalWaitTmr,LNBTS.x2PrdRevalWaitTmr,LNBTS.actLteU,LNBTS.SBTS_id,LNBTS.caSchedFairFact,LNBTS.hpsSessArpMax,LNBTS.hpsSessArpMin,LNBTS.mlbSpecialCase,LNBTS.actAcBarringACS,LNBTS.actAcBarringCFR,LNBTS.actAcBarringPlmn,LNBTS.actAcBarringRrcConn,LNBTS.actAcBarringRrcReq,LNBTS.actAddA3HoCheck,LNBTS.actAdvStepwiseScellAdd,LNBTS.actAdvUlScellHandling,LNBTS.actBbPooling,LNBTS.actCAggrLteNrDualConnectivity,LNBTS.actCoMp,LNBTS.actContextPreemption,LNBTS.actCsfbECRestrRem,LNBTS.actDCN,LNBTS.actDLUnicastMbsfn,LNBTS.actDynMBMSRes,LNBTS.actDynTrigLteNrDualConnectivity,LNBTS.actEnhCbrsCAggr,LNBTS.actHoWoSnChg,LNBTS.actHybridS1Mobility,LNBTS.actIPv6MBMS,LNBTS.actIdleLBCaAwareAdv,LNBTS.actIdleLBSupportedBands,LNBTS.actIncCarrMonit,LNBTS.actInterFreqMDTCellTrace,LNBTS.actLteNrDualConnectivity,LNBTS.actMBMSPS,LNBTS.actMBMSServiceContinuity,LNBTS.actMappedBandIFMeas,LNBTS.actPCMDReport,LNBTS.actPlmnBasedPreemption,LNBTS.actPlmnUnavailForCellReport,LNBTS.actPredKpisObservability,LNBTS.actPreempVulCatM,LNBTS.actRLFbasedRCREnhanced,LNBTS.actRLFbasedRCRTargetCRNTI,LNBTS.actRrcConnRelDelay,LNBTS.actRsrqInterRatMobility,LNBTS.actSecRatRep,LNBTS.actServicePRButiL,LNBTS.actSnChangeSnInit,LNBTS.actSpecDupGapNB,LNBTS.actTcpBoost,LNBTS.actUTCBroadcast,LNBTS.actUlInDevCoexGNSS,LNBTS.actUlTxSkip,LNBTS.actVoLTEQualInterFreqMobility,LNBTS.actVoLTEQualSRVCCtoGsm,LNBTS.bbPoolEvalPeriod,LNBTS.bbPoolMinResource,LNBTS.btsResetRequest,LNBTS.cPlaneDscp,LNBTS.caConfigRatioOvl1,LNBTS.caIntraCellHoMode,LNBTS.mainTransportNwId,LNBTS.maxParallelIncX2SetupOrECUOvl0,LNBTS.maxParallelIncX2SetupOrECUOvl1,LNBTS.maxParallelOutX2SetupOrECU,LNBTS.maxRetxThreshSrbDL,LNBTS.maxRetxThreshSrbUL,LNBTS.maxX2CfUpRetry,LNBTS.pureRrcPreempPrioNB,LNBTS.pwrFallbackCa,LNBTS.pwsWithEmAreaId,LNBTS.qciTab6lteNrDualConnectSupport,LNBTS.qciTab6rlcProfIdx6cc7cc,LNBTS.qciTab6startArpEnDc,LNBTS.qciTab6stopArpEnDc,LNBTS.qciTab7lteNrDualConnectSupport,LNBTS.qciTab7rlcProfIdx6cc7cc,LNBTS.qciTab7startArpEnDc,LNBTS.qciTab7stopArpEnDc,LNBTS.qciTab70rlcProfIdx6cc7cc,LNBTS.qciTab8lteNrDualConnectSupport,LNBTS.qciTab8rlcProfIdx6cc7cc,LNBTS.qciTab8startArpEnDc,LNBTS.qciTab8stopArpEnDc,LNBTS.qciTab9lteNrDualConnectSupport,LNBTS.qciTab9rlcProfIdx6cc7cc,LNBTS.qciTab9startArpEnDc,LNBTS.qciTab9stopArpEnDc,LNBTS.rlcProf1maxRetxThresh,LNBTS.rlcProf1tReordIsca,LNBTS.rlcProf2maxRetxThresh,LNBTS.rlcProf2tReordIsca,LNBTS.rlcProf3maxRetxThresh,LNBTS.rlcProf3tReordIsca,LNBTS.rlcProf4maxRetxThresh,LNBTS.rlcProf4tReordIsca,LNBTS.rlcProf5maxRetxThresh,LNBTS.rlcProf5tReordIsca,LNBTS.rlcProf6maxRetxThresh,LNBTS.rlcProf6tReordIsca,LNBTS.rlcProf7maxRetxThresh,LNBTS.rlcProf7tReordIsca,LNBTS.rlcProf8maxRetxThresh,LNBTS.rlcProf8pollPdu,LNBTS.rlcProf8rlcProfileId,LNBTS.rlcProf8tProhib,LNBTS.rlcProf8tReord,LNBTS.rlcProf8tReordIsca,LNBTS.skipEUTRANCapabilities,LNBTS.srvccDelayTimer,LNBTS.supportedCellTechnology,LNBTS.tHalfRrcCon,LNBTS.tHoOverallD,LNBTS.tPollRetrSrbDL,LNBTS.tPollRetrSrbUL,LNBTS.tS1RelOvDeltG,LNBTS.tS1RelOvDeltU,LNBTS.tX2RelocPrep,LNBTS.tx2RelODelta,LNBTS.ulamcHistMcsT,LNBTS.ulamcInactT,LNBTS.x2CfUpRdmDelayTmr,LNBTS.actTransportSeparationLte,LNBTS.blacklistS1HoEPCFailure,LNBTS.actIntraFreqPciSharing,LNBTS.maxNumClusterUe,LNBTS.pdcpProf1001pdcpProfileId,LNBTS.pdcpProf1001snSizeDl,LNBTS.pdcpProf1001snSizeUl,LNBTS.pdcpProf1001statusRepReq,LNBTS.pdcpProf1001tDiscard,LNBTS.userLayerTcpMss,LNBTS.rlcProf1snFieldLengthDl,LNBTS.rlcProf1snFieldLengthUl,LNBTS.rlcProf2snFieldLengthDl,LNBTS.rlcProf2snFieldLengthUl,LNBTS.rlcProf3snFieldLengthDl,LNBTS.rlcProf3snFieldLengthUl,LNBTS.rlcProf4snFieldLengthDl,LNBTS.rlcProf4snFieldLengthUl,LNBTS.rlcProf5snFieldLengthDl,LNBTS.rlcProf5snFieldLengthUl,LNBTS.rlcProf6snFieldLengthDl,LNBTS.rlcProf6snFieldLengthUl,LNBTS.commLossRecoveryTimer,LNBTS.interFreqPCISharing,LNBTS.zsonEventTriggerEnable,LNBTS.zsonOpMode,LNBTS.caClusterId,LNBTS.caClusterMemberId,LNBTS.actEnDcX2PartialReset,LNBTS.actEndcHo,LNBTS.actEvtSecRatRep,LNBTS.actGTPpktSeqMon,LNBTS.actIdleLBTM9aware,LNBTS.actLPPaEcidNB,LNBTS.actLteNrDss,LNBTS.actLteNrFastNbrRelAdd,LNBTS.actMultiSCGSplit,LNBTS.actProhibitCaSpecCellDepl,LNBTS.actProhibitWcdmaMobPreQci1,LNBTS.actRCEFReporting,LNBTS.actRCREnDc,LNBTS.actRLFbasedRCRConfigL1,LNBTS.actReduceAcqiReqTxSkip,LNBTS.actSIB24,LNBTS.actStepAddBearENDC,LNBTS.actTM9Block,LNBTS.actUlpcDiffPusch,LNBTS.actVoLTEQualSrvccToWcdma,LNBTS.actVoLteNoEnDc,LNBTS.qciTab2gbrOverbookingFactor,LNBTS.qciTab3gbrOverbookingFactor,LNBTS.qciTab4gbrOverbookingFactor,LNBTS.qciTab5lteNrDualConnectSupport,LNBTS.qciTab5startArpEnDc,LNBTS.qciTab5stopArpEnDc,LNBTS.qciTab69lteNrDualConnectSupport,LNBTS.qciTab69startArpEnDc,LNBTS.qciTab69stopArpEnDc,LNBTS.qciTab70lteNrDualConnectSupport,LNBTS.qciTab70startArpEnDc,LNBTS.qciTab70stopArpEnDc,LNBTS.timeOfContBadUlPktsToTrigHoForHfnReset,LNBTS.ilGrantGapTcpBoostTxSkip,LNBTS.ilGrantGapTxSkip,LNBTS.ilMinDatvolUlTcpBoost,LNBTS.ilReacTimerUlTcpBoost,LNBTS.ilReacTimerUlTcpBoostTxSkip,LNBTS.ilReacTimerUlTxSkip,LNBTS.maxEUTRANCapabilitySize,LNBTS.tLteNrDualConnectPrep,LNBTS.qciTab8boostFactorDl,LNBTS.qciTab8boostFactorUl
FROM ((LNBTS LEFT JOIN LNBTS_FDD ON (LNBTS.PLMN_Id=LNBTS_FDD.PLMN_Id) AND (LNBTS.MRBTS_Id=LNBTS_FDD.MRBTS_Id) AND (LNBTS.LNBTS_Id=LNBTS_FDD.LNBTS_Id)) LEFT JOIN LNBTS_FDD_CIOTEPSPLMNIDLIST ON (LNBTS.PLMN_Id=LNBTS_FDD_CIOTEPSPLMNIDLIST.PLMN_Id) AND (LNBTS.MRBTS_Id=LNBTS_FDD_CIOTEPSPLMNIDLIST.MRBTS_Id) AND (LNBTS.LNBTS_Id=LNBTS_FDD_CIOTEPSPLMNIDLIST.LNBTS_Id)) LEFT JOIN baselinesite AS B ON (B.Sitio = LNBTS.name COLLATE NOCASE);
--
--
--LNCEL full
DROP TABLE IF EXISTS LNCEL_Full;
CREATE TABLE LNCEL_Full AS
SELECT DISTINCT
LNCEL.name AS LNCELname, B.Cluster, B.Region, B.Departamento AS Depto, B.Municipio AS Mun, LNBTS.name||substr(LNCEL.name,-1,1) AS KeySector, LNCEL.PLMN_id,
substr(LNCEL.name,1,3) AS Prefijo, substr(LNCEL.name,-1,1) AS Sector, CASE WHEN LNCEL_FDD.earfcnDL BETWEEN 2750 and 3449 THEN 2600 ELSE (CASE WHEN LNCEL_FDD.earfcnDL BETWEEN 600 and 1199 THEN 1900 ELSE (CASE WHEN LNCEL_FDD.earfcnDL BETWEEN 9210 and 9659 THEN 700 ELSE (CASE WHEN LNCEL_FDD.earfcnDL BETWEEN 2400 and 2649 THEN 850 ELSE NULL END)END)END)END AS Banda, LNCEL.MRBTS_id,LNCEL.LNBTS_id,LNCEL.LNCEL_id,LNBTS.name AS LNBTSname, LNBTS.operationalState AS LNBTS_OpSt, LNCEL.administrativeState AS LNCEL_AdSt, LNCEL.Operationalstate AS LNCEL_OpSt, CASE WHEN LNCEL_FDD.dlRsBoost=700 THEN -3 ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1000 THEN 0 ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1177 THEN 1.77 ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1300 THEN 3 ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1477 THEN 4.77 ELSE (CASE WHEN LNCEL_FDD.dlRsBoost=1600 THEN 6 ELSE NULL END)END)END)END)END)END AS PowerBoost, Round((3*(LNCEL.phyCellId*1.0/3-CAST(LNCEL.phyCellId/3 AS INT))),0) as PCIMod3, Round((6*(LNCEL.phyCellId*1.0/6-CAST(LNCEL.phyCellId/6 AS INT))),0) as PCIMod6, Round((30*(LNCEL.phyCellId*1.0/30-CAST(LNCEL.phyCellId/30 AS INT))),0) as PCIMod30, "PLMN-" || LNCEL.PLMN_id || "/MRBTS-" ||LNCEL.mrbts_Id || "/LNBTS-" || LNCEL.lnBts_Id || "/LNCEL-" || LNCEL.lnCel_Id AS DistName, CASE WHEN (LNBTS.operationalState=5 AND LNCEL.administrativeState=1 AND LNCEL.operationalState=1) THEN 1 ELSE 0 END AS Estado, LNCEL_FDD.LNCEL_FDD_id,LNCEL_FDD.moVersion,LNCEL_FDD.act1TxIn2Tx,LNCEL_FDD.actAutoPucchAlloc,LNCEL_FDD.actCatM,LNCEL_FDD.actCombSuperCell,LNCEL_FDD.actDlSlimCarrier,LNCEL_FDD.actFastMimoSwitch,LNCEL_FDD.actLiquidCell,LNCEL_FDD.actMMimo,LNCEL_FDD.actPdcchLoadGen,LNCEL_FDD.actPuschMask,LNCEL_FDD.actRedFreqOffset,LNCEL_FDD.actRepeaterMode,LNCEL_FDD.actSdlc,LNCEL_FDD.actShutdownTxPath,LNCEL_FDD.actSuperCell,LNCEL_FDD.actUciOnlyGrants,LNCEL_FDD.actUlMultiCluster,LNCEL_FDD.actUlPwrRestrScn,LNCEL_FDD.addNumDrbRadioReasHo,LNCEL_FDD.addNumDrbTimeCriticalHo,LNCEL_FDD.addNumQci1DrbRadioReasHo,LNCEL_FDD.addNumQci1DrbTimeCriticalHo,LNCEL_FDD.blankedPucch,LNCEL_FDD.dlChBw AS dlChBw1, LNCEL_FDD.dlMimoMode,LNCEL_FDD.dlRsBoost,LNCEL_FDD.dlSrbMimoMode,LNCEL_FDD.dlpcMimoComp,LNCEL_FDD.earfcnDL,LNCEL_FDD.earfcnUL,LNCEL_FDD.maxNrSymPdcch,LNCEL_FDD.maxNumActDrb,LNCEL_FDD.maxNumActUE,LNCEL_FDD.maxNumCaConfUe,LNCEL_FDD.maxNumCaConfUe3c,LNCEL_FDD.maxNumCaConfUeDc,LNCEL_FDD.maxNumQci1Drb,LNCEL_FDD.maxNumUeDl,LNCEL_FDD.maxNumUeUl,LNCEL_FDD.mimoClCqiThD,LNCEL_FDD.mimoClCqiThU,LNCEL_FDD.mimoClRiThD,LNCEL_FDD.mimoClRiThU,LNCEL_FDD.mimoOlCqiThD,LNCEL_FDD.mimoOlCqiThU,LNCEL_FDD.mimoOlRiThD,LNCEL_FDD.mimoOlRiThU,LNCEL_FDD.prachCS,LNCEL_FDD.prachConfIndex,LNCEL_FDD.prachFreqOff,LNCEL_FDD.prachHsFlag,LNCEL_FDD.prsConfigurationIndex,LNCEL_FDD.prsNumDlFrames,LNCEL_FDD.pucchNAnCs,LNCEL_FDD.rootSeqIndex,LNCEL_FDD.selectOuterPuschRegion,LNCEL_FDD.srsActivation,LNCEL_FDD.srsPwrOffset,LNCEL_FDD.syncSigTxMode,LNCEL_FDD.twoLayerMimoAvSpectralEff,LNCEL_FDD.ulChBw,LNCEL_FDD.ulCombinationMode,LNCEL_FDD.ulpcRarespTpc,LNCEL_FDD.cqiAperPollT,LNCEL_FDD.slimRfFilterDL,LNCEL_FDD.slimRfFilterUL,LNCEL_FDD.numBlankDlPrbsDown,LNCEL_FDD.numBlankDlPrbsUp,LNCEL_FDD.utranLbLoadThresholdshighLoadGbrDl,LNCEL_FDD.utranLbLoadThresholdshighLoadNonGbrDl,LNCEL_FDD.utranLbLoadThresholdshighLoadPdcch,LNCEL_FDD.csiRsPwrOffsetAP,LNCEL_FDD.csiRsPwrOffsetOverlap,LNCEL_FDD.csiRsSubfr,LNCEL_FDD.liquidCellSuMuMode,LNCEL_FDD.uLMeasAlphaBase,LNCEL_FDD.uLMeasHystJT,LNCEL_FDD.uLMeasHystSuMu,LNCEL_FDD.uLMeasN,LNCEL_FDD.uLMeasThrJtCsiRs,LNCEL_FDD.uLMeasThrSuMuCsiRs,LNCEL_FDD.actRIPAlarming,LNCEL_FDD.alarmThresholdCrossingTime,LNCEL_FDD.alarmThresholdULSF,LNCEL_FDD.ulInterferenceOffset,LNCEL_FDD.rfSensitivity,LNCEL_FDD.activatedMimoTM,LNCEL_FDD.csiRsPwrOffset,LNCEL_FDD.csiRsResourceConf,LNCEL_FDD.csiRsSubfrConf,LNCEL_FDD.numOfCsiRsAntennaPorts,LNCEL_FDD.fourLayerMimoAvSpectralEff,LNCEL_FDD.maxPrbHighPrioUciGrant,LNCEL_FDD.multNumUeHighPrioUciGrant,LNCEL_FDD.multUciGrant,LNCEL_FDD.catMProfId,LNCEL_FDD.redFreqOffset,LNCEL_FDD.pdcchLoadLevel,LNCEL_FDD.pdcchLoadPsdOffset,LNCEL_FDD.actDlMuMimo,LNCEL_FDD.actSrs14Pos,LNCEL_FDD.rachDensity,LNCEL_FDD.lnuprId,LNCEL_FDD.catMBProfId,LNCEL_FDD.pMaxLaa,LNCEL_FDD.csiRepSubmode,
SIB.acbProfileId,SIB.autoAcBarringStartTimer,SIB.autoAcbPlmnRmvlStopTimer,SIB.autoPlmnRmvlStartTimer,SIB.celResTiFHM,SIB.celResTiFMM,SIB.cellBarred,SIB.cellReSelPrio,SIB.intrFrqCelRes,SIB.intraPresAntP,SIB.modPeriodCoeff,SIB.n310,SIB.n311,SIB.pMaxOwnCell,SIB.prachPwrRamp,SIB.preambTxMax,SIB.primPlmnCellres,SIB.qHyst,SIB.qrxlevmin,SIB.qrxlevminintraF,SIB.sIntrasearch,SIB.sNonIntrsearch,SIB.siWindowLen,SIB.sib2SchedulingsiMessagePeriodicity,SIB.sib2SchedulingsiMessageRepetition,SIB.sib2SchedulingsiMessageSibType,SIB.sib2xTransmit,SIB.sib3SchedulingsiMessagePeriodicity,SIB.sib3SchedulingsiMessageRepetition,SIB.sib3SchedulingsiMessageSibType,SIB.nCellChgHigh,SIB.nCellChgMed,SIB.qHystSfHigh,SIB.qHystSfMed,SIB.tEvaluation,SIB.tHystNormal,SIB.t300,SIB.t301,SIB.t310,SIB.t311,SIB.tReselEutr,SIB.threshSrvLow,SIB.ulpcIniPrePwr,SIB.ocAcBarAC,SIB.ocAcBarTime,SIB.ocAcProbFac,SIB.ocAcBarACOvl,SIB.ocAcBarTimeOvl,SIB.ocAcProbFacOvl,SIB.sigAcBarAC,SIB.sigAcBarTime,SIB.sigAcProbFac,SIB.sigAcBarACOvl,SIB.sigAcBarTimeOvl,SIB.sigAcProbFacOvl,SIB.acBarSkipForMMTELVideo,SIB.acBarSkipForMMTELVoice,SIB.acBarSkipForSMS,SIB.eCallAcBarred,SIB.eCallAcBarredOvl,SIB.dayLt,SIB.ltmOff,SIB.mbmsNeighCellConfigIntraF,SIB.deltaFPucchF1bCSr10,SIB.deltaFPucchF3r10,SIB.heNBName,SIB.cellSelectionInfoV920qQualMinOffsetR9,SIB.cellSelectionInfoV920qQualMinR9,SIB.acbImmediateMax,SIB.acbECTimer,SIB.acbNumRrcConnCellStart,SIB.acbNumRrcConnCellStop,SIB.acbNumRrcReqStart,SIB.acbNumRrcReqStop,SIB.acbNumSteps,SIB.acbRrcConnCellStartTimer,SIB.acbRrcConnCellStopTimer,SIB.acbRrcReqFactor,SIB.acbUpdateTimer,SIB.acbPlmnNumSteps,
LNCEL.moVersion AS moVersionl, LNCEL.mcc,LNCEL.mnc,LNCEL.siteTemplateName,LNCEL.a1TimeToTriggerDeactInterMeas,LNCEL.a2RedirectQci1,LNCEL.a2TimeToTriggerActGERANMeas,LNCEL.a2TimeToTriggerActInterFreqMeas,LNCEL.a2TimeToTriggerActWcdmaMeas,LNCEL.a2TimeToTriggerRedirect,LNCEL.a3Offset,LNCEL.a3ReportInterval,LNCEL.a3TimeToTrigger,LNCEL.a3TriggerQuantityHO,LNCEL.a5ReportInterval,LNCEL.a5TimeToTrigger,LNCEL.actAmle,LNCEL.actCsiRsSubFNonTM9Sch,LNCEL.actDataSessionProf,LNCEL.actDl256QamChQualEst,LNCEL.actDlsOldtc,LNCEL.actDlsVoicePacketAgg,LNCEL.actDownSampling,LNCEL.actDrx,LNCEL.actDrxDuringMeasGap,LNCEL.actDrxDuringTTIB,LNCEL.actEDrxIdle,LNCEL.actEicic,LNCEL.actFlexDupGap,LNCEL.actGsmSrvccMeasOpt,LNCEL.actInactiveTimeForwarding,LNCEL.actInterFreqLB,LNCEL.actIntraFreqLoadBal,LNCEL.actLBSpidUeSel,LNCEL.actLdPdcch,LNCEL.actMicroDtx,LNCEL.actModulationSchemeDl,LNCEL.actModulationSchemeUL,LNCEL.actNbrForNonGbrBearers,LNCEL.actNoIntraBandIFMeasurements,LNCEL.actOlLaPdcch,LNCEL.actOtdoa,LNCEL.actProactSchedBySrb,LNCEL.actPrsTxDiv,LNCEL.actQci1RfDrx,LNCEL.actQci1eVTT,LNCEL.actSixIfMeasurements,LNCEL.actSmartDrx,LNCEL.actSrb1Robustness,LNCEL.actTtiBundling,LNCEL.actTtibAcqi,LNCEL.actTtibRsc,LNCEL.actUePowerBasedMobThr,LNCEL.actUlGrpHop,LNCEL.actUlLnkAdp,LNCEL.actUlpcMethod,LNCEL.actUlpcRachPwrCtrl,LNCEL.actVoipCovBoost,LNCEL.addGbrTrafficRrHo,LNCEL.addGbrTrafficTcHo,LNCEL.addSpectrEmi, LNCEL.allowPbIndexZero,LNCEL.amleMaxNumHo,LNCEL.amlePeriodLoadExchange,LNCEL.cellIndOffServ,LNCEL.cellName,LNCEL.cellResourceSharingMode,LNCEL.cellTechnology,LNCEL.cellType,LNCEL.cqiAperEnable,LNCEL.cqiAperMode,LNCEL.cqiPerSbCycK,LNCEL.cqiPerSimulAck,LNCEL.csgType,LNCEL.dFpucchF1,LNCEL.dFpucchF1b,LNCEL.dFpucchF2,LNCEL.dFpucchF2a,LNCEL.dFpucchF2b,LNCEL.dSrTransMax,LNCEL.defPagCyc,LNCEL.deltaLbCioMargin,LNCEL.deltaPreMsg3,LNCEL.deltaTfEnabled,LNCEL.dlCellPwrRed,LNCEL.dlInterferenceEnable,LNCEL.dlInterferenceLevel,LNCEL.dlInterferenceModulation,LNCEL.dlOlqcEnable,LNCEL.dlPathlossChg,LNCEL.dlPcfichBoost,LNCEL.dlPhichBoost,LNCEL.dlSrbCqiOffset,LNCEL.dlTargetBler,LNCEL.dlamcCqiDef,LNCEL.dlamcEnable,LNCEL.dlsDciCch,LNCEL.dlsOldtcTarget,LNCEL.dlsUsePartPrb,LNCEL.drxProfile101drxInactivityT,LNCEL.drxProfile101drxLongCycle,LNCEL.drxProfile101drxOnDuratT,LNCEL.drxProfile101drxProfileIndex,LNCEL.drxProfile101drxProfilePriority,LNCEL.drxProfile101drxRetransT,LNCEL.drxProfile102drxInactivityT,LNCEL.drxProfile102drxLongCycle,LNCEL.drxProfile102drxOnDuratT,LNCEL.drxProfile102drxProfileIndex,LNCEL.drxProfile102drxProfilePriority,LNCEL.drxProfile102drxRetransT,LNCEL.drxProfile103drxInactivityT,LNCEL.drxProfile103drxLongCycle,LNCEL.drxProfile103drxOnDuratT,LNCEL.drxProfile103drxProfileIndex,LNCEL.drxProfile103drxProfilePriority,LNCEL.drxProfile103drxRetransT,LNCEL.eUlLaAtbPeriod,LNCEL.eUlLaBlerAveWin,LNCEL.eUlLaDeltaMcs,LNCEL.eUlLaLowMcsThr,LNCEL.eUlLaLowPrbThr,LNCEL.eUlLaPrbIncDecFactor,LNCEL.enableAmcPdcch,LNCEL.enableBetterCellHo,LNCEL.enableCovHo,LNCEL.enableLowAgg,LNCEL.enablePcPdcch,LNCEL.energySavingState,LNCEL.eutraCelId,LNCEL.expectedCellSize,LNCEL.fUlLAAtbTrigThr,LNCEL.filterCoeff,LNCEL.filterCoefficientCSFBCpichEcn0,LNCEL.filterCoefficientCSFBCpichRscp,LNCEL.filterCoefficientCpichEcn0,LNCEL.filterCoefficientCpichRscp,LNCEL.filterCoefficientRSRP,LNCEL.filterCoefficientRSRQ,LNCEL.filterCoefficientRSSI,LNCEL.gbrCongHandling,LNCEL.grpAssigPUSCH,LNCEL.harqMaxMsg3,LNCEL.harqMaxTrDl,LNCEL.harqMaxTrUlTtiBundling,LNCEL.harqMaxTxUl,LNCEL.hopModePusch,LNCEL.hysA3Offset,LNCEL.hysThreshold2GERAN,LNCEL.hysThreshold2InterFreq,LNCEL.hysThreshold2Wcdma,LNCEL.hysThreshold2a,LNCEL.hysThreshold3,LNCEL.hysThreshold4,LNCEL.iFLBBearCheckTimer,LNCEL.iFLBHighLoadGBRDL,LNCEL.iFLBHighLoadNonGBRDL,LNCEL.iFLBHighLoadPdcch,LNCEL.iFLBRetryTimer,LNCEL.idleLBCapThresh,LNCEL.idleLBCelResWeight,LNCEL.idleLBPercCaUe,LNCEL.idleLBPercentageOfUes,LNCEL.ilReacTimerUl,LNCEL.inactivityTimer,LNCEL.inactivityTimerQci5Sign,LNCEL.iniMcsDl,LNCEL.iniMcsUl,LNCEL.iniPrbsUl,LNCEL.highLoadGbrDl,LNCEL.highLoadNonGbrDl,LNCEL.highLoadPdcch,LNCEL.hysteresisLoadDlGbr,LNCEL.hysteresisLoadDlNonGbr,LNCEL.hysteresisLoadPdcch,LNCEL.loadBalancingProfile,LNCEL.maxLbPartners,LNCEL.lbLoadFilCoeff,LNCEL.lcrId,LNCEL.cellCapClass,LNCEL.mlbEicicOperMode,LNCEL.nomNumPrbNonGbr,LNCEL.targetLoadGbrDl,LNCEL.targetLoadNonGbrDl,LNCEL.targetLoadPdcch,LNCEL.ulCacIgnore,LNCEL.ulCacSelection,LNCEL.ulStaticCac,LNCEL.longPeriodScellChEst,LNCEL.lowerMarginCio,LNCEL.maxBitrateDl,LNCEL.maxBitrateUl,LNCEL.maxCrPgDl,LNCEL.maxCrRa4Dl,LNCEL.maxCrRaDl,LNCEL.maxCrRaDlHo,LNCEL.maxCrSibDl,LNCEL.maxGbrTrafficLimit,LNCEL.maxNumCaUeScell,LNCEL.maxNumScells,LNCEL.maxNumVoLteProactUlGrantsPerTti,LNCEL.maxPdcchAgg,LNCEL.maxPdcchAggHighLoad,LNCEL.maxPeriodicCqiIncrease,LNCEL.maxPhyCces,LNCEL.mbrSelector,LNCEL.measQuantityCSFBUtra,LNCEL.measQuantityUtra,LNCEL.minBitrateDl,LNCEL.minBitrateUl,LNCEL.mobStateParamNCelChgHgh,LNCEL.mobStateParamNCelChgMed,LNCEL.mobStateParamTEval,LNCEL.mobStateParamTHystNorm,LNCEL.msg3ConsecutiveDtx,LNCEL.msg3DtxOffset,LNCEL.multLoadMeasRrm,LNCEL.multLoadMeasRrmEicic,LNCEL.nbIoTMode,LNCEL.offsetFreqIntra, LNCEL.p0NomPucch,LNCEL.p0NomPusch,LNCEL.pMax,LNCEL.pagingNb,LNCEL.pdcchAggDefUe,LNCEL.pdcchAggMsg4,LNCEL.pdcchAggPaging,LNCEL.pdcchAggPreamb,LNCEL.pdcchAggRaresp,LNCEL.pdcchAggRarespHo,LNCEL.pdcchAggSib,LNCEL.pdcchAlpha,LNCEL.pdcchCqiShift,LNCEL.pdcchHarqTargetBler,LNCEL.pdcchOrderConfig,LNCEL.pdcchUlDlBal,LNCEL.periodicCqiFeedbackType,LNCEL.phyCellId,LNCEL.preventCellActivation,LNCEL.prsMutingInfo,LNCEL.prsMutingInfoPatternLen,LNCEL.prsPowerBoost,LNCEL.puschAckOffI,LNCEL.puschCqiOffI,LNCEL.puschRiOffI,LNCEL.qci1ProtectionTimer,LNCEL.raContResoT,LNCEL.raLargeMcsUl,LNCEL.raMsgPoffGrB,LNCEL.raNondedPreamb,LNCEL.raPreGrASize,LNCEL.raRespWinSize,LNCEL.raSmallMcsUl,LNCEL.raSmallVolUl,LNCEL.rcAmbrMgnDl,LNCEL.rcAmbrMgnUl,LNCEL.rcEnableDl,LNCEL.rcEnableUl,LNCEL.redBwEnDl,LNCEL.redBwMaxRbDl,LNCEL.redBwMaxRbUl,LNCEL.redBwMinRbUl,LNCEL.redBwRpaEnUl,LNCEL.rttCsfbType,LNCEL.sbHoMode,LNCEL.scellBadChQualThr,LNCEL.scellGoodChQualThr,LNCEL.scellNotDetectableThr,LNCEL.shortPeriodScellChEst,LNCEL.t302,LNCEL.t304InterRAT,LNCEL.t304InterRATGsm,LNCEL.t304IntraLte,LNCEL.t304eNaccGsm,LNCEL.t320,LNCEL.tExtendedWait,LNCEL.tLoadMeasX2,LNCEL.tLoadMeasX2Eicic,LNCEL.tPeriodicBsr,LNCEL.tPeriodicPhr,LNCEL.tPingPong,LNCEL.tProhibitPhr,LNCEL.tReTxBsrTime,LNCEL.tStoreUeCntxt,LNCEL.taMaxOffset,LNCEL.taTimer,LNCEL.taTimerMargin,LNCEL.tac,LNCEL.targetSelMethod,LNCEL.threshold1,LNCEL.threshold2GERAN,LNCEL.threshold2InterFreq,LNCEL.threshold2Wcdma,LNCEL.threshold2WcdmaQci1,LNCEL.threshold2a,LNCEL.threshold2aQci1,LNCEL.threshold3,LNCEL.threshold3a,LNCEL.threshold4,LNCEL.timeToTriggerSfHigh,LNCEL.timeToTriggerSfMedium,LNCEL.ttiBundlingBlerTarget,LNCEL.ttiBundlingBlerThreshold,LNCEL.ttiBundlingSinrThreshold,LNCEL.ttibAltUlPrbThreshold,LNCEL.ttibMinUlPrb,LNCEL.ttibOperMode,LNCEL.ttibUlsMinTbs,LNCEL.ulRsCs,LNCEL.ulTargetBler,LNCEL.ulamcAllTbEn,LNCEL.ulamcSwitchPer,LNCEL.ulatbEventPer,LNCEL.ulpcAlpha,LNCEL.p0NomPuschIAw,LNCEL.ulpcCEBalanceIAw,LNCEL.ulpcMinQualIAw,LNCEL.ulpcMinWaitForPc,LNCEL.ulpcRefPwrIAw,LNCEL.ulpcLowlevCch,LNCEL.ulpcLowqualCch,LNCEL.ulpcUplevCch,LNCEL.ulpcUpqualCch,LNCEL.ulpcLowlevSch,LNCEL.ulpcLowqualSch,LNCEL.ulpcUplevSch,LNCEL.ulpcUpqualSch,LNCEL.ulpcReadPeriod,LNCEL.ulsFdPrbAssignAlg,LNCEL.ulsMaxPacketAgg,LNCEL.ulsMinRbPerUe,LNCEL.ulsMinTbs,LNCEL.ulsNumSchedAreaUl,LNCEL.ulsSchedMethod,LNCEL.upperMarginCio,LNCEL.ulsMinNumCoverageLimitationStateCheck,LNCEL.ulsPhrQci1Hyst,LNCEL.ulsPhrQci1Low,LNCEL.act3fdd3tddRestrict,LNCEL.actAutoPucchAlloc,LNCEL.actCombSuperCell,LNCEL.actFastMimoSwitch,LNCEL.actNBIoT,LNCEL.actPuschMask,LNCEL.actRepeaterMode,LNCEL.actSuperCell,LNCEL.actUciOnlyGrants,LNCEL.actUlMultiCluster,LNCEL.addNumDrbRadioReasHo,LNCEL.addNumDrbTimeCriticalHo,LNCEL.addNumQci1DrbRadioReasHo,LNCEL.addNumQci1DrbTimeCriticalHo,LNCEL.applyFeicicFunctionality,LNCEL.blankedPucch,LNCEL.dlChBw AS dlChBw2, LNCEL.dlMimoMode,LNCEL.dlRsBoost,LNCEL.dlpcMimoComp,LNCEL.eIcicCioAdaptAlgo,LNCEL.eIcicMaxCre,LNCEL.earfcnDL as earfcnDL1, LNCEL.earfcnUL,LNCEL.idleLBCapThreshCaUe,LNCEL.inactivityTimerMult,LNCEL.inactivityTimerPubSafety,LNCEL.maxNrSymPdcch,LNCEL.maxNumActDrb,LNCEL.maxNumActUE,LNCEL.maxNumCaConfUe,LNCEL.maxNumCaConfUe3c,LNCEL.maxNumCaConfUeDc,LNCEL.maxNumQci1Drb,LNCEL.maxNumUeDl,LNCEL.maxNumUeUl,LNCEL.maxPrbHighPrioUciGrant,LNCEL.mdtxAggressiveness,LNCEL.mdtxPdcchSymb,LNCEL.mimoClCqiThD,LNCEL.mimoClCqiThU,LNCEL.mimoClRiThD,LNCEL.mimoClRiThU,LNCEL.mimoOlCqiThD,LNCEL.mimoOlCqiThU,LNCEL.mimoOlRiThD,LNCEL.mimoOlRiThU,LNCEL.multCioAdaptExecEicic,LNCEL.multNumUeHighPrioUciGrant,LNCEL.multUciGrant,LNCEL.nOverbookingRac,LNCEL.prachCS,LNCEL.prachConfIndex,LNCEL.prachFreqOff,LNCEL.prachHsFlag,LNCEL.prsConfigurationIndex,LNCEL.prsNumDlFrames,LNCEL.pucchNAnCs,LNCEL.rfSensitivity,LNCEL.rootSeqIndex,LNCEL.srsPwrOffset,LNCEL.syncSigTxMode,LNCEL.ttibSinrThresholdIn,LNCEL.ttibSinrThresholdOut,LNCEL.ueLevelMroOffset,LNCEL.ulChBw,LNCEL.ulCombinationMode,LNCEL.ulpcRarespTpc,LNCEL.angle,LNCEL.deploymentType,LNCEL.act1TxIn2Tx,LNCEL.actLiquidCell,LNCEL.actSdlc,LNCEL.cellPwrRedForMBMS,LNCEL.creCqiAvg,LNCEL.eIcicAbsAdaptationBeta,LNCEL.eIcicAbsAdaptationThreshold0To1,LNCEL.eIcicAbsDeltaAdjustment,LNCEL.eIcicAbsPatChangeDelayT,LNCEL.eIcicCreDelta,LNCEL.eIcicMp0DelayT,LNCEL.eIcicPartnerCacAbsTarget,LNCEL.eIcicPartnerCacTarget,LNCEL.ecidMeasSupervisionTimer,LNCEL.iFServiceBasedHoRetryTimer,LNCEL.maxNbrTrafficLimit,LNCEL.maxPrbsPerNbrUe,LNCEL.nbrCongHandling,LNCEL.rttCellIdInfo,LNCEL.selectOuterPuschRegion,LNCEL.srsActivation,LNCEL.tPageCorrInt,LNCEL.eIcicMaxMutePattern,LNCEL.eIcicMaxNumPartners,LNCEL.pref4LayerMimoVsCAggr,LNCEL.threshold2GERANQci1,LNCEL.threshold2InterFreqQci1,LNCEL.a3ReportAmount,LNCEL.a5ReportAmount,LNCEL.a5TriggerQuantityIntraFreqHO,LNCEL.actAntPortMap,LNCEL.actCaArchEnh,LNCEL.actCaBlocking,LNCEL.actCaScellSchedWeightFactor,LNCEL.actDlPwBackoff,LNCEL.actDlsLdAdaptPf,LNCEL.actDynamicDataSessionProf,LNCEL.actFlowCtrlEnh,LNCEL.actForcedDrxS1Ho,LNCEL.actHapPrachCfg,LNCEL.actHapPrachTaFilt,LNCEL.actQci1BlerTgt,LNCEL.actReducedFormat,LNCEL.actScellBadChQualExtMonitor,LNCEL.actTcpServiceDiff,LNCEL.actUl256QamChQualEst,LNCEL.actUlDynamicTargetBler,LNCEL.actUlsLdAdaptPf,LNCEL.actVoLteSrcRate,LNCEL.adaptPdcchDwellTime,LNCEL.amRlcSnFieldLengthDl,LNCEL.caPoolId,LNCEL.dlCaCqiWindow,LNCEL.dlCaMinPcellCqi,LNCEL.dlCaMinPcellCqiQci1,LNCEL.drxInactivityT,LNCEL.drxLongCycle,LNCEL.drxOnDuratT,LNCEL.drxProfileIndex,LNCEL.drxProfilePriority,LNCEL.drxRetransT,LNCEL.harqMaxTrSignalingDl,LNCEL.harqMaxTrVoLteDl,LNCEL.pdcchCqiShift4Tx,LNCEL.puschHarqMode,LNCEL.scellFastSchedulingSelect,LNCEL.syncDeboost4Tx,LNCEL.t301Guard,LNCEL.ulCaMinPcellSinr,LNCEL.ulCaMinPcellSinrQci1,LNCEL.ulCaSinrWindow,LNCEL.perDl256QamChQualEst,
LNCEL.activatedMimoTM,LNCEL.ocAcBarACOvl,LNCEL.ocAcBarTimeOvl,LNCEL.ocAcProbFacOvl,LNCEL.sigAcBarACOvl,LNCEL.sigAcBarTimeOvl,LNCEL.sigAcProbFacOvl,LNCEL.acBarSkipForMMTELVideo,LNCEL.acBarSkipForMMTELVoice,LNCEL.acBarSkipForSMS,LNCEL.addAUeRrHo,LNCEL.addAUeTcHo,LNCEL.addEmergencySessions,LNCEL.applyOutOfSyncState,LNCEL.autoACBarringStopTimer,LNCEL.autoAcBarringStartTimer,LNCEL.celResTiFHM,LNCEL.celResTiFMM,LNCEL.cellBarred,LNCEL.cellReSelPrio AS cellReSelPrio1, LNCEL.cellSrPeriod,LNCEL.cqiPerNp,LNCEL.deltaPucchShift,LNCEL.dl64QamEnable,LNCEL.drxApplyDeviceType,LNCEL.drxProfile1drxProfileIndex,LNCEL.drxProfile1drxProfilePriority,LNCEL.drxProfile2drxInactivityT,LNCEL.drxProfile2drxLongCycle,LNCEL.drxProfile2drxOnDuratT,LNCEL.drxProfile2drxProfileIndex,LNCEL.drxProfile2drxProfilePriority,LNCEL.drxProfile2drxRetransT,LNCEL.drxProfile3drxInactivityT,LNCEL.drxProfile3drxLongCycle,LNCEL.drxProfile3drxOnDuratT,LNCEL.drxProfile3drxProfileIndex,LNCEL.drxProfile3drxProfilePriority,LNCEL.drxProfile3drxRetransT,LNCEL.drxProfile4drxInactivityT,LNCEL.drxProfile4drxLongCycle,LNCEL.drxProfile4drxOnDuratT,LNCEL.drxProfile4drxProfileIndex,LNCEL.drxProfile4drxProfilePriority,LNCEL.drxProfile4drxRetransT,LNCEL.drxProfile5drxInactivityT,LNCEL.drxProfile5drxLongCycle,LNCEL.drxProfile5drxOnDuratT,LNCEL.drxProfile5drxProfileIndex,LNCEL.drxProfile5drxProfilePriority,LNCEL.drxProfile5drxRetransT,LNCEL.drxSmartProfile2drxInactivityT,LNCEL.drxSmartProfile2drxLongCycle,LNCEL.drxSmartProfile2drxOnDuratT,LNCEL.drxSmartProfile2drxProfileIndex,LNCEL.drxSmartProfile2drxProfilePriority,LNCEL.drxSmartProfile2drxRetransT,LNCEL.drxSmartProfile2drxShortCycle,LNCEL.drxSmartProfile2drxShortCycleT,LNCEL.drxSmartProfile2smartStInactFactor,LNCEL.drxSmartProfile3drxInactivityT,LNCEL.drxSmartProfile3drxLongCycle,LNCEL.drxSmartProfile3drxOnDuratT,LNCEL.drxSmartProfile3drxProfileIndex,LNCEL.drxSmartProfile3drxProfilePriority,LNCEL.drxSmartProfile3drxRetransT,LNCEL.drxSmartProfile3drxShortCycle,LNCEL.drxSmartProfile3drxShortCycleT,LNCEL.drxSmartProfile3smartStInactFactor,LNCEL.drxSmartProfile4drxInactivityT,LNCEL.drxSmartProfile4drxLongCycle,LNCEL.drxSmartProfile4drxOnDuratT,LNCEL.drxSmartProfile4drxProfileIndex,LNCEL.drxSmartProfile4drxProfilePriority,LNCEL.drxSmartProfile4drxRetransT,LNCEL.drxSmartProfile4drxShortCycle,LNCEL.drxSmartProfile4drxShortCycleT,LNCEL.drxSmartProfile4smartStInactFactor,LNCEL.drxSmartProfile5drxInactivityT,LNCEL.drxSmartProfile5drxLongCycle,LNCEL.drxSmartProfile5drxOnDuratT,LNCEL.drxSmartProfile5drxProfileIndex,LNCEL.drxSmartProfile5drxProfilePriority,LNCEL.drxSmartProfile5drxRetransT,LNCEL.drxSmartProfile5drxShortCycle,LNCEL.drxSmartProfile5drxShortCycleT,LNCEL.drxSmartProfile5smartStInactFactor,LNCEL.eCallAcBarred,LNCEL.eCallAcBarredOvl,LNCEL.enableDl16Qam,LNCEL.intrFrqCelRes,LNCEL.intraPresAntP,LNCEL.maxNumRrc,LNCEL.maxNumRrcEmergency,LNCEL.modPeriodCoeff,LNCEL.n1PucchAn,LNCEL.n310,LNCEL.n311,LNCEL.nCqiRb,LNCEL.nPucchF3Prbs,LNCEL.phichDur,LNCEL.phichRes,LNCEL.prachPwrRamp,LNCEL.preambTxMax,LNCEL.primPlmnCellres,LNCEL.qHyst,LNCEL.qrxlevmin AS qrxlevmin1, LNCEL.qrxlevminintraF AS qrxlevminintraF1, LNCEL.riEnable,LNCEL.riPerM,LNCEL.riPerOffset,LNCEL.sIntrasearch,LNCEL.sNonIntrsearch,LNCEL.siWindowLen,LNCEL.sib2SchedulingsiMessagePeriodicity,LNCEL.sib2SchedulingsiMessageRepetition,LNCEL.sib2SchedulingsiMessageSibType,LNCEL.sib2xTransmit,LNCEL.sib3SchedulingsiMessagePeriodicity,LNCEL.sib3SchedulingsiMessageRepetition,LNCEL.sib3SchedulingsiMessageSibType,LNCEL.nCellChgHigh,LNCEL.nCellChgMed,LNCEL.qHystSfHigh,LNCEL.qHystSfMed,LNCEL.tEvaluation,LNCEL.tHystNormal,LNCEL.stInactFactor,LNCEL.t300,LNCEL.t301,LNCEL.t310,LNCEL.t311,LNCEL.tReselEutr,LNCEL.threshSrvLow,LNCEL.ulpcIniPrePwr,LNCEL.SBTS_id,LNCEL.acBarCsfbOcacBarAC,LNCEL.acBarCsfbOcacBarTime,LNCEL.acBarCsfbOcprobFac,LNCEL.acBarCsfbOcOvlacBarACOvl,LNCEL.acBarCsfbOcOvlacBarTimeOvl,LNCEL.acBarCsfbOcOvlprobFacOvl,LNCEL.acBarMMTelVideoOcacBarAC,LNCEL.acBarMMTelVideoOcacBarTime,LNCEL.acBarMMTelVideoOcprobFac,LNCEL.acBarMMTelVideoOcOvlacBarACOvl,LNCEL.acBarMMTelVideoOcOvlacBarTimeOvl,LNCEL.acBarMMTelVideoOcOvlprobFacOvl,LNCEL.acBarMMTelVoiceOcacBarAC,LNCEL.acBarMMTelVoiceOcacBarTime,LNCEL.acBarMMTelVoiceOcprobFac,LNCEL.acBarMMTelVoiceOcOvlacBarACOvl,LNCEL.acBarMMTelVoiceOcOvlacBarTimeOvl,LNCEL.acBarMMTelVoiceOcOvlprobFacOvl,LNCEL.ocAcBarAC,LNCEL.ocAcBarTime,LNCEL.ocAcProbFac,LNCEL.sigAcBarAC,LNCEL.sigAcBarTime,LNCEL.sigAcProbFac,LNCEL.arpPrioLev,LNCEL.nbrUlDlSF,LNCEL.schedulingWeightSF,LNCEL.tC2KMeasReport,LNCEL.tC2KRelocPrep,LNCEL.tC2kRelocExec,LNCEL.tULHOPrepTransfer,LNCEL.actDlIsh,LNCEL.amountBlankedRes,LNCEL.ishPrId,LNCEL.altitude,LNCEL.confidence,LNCEL.degreesOfLatitude,LNCEL.degreesOfLongitude,LNCEL.directionOfAltitude,LNCEL.latitudeSign,LNCEL.orientationOfMajorAxis,LNCEL.uncertaintyAltitude,LNCEL.uncertaintySemiMajor,LNCEL.uncertaintySemiMinor,LNCEL.tC2KRelocOverallHrpd,LNCEL.tC2KRelocPrepHrpd,LNCEL.tUlHoPrepTransferHrpd,LNCEL.csiRsPwrOffsetAP,LNCEL.csiRsPwrOffsetOverlap,LNCEL.csiRsSubfr,LNCEL.liquidCellSuMuMode,LNCEL.uLMeasAlphaBase,LNCEL.uLMeasHystJT,LNCEL.uLMeasHystSuMu,LNCEL.uLMeasN,LNCEL.uLMeasThrJtCsiRs,LNCEL.uLMeasThrSuMuCsiRs,LNCEL.mbmsNeighCellConfigIntraF,LNCEL.pMaxOwnCell,LNCEL.enableVoLteUePcellSwap,LNCEL.numCaUeThreshold,LNCEL.pFreqPrio,LNCEL.pcellSwapMaxHoRate,LNCEL.puschLoadHysteresis,LNCEL.puschLoadIndexThr,LNCEL.scellChQualThreshold,LNCEL.scellStateForPcellSwap,LNCEL.ulSinrLowThreshold,LNCEL.reportAmountPerLoc,LNCEL.reportIntervalPerLoc,LNCEL.qci1DrxOffThreshold,LNCEL.qci1DrxOnThreshold,LNCEL.qci1DlTargetBler,LNCEL.qci1HarqMaxTrDl,LNCEL.qci1HarqMaxTrUl,LNCEL.qci1ReconStopTimer,LNCEL.qci1ThroughputFactorDl,LNCEL.qci1ThroughputFactorUl,LNCEL.qci1UlTargetBler,LNCEL.actRIPAlarming,LNCEL.alarmThresholdCrossingTime,LNCEL.alarmThresholdULSF,LNCEL.a1ReportInterval,LNCEL.a2TimeToTriggerMobRsrq,LNCEL.hysThreshold2MobRsrq,LNCEL.threshold2MobRsrq,LNCEL.threshold2aRsrq,LNCEL.a2TimeToTriggerRedirectRsrq,LNCEL.hysThreshold4Rsrq,LNCEL.threshold4Rsrq,LNCEL.a2TimeToTriggerActC2kMeas,LNCEL.hysThreshold2C2k,LNCEL.threshold2C2k,LNCEL.threshold2C2kQci1,LNCEL.deltaFPucchF1bCSr10,LNCEL.deltaFPucchF3r10,LNCEL.utranLbLoadThresholdshighLoadGbrDl,LNCEL.utranLbLoadThresholdshighLoadNonGbrDl,LNCEL.utranLbLoadThresholdshighLoadPdcch, LNCEL.maxNumUeProactiveUl,LNCEL.maxNumUeProactiveUlNonTxSkip,LNCEL.cellResetRequest,LNCEL.t312,LNCEL.n310Qci1,LNCEL.dlsPdschNbrCongDetAct,LNCEL.pdcchCongDetActDl,LNCEL.pdcchCongDetActUl,LNCEL.ulsPuschNbrCongDetAct,LNCEL.actMfbiDupFre,LNCEL.actTtibAdaptUlMinTbs,LNCEL.useT312,LNCEL.expectedCellRange,LNCEL.pciControl,LNCEL.n310PubSafety,LNCEL.dl256QamDeactChQualThr,LNCEL.dl256QamReactChQualThr,LNCEL.iFLBCandSelUpdateTimer,LNCEL.idleLBCapThreshCaUeAdv,LNCEL.minInactivityTimeThresh,LNCEL.threshold2InterFreqHpue,LNCEL.threshold2aHpue,LNCEL.ttibMinDelayAfterBearerSetup,LNCEL.ttibSinrDwellTimeIn,LNCEL.ttibSinrDwellTimeOut,LNCEL.voLteProactUlGrantPeriodRegTx,LNCEL.voLteProactUlGrantPeriodTtib,LNCEL.zsonPciPrachControl,LNCEL.zsonProfileId,LNCEL.actAir2Ground,LNCEL.actDeltaCqiAgingScellChEst,LNCEL.actEirpControl,LNCEL.actFastPdcchAdapt,LNCEL.actMaxNumUeDlNonGbr,LNCEL.actMcsUpgrade,LNCEL.actResourceAllocType1,LNCEL.actVoipCovBoostEnh,LNCEL.iFLBA4ActLim,LNCEL.maxNumAmleNeigh,LNCEL.idleLBPercUeTM9,LNCEL.lteNrDssMode,LNCEL.prachDetThresScaling,LNCEL.adaptMaxUEConn,LNCEL.prachControl,LNCEL.pucchControl,LNCEL.incIRATHeadroom,LNCEL.iniDl256QamChQualEst,LNCEL.maxNumIFCarrMeas,LNCEL.respectIncMonLimits,LNCEL.threshold3RsrqIntraFreq,LNCEL.threshold3aRsrqIntraFreq,LNCEL.voLteProactUlGrantNonTtibTxSkip,LNCEL.voLteProactUlGrantPeriodTtibTxSkip,LNCEL.iFLBLoadStepGBRDL,LNCEL.iFLBLoadStepNonGBRDL,LNCEL.iFLBLoadStepPdcch,LNCEL.t310PubSafety,
B."Escenario Configuracion Banda 1900" AS Escenario_1900BL, B.Latitud, B.Longitud, B.Zona, BL.Azimuth AS Az, BL."Tilt Electrico" AS Tilt_E,
BL."Tilt Mecanico" AS Tilt_M, BL.Antena, BL."Altura Antena" AS Altura_Antena
FROM ((((LNCEL LEFT JOIN LNBTS ON (LNCEL.PLMN_Id=LNBTS.PLMN_Id) AND (LNCEL.MRBTS_Id=LNBTS.MRBTS_Id) AND (LNCEL.LNBTS_Id=LNBTS.LNBTS_Id))
LEFT JOIN LNCEL_FDD ON (LNCEL.PLMN_Id=LNCEL_FDD.PLMN_Id) AND (LNCEL.MRBTS_Id=LNCEL_FDD.MRBTS_Id) AND (LNCEL.LNBTS_Id=LNCEL_FDD.LNBTS_Id) AND
(LNCEL.LNCEL_Id=LNCEL_FDD.LNCEL_Id)) LEFT JOIN SIB ON (LNCEL.PLMN_Id=SIB.PLMN_Id) AND (LNCEL.MRBTS_Id=SIB.MRBTS_Id) AND (LNCEL.LNBTS_Id=SIB.LNBTS_Id) AND
(LNCEL.LNCEL_Id=SIB.LNCEL_Id)) LEFT JOIN baselinesite AS B ON (B.Sitio = LNBTS.name COLLATE NOCASE))
LEFT JOIN Baseline_LTE AS BL ON (LNCEL.name = BL.LNB COLLATE NOCASE)
GROUP BY LNCEL.eutraCelId;
--
--
CREATE INDEX l_lncel ON LNCEL_Full (MRBTS_id, LNBTS_id, LNCEL_id);
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
--626 651 675: 50-130, 2434 2437 2453: 30-200, 3075 3100: 60-110, 3225: 70-90, 9560: 40-150, other:80-70
--
DROP TABLE IF EXISTS LTE_Param;
CREATE TABLE LTE_Param AS
SELECT
L.LNCELname, L.LNBTSname, L.Zona, L.Cluster, L.Region, L.Depto, L.Mun, substr(L.LNBTSname,1,3) AS Prefijo, L.Sector, L.KeySector, L.PLMN_id, L.MRBTS_id, L.LNBTS_id,
L.LNCEL_id, L.Banda, L.earfcnDL, L.eutraCelId, L.phyCellId, L.rootSeqIndex, L.PowerBoost,
CASE WHEN L.dlMimoMode = 40 THEN "Closed_Loop_Mimo" ELSE (CASE WHEN L.dlMimoMode = 43 THEN "Closed_Loop_MIMO_4x4" ELSE
(CASE WHEN L.dlMimoMode = 0 THEN "SingleTX" ELSE (CASE WHEN L.dlMimoMode = 30 THEN "Dynamic_Open_Loop_MIMO" ELSE
(CASE WHEN L.dlMimoMode = 41 THEN "Closed_Loop_MIMO_4x2" ELSE (CASE WHEN L.dlMimoMode = 10 THEN "TXDiv" ELSE
(CASE WHEN L.dlMimoMode = 11 THEN "4-way_TXDiv" ELSE (CASE WHEN L.dlMimoMode = 42 THEN "Closed_Loop_MIMO_8x2" ELSE
(CASE WHEN L.dlMimoMode = 44 THEN "Closed_Loop_MIMO_8x4" ELSE NULL END)END)END)END)END)END)END)END)END AS dlMimoMode,
(L.angle)/10 AS tilt, L.Tilt_E, L.Tilt_M, L.Az,  L.Antena, L.Altura_Antena, L.Latitud, L.Longitud, L.Estado, L.LNBTS_OpSt, L.LNCEL_AdSt ,L.LNCEL_OpSt,
L.PCIMod3, L.PCIMod6, L.PCIMod30, L.earfcnUL, L.moVersion, L.moVersionl, L.lcrId, (L.MRBTS_id||L.lcrId) AS Klcrid, L.tac,L.cellType,L.maxNumActDrb,L.maxNumActUE,L.maxNumUeDl,L.maxNumUeUl,L.mbrSelector,L.t302,L.t304InterRAT,L.t304InterRATGsm,L.t304IntraLte,L.t304eNaccGsm,L.t320,L.hopModePusch,L.pMax,L.actDrx, L.t300,L.t301,L.t310,L.t311,L.tEvaluation,L.tHystNormal,L.qHyst,L.cellReSelPrio,L.n310,L.qrxlevmin,L.QrxlevminintraF,L.sIntrasearch,L.sNonIntrsearch, L.threshold1,
L.threshold3, L.threshold3a, L.threshold2InterFreqQci1, L.threshold2a, L.threshold2aQci1, L.threshold2Wcdma, L.threshold2WcdmaQci1, L.threshold4, L.a3Offset,
L.measQuantityUtra, L.threshold2InterFreq, L.dlCellPwrRed,L.dlChBw1, L.dlChBw2,L.a2TimeToTriggerActWcdmaMeas, L.DistName, L.Escenario_1900BL, S.Escenario_1900,
L.Latitud AS Deci_Lat, L.Longitud AS Deci_Lon, L.MRBTS_id AS Mtx_Site, L.eutraCelId AS Mtx_Site_ID, L.Sector*1 AS sector_ID, L.LNCELname AS Site_Name,
CASE WHEN L.earfcnDL < 1200 THEN 50 ELSE (CASE WHEN L.earfcnDL < 2650 THEN 30 ELSE (CASE WHEN L.earfcnDL < 3101 THEN 60 ELSE
(CASE WHEN L.earfcnDL < 3450 THEN 70 ELSE (CASE WHEN L.earfcnDL < 9610 THEN 40 ELSE 80 END)END)END)END)END AS Beamwidth,
CASE WHEN L.Zona = 'Rural' THEN (CASE WHEN L.earfcnDL < 1200 THEN 130 ELSE (CASE WHEN L.earfcnDL < 2650 THEN 200 ELSE
(CASE WHEN L.earfcnDL < 3101 THEN 110 ELSE (CASE WHEN L.earfcnDL < 3450 THEN 90 ELSE (CASE WHEN L.earfcnDL < 9610 THEN 150 ELSE 70 END)END)END)END)END)
ELSE (CASE WHEN L.earfcnDL < 1200 THEN 60 ELSE (CASE WHEN L.earfcnDL < 2650 THEN 90 ELSE (CASE WHEN L.earfcnDL < 3101 THEN 50 ELSE
(CASE WHEN L.earfcnDL < 3450 THEN 40 ELSE (CASE WHEN L.earfcnDL < 9610 THEN 75 ELSE 30 END)END)END)END)END) END AS Radius, L.Az AS Azimuth
FROM LNCEL_Full AS L LEFT JOIN Sites_L1900 AS S ON (L.LNBTSname = S.LNBTSname);
--
--
--
DROP TABLE IF EXISTS Sites_L9560;
CREATE TABLE Sites_L9560 AS
SELECT DISTINCT
L.LNBTSname, L.earfcnDL
FROM LTE_Param AS L
WHERE L.earfcnDL = 9560 AND L.LNBTSname IS NOT NULL;
--
DROP TABLE IF EXISTS Sites_L3225;
CREATE TABLE Sites_L3225 AS
SELECT DISTINCT
L.LNBTSname, L.earfcnDL
FROM LTE_Param AS L
WHERE L.earfcnDL = 3225 AND L.LNBTSname IS NOT NULL;
--
DROP TABLE IF EXISTS Sites_L3075;
CREATE TABLE Sites_L3075 AS
SELECT DISTINCT
L.LNBTSname, L.earfcnDL
FROM LTE_Param AS L
WHERE L.earfcnDL = 3075 AND L.LNBTSname IS NOT NULL;
--
--
--
--
--WCEL_FULL1
DROP TABLE IF EXISTS WCEL_FULL1;
CREATE TABLE WCEL_FULL1 AS
SELECT DISTINCT
WCEL.name AS WCELName, B.Cluster, B.Region, B.Departamento AS Depto, B.Municipio AS Mun, substr(WCEL.name,1,3) AS Prefijo, B.Zona, B.Latitud, B.Longitud, BL.Antena, BL."Altura Antena" AS Altura_Antena, BL.Azimuth, BL."Tilt Electrico" AS Tilt_E, BL."Tilt Mecanico" AS Tilt_M, BL."Map Length" AS Map_Length, BL."Map Beam" AS Map_Beam, B."Escenario Configuracion Banda 1900" AS Escenario_1900BL, S.Escenario_1900, WCEL.UARFCN, CASE WHEN WCEL.UARFCN < 9685 THEN 850 ELSE 1900 END Banda, WBTS.name AS WBTSName, WCEL.PLMN_id, RNC.name AS RNCName, RNC.RNC_id, WBTS.WBTS_id, WCEL.WCEL_id, WCEL_URAID.Value AS URAid,
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
SELECT W.WCELName, W.WBTSName, W.Cluster, W.Region, W.Depto, W.Mun, W.Prefijo, W.Banda, W.PLMN_id, W.Sector, W.WCEL_id, W.RNCName, W.RNC_id, W.WBTS_id, W.CId, W.Latitud, W.Longitud, W.Antena, W.Altura_Antena, W.Azimuth, W.Tilt_E, W.Tilt_M, W.Map_Length, W.Map_Beam, W.PriScrCode, (W.angle)/10 AS tilt, W.LAC, W.RAC, W.AdminCellState, W.WCelState, W.moversion AS version , W.URAid, W.PCH24kbpsEnabled, W.NbrOfSCCPCHs,
W.Tcell, W.PrxTarget, W.PtxPrimaryCPICH, W.PtxCellMax, W.MaxDLPowerCapability, W.PtxHighHSDPAPwr, W.PtxTarget, W.PtxTargetPSMax, W.PtxTargetPSMin, W.PtxMaxHSDPA,
W.PtxDLabsMax, W.MaxNbrOfHSSCCHCodes, W.InitialBitRateDL, W.InitialBitRateUL, W.MinAllowedBitRateDL, W.MinAllowedBitRateUL, W.T300, W.T312, W.T313, W.N300,
W.N312, W.N313, W.N315, W.T315, W.RtFmcsIdentifier, W.NrtFmcsIdentifier, W.RTWithHSDPAFmcgIdentifier, W.RTWithHSDPAFmciIdentifier,
W.RTWithHSDPAFmcsIdentifier, W.NrtFmcgIdentifier, W.NrtFmciIdentifier, W.RtFmcgIdentifier, W.RtFmciIdentifier, W.FMCLIdentifier, W.LTELayeringMeasActivation, W.UARFCN, W.SHCS_RAT, W.SsearchHCS,
W.SHCS_RATConn, W.SsearchHCSConn, W.PrxOffset, W.PrxNoise, W.CSAMRModeSET, W.CSAMRModeSETWB,  W.CellBarred, W.HSPA128UsersPerCell, W.SectorID,
W.HSDPAFmciIdentifier, W.HSDPAFmcsIdentifier, W.HSPAFmcsIdentifier, W.HSDPAFmcgIdentifier,
W.WCDMACellReselection, W.LTECellReselection, W.GSMCellReselection, W.QqualMin, W.QrxlevMin, W.AbsPrioCellReselec, W.RACHInterFreqMesQuant,
W.BlindHORSCPThrTarget, W.BlindHOEcNoThrTarget, W.Sprioritysearch1, W.Sprioritysearch2, W.Threshservlow, W.Threshservlow2,
W.AdminPICState, W.ULLoadStateHSUOffset, W.MaxNumberEDCHCell, W.MaxNumberHSDPAUsers, W.SmartLTELayeringEnabled, W.LTEHandoverEnabled, W.SmartLTELayeringRSCP,
W.IncomingLTEISHO, W.CellDN, W.SectorIdName, W.Escenario_1900BL, W.Escenario_1900,
W.Latitud AS Deci_Lat, W.Longitud AS Deci_Lon, W.WBTS_id AS Mtx_Site, W.CId AS Mtx_Site_ID, W.SectorID*1 AS sector_ID, W.WCELName AS Site_Name,
CASE WHEN W.Zona = 'Rural' THEN (
CASE WHEN W.UARFCN < 4365 THEN (CASE WHEN G.'Map Length' < 3 THEN 90 ELSE (36*G.'Map Length') END) ELSE (CASE WHEN W.UARFCN < 4388 THEN
(CASE WHEN G.'Map Length' < 3 THEN 80 ELSE (30*G.'Map Length') END) ELSE (CASE WHEN W.UARFCN < 9701 THEN
(CASE WHEN G.'Map Length' < 3 THEN 110 ELSE (50*G.'Map Length') END) ELSE (CASE WHEN G.'Map Length' < 3 THEN 100 ELSE (43*G.'Map Length') END) END)END)END)
ELSE (
CASE WHEN W.UARFCN < 4365 THEN (CASE WHEN G.'Map Length' < 3 THEN 50 ELSE (18*G.'Map Length') END) ELSE (CASE WHEN W.UARFCN < 4388 THEN
(CASE WHEN G.'Map Length' < 3 THEN 40 ELSE (15*G.'Map Length') END) ELSE (CASE WHEN W.UARFCN < 9701 THEN
(CASE WHEN G.'Map Length' < 3 THEN 70 ELSE (25*G.'Map Length') END) ELSE (CASE WHEN G.'Map Length' < 3 THEN 60 ELSE (21*G.'Map Length') END) END)END)END
)
END AS Radius,
CASE WHEN W.UARFCN < 4365 THEN (CASE WHEN G.'Map Beam' < 30 THEN 50 ELSE (G.'Map Beam') END) ELSE (CASE WHEN W.UARFCN < 4388 THEN
(CASE WHEN G.'Map Beam' < 30 THEN 60 ELSE (CASE WHEN G.'Map Beam' > 350 THEN G.'Map Beam' - 30 ELSE G.'Map Beam' + 10 END) END) ELSE
(CASE WHEN W.UARFCN < 9701 THEN (CASE WHEN G.'Map Beam' < 30 THEN 30 ELSE (G.'Map Beam' - 20) END) ELSE
(CASE WHEN G.'Map Beam' < 30 THEN 40 ELSE (G.'Map Beam' - 10) END) END)END)END AS Beamwidth, W.BTSSupportForHSPACM, W.NEType, W.Estado, W.SAC,
W.WCELMCC, W.WCELMNC
FROM WCEL_FULL1 AS W LEFT JOIN Baseline_UMTS AS G ON (W.WCELName = G.BTS_Name COLLATE NOCASE)
WHERE W.WCEL_id IS NOT NULL
ORDER BY W.WCELName IS NULL OR W.WCELName='', W.WCELName;
--
--
--
--
-- lte hw inv tables
--
DROP TABLE IF EXISTS RMOD_R_L;
CREATE TABLE RMOD_R_L AS
SELECT * FROM RMOD_R_ACTIVECELLSLIST
UNION ALL
SELECT * FROM RMOD_R_ACTIVELTECELLSLIST;
--
DROP TABLE IF EXISTS RMOD_LTE;
CREATE TABLE RMOD_LTE AS
SELECT
l.LNCELname,l.Cluster, l.Region, l.Zona, l.Depto, l.Mun, l.Prefijo,  l.PLMN_id, l.MRBTS_id, l.LNBTS_id, l.LNCEL_id, l.lcrId, l.earfcnDL,
l.tilt AS tilt_e_dump,
r.moVersion AS moVersionr,r.distName AS distNamer ,r.PLMN_id,r.MRBTS_id,r.EQM_R_id,r.APEQM_R_id,r.RMOD_R_id,r.OPTITEM_id,r.Value,
rr.chassisProductCode,rr.chassisSerialNumber,rr.configDN,rr.hwVersion,rr.nrOfTXElements,rr.operationalState,rr.proceduralStatus,rr.productCode,
rr.productName,rr.radioMasterDN,rr.radioModuleHwReleaseCode,rr.serialNumber
FROM (LTE_Param l LEFT JOIN RMOD_R_L r ON (l.PLMN_id=r.PLMN_id AND l.MRBTS_id=r.MRBTS_id AND l.lcrid=r.Value))
LEFT JOIN RMOD_R rr ON rr.distName = r.distName
ORDER BY l.LNCELname IS NULL OR l.LNCELname='', l.LNCELname;
--
--
DROP TABLE IF EXISTS RETU_info;
CREATE TABLE RETU_info AS
SELECT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.Prefijo,a.PLMN_id,a.MRBTS_id,a.EQM_R_id,a.APEQM_R_id,a.ALD_R_id, r.RETU_R_id, a.hwVersion,a.operationalState, a.productCode,
a.releaseId3Gpp,a.retDeviceType, a.serialNumber,a.swVersion,a.vendorCode,a.moVersion,a.distName,a.configDN,
r.RETU_R_id,r.angle/10 AS angle,r.maxAngle,r.mechanicalAngle,r.minAngle,r.operationalState, r.subunitNumber,
r.antBearing, r.antModel,r.antSerial,r.baseStationID,r.sectorID,r.moVersion AS Versionr ,r.distName AS distNamer ,r.configDN AS configDNr
FROM (ALD_R a LEFT JOIN RETU_R r ON (a.PLMN_id=r.PLMN_id AND a.MRBTS_id=r.MRBTS_id AND a.EQM_R_id=r.EQM_R_id AND a.APEQM_R_id=r.APEQM_R_id AND a.ALD_R_id=r.ALD_R_id))
LEFT JOIN LNBTS_Full B ON (a.PLMN_id=B.PLMN_id AND a.MRBTS_id=B.MRBTS_id)
ORDER BY B.LNBTSname IS NULL OR B.LNBTSname='', B.LNBTSname;
--
DROP TABLE IF EXISTS ANTL_info;
CREATE TABLE ANTL_info AS
SELECT
r.LNBTSname, r.Cluster, r.Region, r.Depto, r.Mun, r.Prefijo,r.PLMN_id,r.MRBTS_id,r.EQM_R_id,r.APEQM_R_id,r.ALD_R_id, r.RETU_R_id, r.hwVersion,
r.operationalState, r.productCode, r.releaseId3Gpp, r.retDeviceType, r.serialNumber, r.swVersion, r.vendorCode, r.moVersion, r.distName,
r.configDN, r.RETU_R_id, r.angle, r.maxAngle, r.mechanicalAngle, r.minAngle,r.operationalState, r.subunitNumber,
r.antBearing, r.antModel,r.antSerial,r.baseStationID,r.sectorID,r.Versionr ,r.distNamer ,r.configDNr, a.OPTITEM_id, A.Value,
"PLMN-PLMN/"||SUBSTR(A.Value, 1, INSTR(A.Value, '/ANTL')-1) AS rmod_dn
FROM RETU_info r LEFT JOIN RETU_R_ANTLDNLIST a ON (a.PLMN_id=r.PLMN_id AND a.MRBTS_id=r.MRBTS_id AND a.EQM_R_id=r.EQM_R_id
AND a.APEQM_R_id=r.APEQM_R_id AND a.ALD_R_id=r.ALD_R_id AND a.RETU_R_id=r.RETU_R_id);
--
DROP TABLE IF EXISTS RET_LTE;
CREATE TABLE RET_LTE AS
SELECT
l.LNCELname,r.LNBTSname,l.Cluster, l.Region, l.Zona, l.Depto, l.Mun, l.Prefijo, l.PLMN_id, l.MRBTS_id, l.LNBTS_id, l.LNCEL_id, l.lcrId, l.earfcnDL,
l.moVersionr,l.distNamer ,l.EQM_R_id,l.APEQM_R_id,l.RMOD_R_id,l.OPTITEM_id,l.Value,
l.chassisProductCode,l.chassisSerialNumber,l.configDN,l.hwVersion,l.nrOfTXElements,l.operationalState,l.proceduralStatus,l.productCode,
l.productName,l.radioMasterDN,l.radioModuleHwReleaseCode,l.serialNumber,
r.ALD_R_id, r.RETU_R_id, r.hwVersion,
r.operationalState AS operationalStatea , r.productCode AS productCodea, r.releaseId3Gpp, r.retDeviceType, r.serialNumber AS serialNumber, r.swVersion,
r.vendorCode, r.moVersion, r.distName, r.configDN, r.RETU_R_id,
l.tilt_e_dump, r.angle, CASE WHEN (r.angle IS NULL OR l.tilt_e_dump IS NULL) THEN 0 ELSE
(CASE WHEN (r.angle = l.tilt_e_dump) THEN 0 ELSE 1 END)END AS TiltDisc,
CASE WHEN (r.angle IS NULL OR l.tilt_e_dump IS NULL) THEN 0 ELSE (r.angle - l.tilt_e_dump) END AS TEret_TEDump,
r.maxAngle, r.mechanicalAngle, r.minAngle,r.operationalState, r.subunitNumber,
r.antBearing, r.antModel,r.antSerial,r.baseStationID,r.sectorID,r.Versionr ,r.distNamer ,r.configDNr, r.OPTITEM_id, r.Value,
r.rmod_dn
FROM RMOD_LTE l LEFT JOIN ANTL_info r ON (l.distNamer=r.rmod_dn)
ORDER BY l.LNCELname IS NULL OR l.LNCELname='', l.LNCELname;
--
--
--
--
-- tilt audit LTE UMTS
DROP TABLE IF EXISTS LTE_tiltAud;
CREATE TABLE LTE_tiltAud AS
SELECT
l.Cluster, l.Region, l.Zona, l.Depto, l.Mun, l.Prefijo, l.LNCELname, l.lcrId, l.PLMN_id, l.earfcnDL, l.MRBTS_id, l.LNBTS_id, l.LNCEL_id,
l.moversion, l.moversionl, l.dlMimoMode, l.tilt AS tilt_e_dump, l.Tilt_E AS tilt_e_bl, CASE WHEN (l.tilt IS NULL OR l.Tilt_E IS NULL) THEN 0 ELSE
(CASE WHEN (l.tilt = l.Tilt_E) THEN 0 ELSE 1 END)END AS TiltDisc,
CASE WHEN (l.tilt IS NULL OR l.Tilt_E IS NULL) THEN 0 ELSE (l.Tilt_E - l.tilt) END AS TEBL_TEDump
FROM LTE_Param l
ORDER BY l.LNCELname IS NULL OR l.LNCELname='', l.LNCELname;
--
DROP TABLE IF EXISTS UMTS_tiltAud;
CREATE TABLE UMTS_tiltAud AS
SELECT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.Prefijo, W.uarfcn, W.PLMN_id, W.RNCName, W.RNC_id, W.WBTS_id, W.CId, W.version,
W.tilt AS tilt_e_dump, W.Tilt_E AS tilt_e_bl, CASE WHEN (W.tilt IS NULL OR W.Tilt_E IS NULL) THEN 0 ELSE
(CASE WHEN (W.tilt = W.Tilt_E) THEN 0 ELSE 1 END)END AS TiltDisc,
CASE WHEN (W.tilt IS NULL OR W.Tilt_E IS NULL) THEN 0 ELSE (W.Tilt_E - W.tilt) END AS TEBL_TEDump
FROM WCEL_PARAM1 W
ORDER BY W.WCELName IS NULL OR W.WCELName='', W.WCELName;
--
--
--
--
-- ADJW info
DROP TABLE IF EXISTS adjwcustom;
CREATE TABLE adjwcustom AS
SELECT
b.BTSname, w.WCELName, b.Cluster, b.Region, b.Depto, b.Mun, b.Prefijo, a.PLMN_id, a.BSC_id, a.BCF_id, a.BTS_id, a.ADJW_id,
w.Banda, w.Sector, w.WBTSName, w.RNCName, w.RNC_id, w.WBTS_id, w.WCEL_id, w.SectorID, w.CellDN, a.name, a.targetCellDN,
b.sector, b.BSCname, b.BCFname,b.BCF_AdSt, b.BTS_AdSt, b.BandName,b.DistName,
b.gsmPriority, b.utranQualRxLevelMargin, b.utranThresholdReselection, b.timeHysteresis, b.qSearchI, b.qSearchP, b.fddQOffset,
b.fddQMin, b.rxLevAccessMin, b.radioLinkTimeout, b.radioLinkTimeoutAmr, b.msMaxDistInCallSetup,
b.sector_ID, a.moVersion, a.distName, a.AdjwCId, a.intSystemDaEcioThr, a.lac, a.mcc,
a.minEcnoThreshold, a.mnc, a.reportingPriority, a.rncId, a.sac, a.scramblingCode, a.txDiversityInd, a.uarfcn
FROM (ADJW a LEFT JOIN WCEL_PARAM1 w ON (a.TargetCellDN = w.CellDN))
LEFT JOIN BTS_PARAM b ON (a.BSC_Id = b.BSC_Id) AND (a.BCF_Id = b.BCF_Id) AND (a.BTS_Id = b.BTS_Id)
ORDER BY b.BTSname IS NULL OR b.BTSname='', b.BTSname;
--
--
--
-- ADJG info
DROP TABLE IF EXISTS adjgcustom;
CREATE TABLE adjgcustom AS
SELECT
w.WCELName, b.BTSname, w.Cluster, w.Region, w.Depto, w.Mun, w.Prefijo, w.Banda, w.Sector, w.WBTSName, w.RNCName, w.SectorID, w.UARFCN,
i.moVersion, i.distName, i.PLMN_id, i.RNC_id, i.WBTS_id, i.WCEL_id, i.ADJG_id, i.AdjgMCC, i.AdjgMNC, i.TargetCellDN, i.name, i.ADJGChangeOrigin,
i.AdjgBCC, i.AdjgBCCH, i.AdjgBandIndicator, i.AdjgCI, i.AdjgLAC, i.AdjgNCC, i.AdjgSIB, i.AdjgTxPwrMaxRACH, i.AdjgTxPwrMaxTCH,
i.NrtHopgIdentifier, i.RtHopgIdentifier,
b.bsc_Id, b.bcf_Id, b.bts_Id, b.sector, b.BSCname, b.BCFname,b.BCF_AdSt, b.BTS_AdSt, b.BandName,b.DistName,
b.gsmPriority, b.utranQualRxLevelMargin, b.utranThresholdReselection, b.timeHysteresis, b.qSearchI, b.qSearchP, b.fddQOffset,
b.fddQMin, b.rxLevAccessMin, b.radioLinkTimeout, b.radioLinkTimeoutAmr, b.msMaxDistInCallSetup,
b.sector_ID
FROM (ADJG i LEFT JOIN WCEL_PARAM1 w ON (i.RNC_id = w.RNC_id AND i.WBTS_id = w.WBTS_id AND i.WCEL_id = w.WCEL_id))
LEFT JOIN BTS_PARAM b ON (i.AdjgCI = b.CellId) AND (i.AdjgLAC = b.locationAreaIdLAC)
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
DROP TABLE IF EXISTS adjlct;
CREATE TABLE adjlct AS
SELECT
w.RNC_id, w.WBTS_id, w.WCEL_id, COUNT(a.ADJL_id) AS adjlcount
FROM WCEL w LEFT JOIN ADJL a ON (w.RNC_id = a.RNC_id AND w.WCEL_id = a.WCEL_id)
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
--
--
--
--IRFIM custom
--
DROP TABLE IF EXISTS IRFIM_ref;
CREATE TABLE IRFIM_ref AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
IRFIM.IRFIM_id,IRFIM.moVersion,IRFIM.dlCarFrqEut,IRFIM.enableA4IMLB,IRFIM.eutCelResPrio,IRFIM.idleLBEutCelResPrio,IRFIM.idleLBEutCelResWeight,IRFIM.incMonExSel,IRFIM.interFrqThrH,IRFIM.interFrqThrL,IRFIM.interPresAntP,IRFIM.interTResEut,IRFIM.mbmsNeighCellConfigInterF,IRFIM.measBdw,IRFIM.minDeltaRsrpIMLB,IRFIM.minDeltaRsrqIMLB,IRFIM.minRsrpIMLB,IRFIM.minRsrqIMLB,IRFIM.qOffFrq,IRFIM.qRxLevMinInterF,IRFIM.reducedMeasPerformance,IRFIM.SBTS_id
FROM IRFIM LEFT JOIN LNCEL_Full AS L ON (IRFIM.PLMN_Id=L.PLMN_Id) AND (IRFIM.MRBTS_Id=L.MRBTS_Id) AND (IRFIM.LNBTS_Id=L.LNBTS_Id) AND (IRFIM.LNCEL_id=L.LNCEL_id);
--
--
--LNHOIF custom
DROP TABLE IF EXISTS LNHOIF_ref;
CREATE TABLE LNHOIF_ref AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, H.eutraCarrierInfo,
CASE WHEN H.eutraCarrierInfo BETWEEN 2750 and 3449 THEN 2600 ELSE (CASE WHEN H.eutraCarrierInfo BETWEEN 600 and 1199 THEN 1900
ELSE (CASE WHEN H.eutraCarrierInfo BETWEEN 9210 and 9659 THEN 700 ELSE (CASE WHEN H.eutraCarrierInfo BETWEEN 2400 and 2649 THEN 850
ELSE NULL END)END)END)END AS BandaT,
H.PLMN_id, H.MRBTS_id, H.LNBTS_id, H.LNCEL_id, H.LNHOIF_id, H.moVersion,H.a3OffsetRsrpInterFreq,H.a3OffsetRsrpInterFreqQci1,
H.a3TimeToTriggerRsrpInterFreq,H.a5ReportIntervalInterFreq,H.a5TimeToTriggerInterFreq,H.a3ReportIntervalRsrpInterFreq,
H.hysA3OffsetRsrpInterFreq,H.hysThreshold3InterFreq,H.iFGroupPrio,H.interPresAntP,H.measQuantInterFreq,H.measurementBandwidth,
H.offsetFreqInter,H.threshold3InterFreq,H.threshold3InterFreqQci1,H.threshold3aInterFreq,H.threshold3aInterFreqQci1,
H.thresholdRsrpIFLBFilter,H.thresholdRsrpIFSBFilter,H.thresholdRsrqIFLBFilter,H.thresholdRsrqIFSBFilter,H.a3OffsetRsrqInterFreq,
H.a3ReportIntervalRsrqInterFreq,H.a3TimeToTriggerRsrqInterFreq,H.hysA3OffsetRsrqInterFreq,H.a3ReportAmountRsrpInterFreq,
H.a3ReportAmountRsrqInterFreq,H.a5ReportAmountRsrpInterFreq,H.a5ReportAmountRsrqInterFreq,H.SBTS_id,H.t312,H.a3OffsetRsrpInterFreqHpue,
H.reducedMeasPerf,H.threshold3InterFreqHpue,H.threshold3aInterFreqHpue,H.useT312,H.thresholdRsrpEndcFilt
FROM LNHOIF AS H LEFT JOIN LNCEL_Full AS L ON (H.PLMN_Id=L.PLMN_Id) AND (H.MRBTS_Id=L.MRBTS_Id) AND (H.LNBTS_Id=L.LNBTS_Id)
AND (H.LNCEL_id=L.LNCEL_id);
--
--
-- IRFIM AUDIT WITHOUT ID
--
--Q1 to 626
DROP TABLE IF EXISTS IRFIM_626AUD;
CREATE TABLE IRFIM_626AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 5 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 4 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 1 AS measBdw_N, -112 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -118 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 5 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 4 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 1 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -112 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -118 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.dlCarFrqEut=626 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>5 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>4 OR L.interPresAntP<>1 OR L.measBdw<>1 OR L.minRsrpIMLB<>-112 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-118);
--
--
--Q2 to 651
DROP TABLE IF EXISTS IRFIM_651AUD;
CREATE TABLE IRFIM_651AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 6 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 8 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 2 AS measBdw_N, -114 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -120 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 6 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 8 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 2 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -114 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -120 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.dlCarFrqEut=651 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>6 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>8 OR L.interPresAntP<>1 OR L.measBdw<>2 OR L.minRsrpIMLB<>-114 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-120);
--
--
--Q3 to 9560
DROP TABLE IF EXISTS IRFIM_9560AUD;
CREATE TABLE IRFIM_9560AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 6 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 10 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 3 AS measBdw_N, -114 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -120 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 6 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 10 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 3 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -114 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -120 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.dlCarFrqEut=9560 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>6 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>10 OR L.interPresAntP<>1 OR L.measBdw<>3 OR L.minRsrpIMLB<>-114 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-120);
--
--
--Q4 3225 to 3075
DROP TABLE IF EXISTS IRFIM32253075AUD;
CREATE TABLE IRFIM32253075AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 7 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 30 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 4 AS measBdw_N, -116 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -122 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 7 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 4 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -116 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -122 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.earfcnDL=3225 AND L.dlCarFrqEut=3075 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>7 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>30 OR L.interPresAntP<>1 OR L.measBdw<>4 OR L.minRsrpIMLB<>-116 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-122);
--
--
--Q5 3075 to 3225
DROP TABLE IF EXISTS IRFIM30753225AUD;
CREATE TABLE IRFIM30753225AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 7 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 30 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 4 AS measBdw_N, -116 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -122 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 7 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 4 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -116 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -122 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE L.earfcnDL=3075 AND L.dlCarFrqEut=3225 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>7 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>30 OR L.interPresAntP<>1 OR L.measBdw<>4 OR L.minRsrpIMLB<>-116 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-122);
--
--
--Q6 to 3075
DROP TABLE IF EXISTS IRFIM_3075AUD;
CREATE TABLE IRFIM_3075AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 7 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 15 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 4 AS measBdw_N, -116 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -122 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 7 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 15 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 4 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -116 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -122 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE (L.earfcnDL=626 OR L.earfcnDL=651 OR L.earfcnDL=9560) AND L.dlCarFrqEut=3075 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>7 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>15 OR L.interPresAntP<>1 OR L.measBdw<>4 OR L.minRsrpIMLB<>-116 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-122);
--
--
--Q7 to 3225
DROP TABLE IF EXISTS IRFIM_3225AUD;
CREATE TABLE IRFIM_3225AUD AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.IRFIM_id, L.dlCarFrqEut, L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, 1 AS enableA4IMLB_N, 7 AS eutCelResPrio_N, 30 AS idleLBEutCelResPrio_N, 15 AS idleLBEutCelResWeight_N, 1 AS interPresAntP_N, 4 AS measBdw_N, -116 AS minRsrpIMLB_N, -140 AS minRsrqIMLB_N, -122 AS qRxLevMinInterF_N
,CASE WHEN L.enableA4IMLB <> 1 THEN 1 ELSE 0 END AS enableA4IMLB_D,CASE WHEN L.eutCelResPrio <> 7 THEN 1 ELSE 0 END AS eutCelResPrio_D,CASE WHEN L.idleLBEutCelResPrio <> 30 THEN 1 ELSE 0 END AS idleLBEutCelResPrio_D,CASE WHEN L.idleLBEutCelResWeight <> 15 THEN 1 ELSE 0 END AS idleLBEutCelResWeight_D,CASE WHEN L.interPresAntP <> 1 THEN 1 ELSE 0 END AS interPresAntP_D,CASE WHEN L.measBdw <> 4 THEN 1 ELSE 0 END AS measBdw_D,CASE WHEN L.minRsrpIMLB <> -116 THEN 1 ELSE 0 END AS minRsrpIMLB_D,CASE WHEN L.minRsrqIMLB <> -140 THEN 1 ELSE 0 END AS minRsrqIMLB_D,CASE WHEN L.qRxLevMinInterF <> -122 THEN 1 ELSE 0 END AS qRxLevMinInterF_D
FROM IRFIM_ref AS L WHERE (L.earfcnDL=626 OR L.earfcnDL=651 OR L.earfcnDL=9560) AND L.dlCarFrqEut=3225 AND (L.enableA4IMLB<>1 OR L.eutCelResPrio<>7 OR L.idleLBEutCelResPrio<>30 OR L.idleLBEutCelResWeight<>15 OR L.interPresAntP<>1  OR L.measBdw<>4 OR L.minRsrpIMLB<>-116 OR L.minRsrqIMLB<>-140 OR L.qRxLevMinInterF<>-122);
--
--
--
--
--
--AMLEPR custom
DROP TABLE IF EXISTS AMLEPR_ref;
CREATE TABLE AMLEPR_ref AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
CASE WHEN AMLEPR.targetCarrierFreq BETWEEN 2750 and 3449 THEN 2600 ELSE (CASE WHEN AMLEPR.targetCarrierFreq BETWEEN 600 and 1199 THEN 1900 ELSE (CASE WHEN AMLEPR.targetCarrierFreq BETWEEN 9210 and 9659 THEN 700 ELSE (CASE WHEN AMLEPR.targetCarrierFreq BETWEEN 2400 and 2649 THEN 850 ELSE NULL END)END)END)END AS BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname,
AMLEPR.PLMN_id,AMLEPR.MRBTS_id,AMLEPR.LNBTS_id,AMLEPR.LNCEL_id,AMLEPR.AMLEPR_id,AMLEPR.moVersion,AMLEPR.cacHeadroom,AMLEPR.deltaCac,AMLEPR.maxCacThreshold,AMLEPR.targetCarrierFreq,AMLEPR.SBTS_id
FROM AMLEPR LEFT JOIN LNCEL_Full AS L ON (AMLEPR.PLMN_Id=L.PLMN_Id) AND (AMLEPR.MRBTS_Id=L.MRBTS_Id) AND (AMLEPR.LNBTS_Id=L.LNBTS_Id) AND (AMLEPR.LNCEL_id=L.LNCEL_id);
--
--
-- AMLEPR AUDIT WITHOUT ID
--
DROP TABLE IF EXISTS AMLEPR_3075_3225;
CREATE TABLE AMLEPR_3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 30 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 30 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3075 AND L.targetCarrierFreq=3225 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>30);
--
--
DROP TABLE IF EXISTS AMLEPR_3075_651;
CREATE TABLE AMLEPR_3075_651 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 30 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 30 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3075 AND L.targetCarrierFreq=651 AND (L.cacHeadroom<>0 OR L.deltaCac<>30 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3075_626;
CREATE TABLE AMLEPR_3075_626 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 45 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 45 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3075 AND L.targetCarrierFreq=626 AND (L.cacHeadroom<>0 OR L.deltaCac<>45 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3075_9560;
CREATE TABLE AMLEPR_3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 30 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 30 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3075 AND L.targetCarrierFreq=9560 AND (L.cacHeadroom<>0 OR L.deltaCac<>30 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3225_3075;
CREATE TABLE AMLEPR_3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 30 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 30 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3225 AND L.targetCarrierFreq=3075 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>30);
--
--
DROP TABLE IF EXISTS AMLEPR_3225_651;
CREATE TABLE AMLEPR_3225_651 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 30 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 30 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3225 AND L.targetCarrierFreq=651 AND (L.cacHeadroom<>0 OR L.deltaCac<>30 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3225_626;
CREATE TABLE AMLEPR_3225_626 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 45 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 45 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3225 AND L.targetCarrierFreq=626 AND (L.cacHeadroom<>0 OR L.deltaCac<>45 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_3225_9560;
CREATE TABLE AMLEPR_3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 30 AS deltaCac_N, 7 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 30 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 7 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=3225 AND L.targetCarrierFreq=9560 AND (L.cacHeadroom<>0 OR L.deltaCac<>30 OR L.maxCacThreshold<>7);
--
--
DROP TABLE IF EXISTS AMLEPR_651_3075;
CREATE TABLE AMLEPR_651_3075 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 20 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 20 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=651 AND L.targetCarrierFreq=3075 AND (L.cacHeadroom<>0 OR L.deltaCac<>20 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_651_3225;
CREATE TABLE AMLEPR_651_3225 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 20 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 20 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=651 AND L.targetCarrierFreq=3225 AND (L.cacHeadroom<>0 OR L.deltaCac<>20 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_651_626;
CREATE TABLE AMLEPR_651_626 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 60 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=651 AND L.targetCarrierFreq=626 AND (L.cacHeadroom <> 0 OR L.deltaCac <> 15 OR L.maxCacThreshold <> 50);
--
--
DROP TABLE IF EXISTS AMLEPR_651_9560;
CREATE TABLE AMLEPR_651_9560 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=651 AND L.targetCarrierFreq=9560 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_626_3075;
CREATE TABLE AMLEPR_626_3075 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 65 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 65 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=626 AND L.targetCarrierFreq=3075 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>65);
--
--
DROP TABLE IF EXISTS AMLEPR_626_3225;
CREATE TABLE AMLEPR_626_3225 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 65 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 65 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=626 AND L.targetCarrierFreq=3225 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>65);
--
--
DROP TABLE IF EXISTS AMLEPR_626_651;
CREATE TABLE AMLEPR_626_651 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 65 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 65 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=626 AND L.targetCarrierFreq=651 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>65);
--
--
DROP TABLE IF EXISTS AMLEPR_626_9560;
CREATE TABLE AMLEPR_626_9560 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 65 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 65 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=626 AND L.targetCarrierFreq=9560 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>65);
--
--
DROP TABLE IF EXISTS AMLEPR_9560_3075;
CREATE TABLE AMLEPR_9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 20 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 20 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=9560 AND L.targetCarrierFreq=3075 AND (L.cacHeadroom<>0 OR L.deltaCac<>20 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_9560_3225;
CREATE TABLE AMLEPR_9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 20 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 20 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=9560 AND L.targetCarrierFreq=3225 AND (L.cacHeadroom<>0 OR L.deltaCac<>20 OR L.maxCacThreshold<>50);
--
--
DROP TABLE IF EXISTS AMLEPR_9560_651;
CREATE TABLE AMLEPR_9560_651 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 60 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=9560 AND L.targetCarrierFreq=651 AND (L.cacHeadroom <> 0 OR L.deltaCac <> 15 OR L.maxCacThreshold <> 50);
--
--
DROP TABLE IF EXISTS AMLEPR_9560_626;
CREATE TABLE AMLEPR_9560_626 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,
L.BandaT, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNBTSname, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id, L.cacHeadroom, L.deltaCac, L.maxCacThreshold, L.targetCarrierFreq, 0 AS cacHeadroom_N, 15 AS deltaCac_N, 50 AS maxCacThreshold_N,CASE WHEN L.cacHeadroom <> 0 THEN 1 ELSE 0 END AS cacHeadroom_D,CASE WHEN L.deltaCac <> 15 THEN 1 ELSE 0 END AS deltaCac_D,CASE WHEN L.maxCacThreshold <> 50 THEN 1 ELSE 0 END AS maxCacThreshold_D
FROM AMLEPR_ref AS L
WHERE L.earfcnDL=9560 AND L.targetCarrierFreq=626 AND (L.cacHeadroom<>0 OR L.deltaCac<>15 OR L.maxCacThreshold<>50);
--
--
--
--
-- LNCEL IRFIM combinations FROM 626 TO 3075
DROP TABLE IF EXISTS LNCEL_IRFIM626_3075;
CREATE TABLE LNCEL_IRFIM626_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3075 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,1 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL IRFIM combinations FROM 626 TO 3225
DROP TABLE IF EXISTS LNCEL_IRFIM626_3225;
CREATE TABLE LNCEL_IRFIM626_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3225 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,2 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL IRFIM combinations FROM 626 TO 9560
DROP TABLE IF EXISTS LNCEL_IRFIM626_9560;
CREATE TABLE LNCEL_IRFIM626_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 9560 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,10 AS idleLBEutCelResWeight,1 AS interPresAntP,5 AS IRFIM_id,3 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL IRFIM combinations FROM 651 TO 3075
DROP TABLE IF EXISTS LNCEL_IRFIM651_3075;
CREATE TABLE LNCEL_IRFIM651_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3075 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,1 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL IRFIM combinations FROM 651 TO 3225
DROP TABLE IF EXISTS LNCEL_IRFIM651_3225;
CREATE TABLE LNCEL_IRFIM651_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3225 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,2 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL IRFIM combinations FROM 651 TO 9560
DROP TABLE IF EXISTS LNCEL_IRFIM651_9560;
CREATE TABLE LNCEL_IRFIM651_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 9560 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,10 AS idleLBEutCelResWeight,1 AS interPresAntP,5 AS IRFIM_id,3 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL IRFIM combinations FROM 3075 TO 651
DROP TABLE IF EXISTS LNCEL_IRFIM3075_651;
CREATE TABLE LNCEL_IRFIM3075_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 651 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,8 AS idleLBEutCelResWeight,1 AS interPresAntP,4 AS IRFIM_id,2 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL IRFIM combinations FROM 3075 TO 626
DROP TABLE IF EXISTS LNCEL_IRFIM3075_626;
CREATE TABLE LNCEL_IRFIM3075_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 626 AS dlCarFrqEut,1 AS enableA4IMLB,5 AS eutCelResPrio,30 AS idleLBEutCelResPrio,4 AS idleLBEutCelResWeight,1 AS interPresAntP,3 AS IRFIM_id,1 AS measBdw,-112 AS minRsrpIMLB,-140 AS minRsrqIMLB,-118 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL IRFIM combinations FROM 3075 TO 3225
DROP TABLE IF EXISTS LNCEL_IRFIM3075_3225;
CREATE TABLE LNCEL_IRFIM3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3225 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,30 AS idleLBEutCelResWeight,1 AS interPresAntP,2 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL IRFIM combinations FROM 3075 TO 9560
DROP TABLE IF EXISTS LNCEL_IRFIM3075_9560;
CREATE TABLE LNCEL_IRFIM3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 9560 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,10 AS idleLBEutCelResWeight,1 AS interPresAntP,5 AS IRFIM_id,3 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL IRFIM combinations FROM 3225 TO 651
DROP TABLE IF EXISTS LNCEL_IRFIM3225_651;
CREATE TABLE LNCEL_IRFIM3225_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 651 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,8 AS idleLBEutCelResWeight,1 AS interPresAntP,4 AS IRFIM_id,2 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL IRFIM combinations FROM 3225 TO 626
DROP TABLE IF EXISTS LNCEL_IRFIM3225_626;
CREATE TABLE LNCEL_IRFIM3225_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 626 AS dlCarFrqEut,1 AS enableA4IMLB,5 AS eutCelResPrio,30 AS idleLBEutCelResPrio,4 AS idleLBEutCelResWeight,1 AS interPresAntP,3 AS IRFIM_id,1 AS measBdw,-112 AS minRsrpIMLB,-140 AS minRsrqIMLB,-118 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL IRFIM combinations FROM 3225 TO 3075
DROP TABLE IF EXISTS LNCEL_IRFIM3225_3075;
CREATE TABLE LNCEL_IRFIM3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3075 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,30 AS idleLBEutCelResWeight,1 AS interPresAntP,1 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL IRFIM combinations FROM 3225 TO 9560
DROP TABLE IF EXISTS LNCEL_IRFIM3225_9560;
CREATE TABLE LNCEL_IRFIM3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 9560 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,10 AS idleLBEutCelResWeight,1 AS interPresAntP,5 AS IRFIM_id,3 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL IRFIM combinations FROM 9560 TO 651
DROP TABLE IF EXISTS LNCEL_IRFIM9560_651;
CREATE TABLE LNCEL_IRFIM9560_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 651 AS dlCarFrqEut,1 AS enableA4IMLB,6 AS eutCelResPrio,30 AS idleLBEutCelResPrio,8 AS idleLBEutCelResWeight,1 AS interPresAntP,4 AS IRFIM_id,2 AS measBdw,-114 AS minRsrpIMLB,-140 AS minRsrqIMLB,-120 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL IRFIM combinations FROM 9560 TO 626
DROP TABLE IF EXISTS LNCEL_IRFIM9560_626;
CREATE TABLE LNCEL_IRFIM9560_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 626 AS dlCarFrqEut,1 AS enableA4IMLB,5 AS eutCelResPrio,30 AS idleLBEutCelResPrio,4 AS idleLBEutCelResWeight,1 AS interPresAntP,3 AS IRFIM_id,1 AS measBdw,-112 AS minRsrpIMLB,-140 AS minRsrqIMLB,-118 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL IRFIM combinations FROM 9560 TO 3075
DROP TABLE IF EXISTS LNCEL_IRFIM9560_3075;
CREATE TABLE LNCEL_IRFIM9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3075 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,1 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL IRFIM combinations FROM 9560 TO 3225
DROP TABLE IF EXISTS LNCEL_IRFIM9560_3225;
CREATE TABLE LNCEL_IRFIM9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3225 AS dlCarFrqEut,1 AS enableA4IMLB,7 AS eutCelResPrio,30 AS idleLBEutCelResPrio,15 AS idleLBEutCelResWeight,1 AS interPresAntP,2 AS IRFIM_id,4 AS measBdw,-116 AS minRsrpIMLB,-140 AS minRsrqIMLB,-122 AS qRxLevMinInterF
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
--
DROP TABLE IF EXISTS LNCEL_IRFIM_FULL;
CREATE TABLE LNCEL_IRFIM_FULL AS
SELECT * FROM LNCEL_IRFIM626_3075
UNION ALL
SELECT * FROM LNCEL_IRFIM626_3225
UNION ALL
SELECT * FROM LNCEL_IRFIM626_9560
UNION ALL
SELECT * FROM LNCEL_IRFIM651_3075
UNION ALL
SELECT * FROM LNCEL_IRFIM651_3225
UNION ALL
SELECT * FROM LNCEL_IRFIM651_9560
UNION ALL
SELECT * FROM LNCEL_IRFIM3075_651
UNION ALL
SELECT * FROM LNCEL_IRFIM3075_626
UNION ALL
SELECT * FROM LNCEL_IRFIM3075_3225
UNION ALL
SELECT * FROM LNCEL_IRFIM3075_9560
UNION ALL
SELECT * FROM LNCEL_IRFIM3225_651
UNION ALL
SELECT * FROM LNCEL_IRFIM3225_626
UNION ALL
SELECT * FROM LNCEL_IRFIM3225_3075
UNION ALL
SELECT * FROM LNCEL_IRFIM3225_9560
UNION ALL
SELECT * FROM LNCEL_IRFIM9560_651
UNION ALL
SELECT * FROM LNCEL_IRFIM9560_626
UNION ALL
SELECT * FROM LNCEL_IRFIM9560_3075
UNION ALL
SELECT * FROM LNCEL_IRFIM9560_3225
ORDER BY
    Region DESC, LNCELname;
--
--
--
DROP TABLE IF EXISTS IRFIM_Miss;
CREATE TABLE IRFIM_Miss AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,L.dlCarFrqEut,L.enableA4IMLB, L.eutCelResPrio, L.idleLBEutCelResPrio, L.idleLBEutCelResWeight, L.interPresAntP, L.IRFIM_id, L.measBdw, L.minRsrpIMLB, L.minRsrqIMLB, L.qRxLevMinInterF, I.dlCarFrqEut AS dlCarFrqEutMiss
FROM LNCEL_IRFIM_Full AS L LEFT JOIN IRFIM_ref AS I ON ((L.PLMN_id = I.PLMN_id) AND (L.MRBTS_id = I.MRBTS_id) AND (L.LNBTS_id = I.LNBTS_id) AND (L.LNCEL_id = I.LNCEL_id) AND (L.dlCarFrqEut = I.dlCarFrqEut))
WHERE I.dlCarFrqEut IS NULL
ORDER BY L.Region DESC, L.LNCELname;
--
--
--
--
--
-- LNCEL LNHOIF combinations FROM 9560 TO 626
DROP TABLE IF EXISTS LNCEL_LNHOIF9560_626;
CREATE TABLE LNCEL_LNHOIF9560_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
626 AS eutraCarrierInfo,1 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,30 AS threshold3aInterFreqQci1,30 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-110 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =9560;
--
--
-- LNCEL LNHOIF combinations FROM 3225 TO 626
DROP TABLE IF EXISTS LNCEL_LNHOIF3225_626;
CREATE TABLE LNCEL_LNHOIF3225_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
626 AS eutraCarrierInfo,1 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,30 AS threshold3aInterFreqQci1,30 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-110 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3225;
--
--
-- LNCEL LNHOIF combinations FROM 3075 TO 626
DROP TABLE IF EXISTS LNCEL_LNHOIF3075_626;
CREATE TABLE LNCEL_LNHOIF3075_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
626 AS eutraCarrierInfo,1 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,30 AS threshold3aInterFreqQci1,30 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-110 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3075;
--
--
-- LNCEL LNHOIF combinations FROM 9560 TO 651
DROP TABLE IF EXISTS LNCEL_LNHOIF9560_651;
CREATE TABLE LNCEL_LNHOIF9560_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
651 AS eutraCarrierInfo,2 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-112 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =9560;
--
--
-- LNCEL LNHOIF combinations FROM 3225 TO 651
DROP TABLE IF EXISTS LNCEL_LNHOIF3225_651;
CREATE TABLE LNCEL_LNHOIF3225_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
651 AS eutraCarrierInfo,2 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-112 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3225;
--
--
-- LNCEL LNHOIF combinations FROM 3075 TO 651
DROP TABLE IF EXISTS LNCEL_LNHOIF3075_651;
CREATE TABLE LNCEL_LNHOIF3075_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
651 AS eutraCarrierInfo,2 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-112 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3075;
--
--
-- LNCEL LNHOIF combinations FROM 626 TO 9560
DROP TABLE IF EXISTS LNCEL_LNHOIF626_9560;
CREATE TABLE LNCEL_LNHOIF626_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
9560 AS eutraCarrierInfo,3 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,27 AS threshold3InterFreqQci1,-90 AS thresholdRsrpIFLBFilter,27 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =626;
--
--
-- LNCEL LNHOIF combinations FROM 651 TO 9560
DROP TABLE IF EXISTS LNCEL_LNHOIF651_9560;
CREATE TABLE LNCEL_LNHOIF651_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
9560 AS eutraCarrierInfo,3 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-90 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =651;
--
--
-- LNCEL LNHOIF combinations FROM 3075 TO 9560
DROP TABLE IF EXISTS LNCEL_LNHOIF3075_9560;
CREATE TABLE LNCEL_LNHOIF3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
9560 AS eutraCarrierInfo,3 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-90 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3075;
--
--
-- LNCEL LNHOIF combinations FROM 3225 TO 9560
DROP TABLE IF EXISTS LNCEL_LNHOIF3225_9560;
CREATE TABLE LNCEL_LNHOIF3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
9560 AS eutraCarrierInfo,3 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,28 AS threshold3aInterFreqQci1,28 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-90 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3225;
--
--
-- LNCEL LNHOIF combinations FROM 626 TO 3225
DROP TABLE IF EXISTS LNCEL_LNHOIF626_3225;
CREATE TABLE LNCEL_LNHOIF626_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3225 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,27 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,27 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =626;
--
--
-- LNCEL LNHOIF combinations FROM 651 TO 3225
DROP TABLE IF EXISTS LNCEL_LNHOIF651_3225;
CREATE TABLE LNCEL_LNHOIF651_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3225 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =651;
--
--
-- LNCEL LNHOIF combinations FROM 9560 TO 3225
DROP TABLE IF EXISTS LNCEL_LNHOIF9560_3225;
CREATE TABLE LNCEL_LNHOIF9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3225 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =9560;
--
--
-- LNCEL LNHOIF combinations FROM 3075 TO 3225
DROP TABLE IF EXISTS LNCEL_LNHOIF3075_3225;
CREATE TABLE LNCEL_LNHOIF3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3225 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3075;
--
--
-- LNCEL LNHOIF combinations FROM 626 TO 3075
DROP TABLE IF EXISTS LNCEL_LNHOIF626_3075;
CREATE TABLE LNCEL_LNHOIF626_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3075 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,27 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,27 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =626;
--
--
-- LNCEL LNHOIF combinations FROM 651 TO 3075
DROP TABLE IF EXISTS LNCEL_LNHOIF651_3075;
CREATE TABLE LNCEL_LNHOIF651_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3075 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =651;
--
--
-- LNCEL LNHOIF combinations FROM 9560 TO 3075
DROP TABLE IF EXISTS LNCEL_LNHOIF9560_3075;
CREATE TABLE LNCEL_LNHOIF9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3075 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =9560;
--
--
-- LNCEL LNHOIF combinations FROM 3225 TO 3075
DROP TABLE IF EXISTS LNCEL_LNHOIF3225_3075;
CREATE TABLE LNCEL_LNHOIF3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
3075 AS eutraCarrierInfo,4 AS measurementBandwidth,30 AS a3OffsetRsrpInterFreq,30 AS a3OffsetRsrpInterFreqQCI1,30 AS hysA3OffsetRsrpInterFreq,12 AS iFGroupPrio,-140 AS thresholdRsrqIFLBFilter,26 AS threshold3aInterFreqQci1,26 AS threshold3aInterFreq,23 AS threshold3InterFreqQci1,-114 AS thresholdRsrpIFLBFilter,23 AS threshold3InterFreq
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL =3225;
--
--
DROP TABLE IF EXISTS LNCEL_LNHOIF_FULL;
CREATE TABLE LNCEL_LNHOIF_FULL AS
SELECT * FROM LNCEL_LNHOIF626_3075
UNION ALL
SELECT * FROM LNCEL_LNHOIF626_3225
UNION ALL
SELECT * FROM LNCEL_LNHOIF626_9560
UNION ALL
SELECT * FROM LNCEL_LNHOIF651_3075
UNION ALL
SELECT * FROM LNCEL_LNHOIF651_3225
UNION ALL
SELECT * FROM LNCEL_LNHOIF651_9560
UNION ALL
SELECT * FROM LNCEL_LNHOIF3075_651
UNION ALL
SELECT * FROM LNCEL_LNHOIF3075_626
UNION ALL
SELECT * FROM LNCEL_LNHOIF3075_3225
UNION ALL
SELECT * FROM LNCEL_LNHOIF3075_9560
UNION ALL
SELECT * FROM LNCEL_LNHOIF3225_651
UNION ALL
SELECT * FROM LNCEL_LNHOIF3225_626
UNION ALL
SELECT * FROM LNCEL_LNHOIF3225_3075
UNION ALL
SELECT * FROM LNCEL_LNHOIF3225_9560
UNION ALL
SELECT * FROM LNCEL_LNHOIF9560_651
UNION ALL
SELECT * FROM LNCEL_LNHOIF9560_626
UNION ALL
SELECT * FROM LNCEL_LNHOIF9560_3075
UNION ALL
SELECT * FROM LNCEL_LNHOIF9560_3225
ORDER BY
    Region DESC, LNCELname;
--
--
DROP TABLE IF EXISTS LNHOIF_Miss;
CREATE TABLE LNHOIF_Miss AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL,L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id,
L.eutraCarrierInfo,L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq
FROM LNCEL_LNHOIF_Full AS L LEFT JOIN LNHOIF_ref AS I ON ((L.PLMN_id = I.PLMN_id) AND (L.MRBTS_id = I.MRBTS_id) AND (L.LNBTS_id = I.LNBTS_id) AND (L.LNCEL_id = I.LNCEL_id) AND (L.eutraCarrierInfo = I.eutraCarrierInfo))
WHERE I.eutraCarrierInfo IS NULL
ORDER BY L.Region DESC, L.LNCELname;
--
--
--
--
--
-- LNHOIF AUDIT WITHOUT ID
--
DROP TABLE IF EXISTS LNHOIF_651_626;
CREATE TABLE LNHOIF_651_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 1 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 30 AS threshold3aInterFreqQci1_N, 30 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -110 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>1 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>30 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>30 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-110 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=651 AND L.eutraCarrierInfo=626 AND (L.measurementBandwidth<>1 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>30 OR L.threshold3aInterFreq<>30 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-110 OR L.threshold3InterFreq<>23);
--
--
--
--
DROP TABLE IF EXISTS LNHOIF_9560_626;
CREATE TABLE LNHOIF_9560_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 1 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 30 AS threshold3aInterFreqQci1_N, 30 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -110 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>1 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>30 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>30 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-110 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=9560 AND L.eutraCarrierInfo=626 AND (L.measurementBandwidth<>1 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>30 OR L.threshold3aInterFreq<>30 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-110 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3075_626;
CREATE TABLE LNHOIF_3075_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 1 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 30 AS threshold3aInterFreqQci1_N, 30 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -110 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>1 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>30 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>30 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-110 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3075 AND L.eutraCarrierInfo=626 AND (L.measurementBandwidth<>1 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>30 OR L.threshold3aInterFreq<>30 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-110 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3225_626;
CREATE TABLE LNHOIF_3225_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 1 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 30 AS threshold3aInterFreqQci1_N, 30 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -110 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>1 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>30 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>30 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-110 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3225 AND L.eutraCarrierInfo=626 AND (L.measurementBandwidth<>1 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>30 OR L.threshold3aInterFreq<>30 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-110 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_626_651;
CREATE TABLE LNHOIF_626_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 2 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 27 AS threshold3InterFreqQci1_N, -112 AS thresholdRsrpIFLBFilter_N,  27 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>2 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>27 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-112 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>27 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=626 AND L.eutraCarrierInfo=651 AND (L.measurementBandwidth<>2 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>27 OR L.thresholdRsrpIFLBFilter<>-112 OR L.threshold3InterFreq<>27);
--
--
DROP TABLE IF EXISTS LNHOIF_9560_651;
CREATE TABLE LNHOIF_9560_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 2 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -112 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>2 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-112 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=9560 AND L.eutraCarrierInfo=651 AND (L.measurementBandwidth<>2 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-112 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3075_651;
CREATE TABLE LNHOIF_3075_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 2 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -112 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>2 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-112 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3075 AND L.eutraCarrierInfo=651 AND (L.measurementBandwidth<>2 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-112 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3225_651;
CREATE TABLE LNHOIF_3225_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 2 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -112 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>2 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-112 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3225 AND L.eutraCarrierInfo=651 AND (L.measurementBandwidth<>2 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-112 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_626_9560;
CREATE TABLE LNHOIF_626_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 3 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 27 AS threshold3InterFreqQci1_N, -90 AS thresholdRsrpIFLBFilter_N,  27 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>3 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>27 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-90 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>27 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=626 AND L.eutraCarrierInfo=9560 AND (L.measurementBandwidth<>3 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>27 OR L.thresholdRsrpIFLBFilter<>-90 OR L.threshold3InterFreq<>27);
--
--
DROP TABLE IF EXISTS LNHOIF_651_9560;
CREATE TABLE LNHOIF_651_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 3 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -90 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>3 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-90 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=651 AND L.eutraCarrierInfo=9560 AND (L.measurementBandwidth<>3 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-90 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3075_9560;
CREATE TABLE LNHOIF_3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 3 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -90 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>3 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-90 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3075 AND L.eutraCarrierInfo=9560 AND (L.measurementBandwidth<>3 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-90 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3225_9560;
CREATE TABLE LNHOIF_3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 3 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 28 AS threshold3aInterFreqQci1_N, 28 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -90 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>3 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>28 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>28 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-90 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3225 AND L.eutraCarrierInfo=9560 AND (L.measurementBandwidth<>3 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>28 OR L.threshold3aInterFreq<>28 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-90 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_626_3075;
CREATE TABLE LNHOIF_626_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 27 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  27 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>27 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>27 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=626 AND L.eutraCarrierInfo=3075 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>27 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>27);
--
--
DROP TABLE IF EXISTS LNHOIF_651_3075;
CREATE TABLE LNHOIF_651_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=651 AND L.eutraCarrierInfo=3075 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_9560_3075;
CREATE TABLE LNHOIF_9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=9560 AND L.eutraCarrierInfo=3075 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3225_3075;
CREATE TABLE LNHOIF_3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3225 AND L.eutraCarrierInfo=3075 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_626_3225;
CREATE TABLE LNHOIF_626_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 27 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  27 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>27 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>27 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=626 AND L.eutraCarrierInfo=3225 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>27 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>27);
--
--
DROP TABLE IF EXISTS LNHOIF_651_3225;
CREATE TABLE LNHOIF_651_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=651 AND L.eutraCarrierInfo=3225 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_9560_3225;
CREATE TABLE LNHOIF_9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=9560 AND L.eutraCarrierInfo=3225 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
DROP TABLE IF EXISTS LNHOIF_3075_3225;
CREATE TABLE LNHOIF_3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.Prefijo, L.Sector, L.Banda, L.earfcnDL, L.eutraCarrierInfo, L.BandaT,
L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.LNHOIF_id, L.measurementBandwidth,L.a3OffsetRsrpInterFreq,L.a3OffsetRsrpInterFreqQCI1,L.hysA3OffsetRsrpInterFreq,L.iFGroupPrio,L.thresholdRsrqIFLBFilter,L.threshold3aInterFreqQci1,L.threshold3aInterFreq,L.threshold3InterFreqQci1,L.thresholdRsrpIFLBFilter,L.threshold3InterFreq,
 4 AS measurementBandwidth_N, 30 AS a3OffsetRsrpInterFreq_N, 30 AS a3OffsetRsrpInterFreqQCI1_N, 30 AS hysA3OffsetRsrpInterFreq_N, 12 AS iFGroupPrio_N, -140 AS thresholdRsrqIFLBFilter_N, 26 AS threshold3aInterFreqQci1_N, 26 AS threshold3aInterFreq_N, 23 AS threshold3InterFreqQci1_N, -114 AS thresholdRsrpIFLBFilter_N,  23 AS threshold3InterFreq_N, CASE WHEN L.measurementBandwidth<>4 THEN 1 ELSE 0 END AS measurementBandwidth_D,CASE WHEN L.a3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreq_D,CASE WHEN L.a3OffsetRsrpInterFreqQCI1<>30 THEN 1 ELSE 0 END AS a3OffsetRsrpInterFreqQCI1_D,CASE WHEN L.hysA3OffsetRsrpInterFreq<>30 THEN 1 ELSE 0 END AS hysA3OffsetRsrpInterFreq_D,CASE WHEN L.iFGroupPrio<>12 THEN 1 ELSE 0 END AS iFGroupPrio_D,CASE WHEN L.thresholdRsrqIFLBFilter<>-140 THEN 1 ELSE 0 END AS thresholdRsrqIFLBFilter_D,CASE WHEN L.threshold3aInterFreqQci1<>26 THEN 1 ELSE 0 END AS threshold3aInterFreqQci1_D,CASE WHEN L.threshold3aInterFreq<>26 THEN 1 ELSE 0 END AS threshold3aInterFreq_D,CASE WHEN L.threshold3InterFreqQci1<>23 THEN 1 ELSE 0 END AS threshold3InterFreqQci1_D,CASE WHEN L.thresholdRsrpIFLBFilter<>-114 THEN 1 ELSE 0 END AS thresholdRsrpIFLBFilter_D,CASE WHEN L.threshold3InterFreq<>23 THEN 1 ELSE 0 END AS threshold3InterFreq_D
FROM LNHOIF_ref AS L
WHERE L.earfcnDL=3075 AND L.eutraCarrierInfo=3225 AND (L.measurementBandwidth<>4 OR L.a3OffsetRsrpInterFreq<>30 OR L.a3OffsetRsrpInterFreqQCI1<>30 OR L.hysA3OffsetRsrpInterFreq<>30 OR L.iFGroupPrio<>12 OR L.thresholdRsrqIFLBFilter<>-140 OR L.threshold3aInterFreqQci1<>26 OR L.threshold3aInterFreq<>26 OR L.threshold3InterFreqQci1<>23 OR L.thresholdRsrpIFLBFilter<>-114 OR L.threshold3InterFreq<>23);
--
--
--
--
-- LNCEL amlepr combinations FROM 626 TO 3075
DROP TABLE IF EXISTS LNCEL_AMLEPR626_3075;
CREATE TABLE LNCEL_AMLEPR626_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3075 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL amlepr combinations FROM 626 TO 3225
DROP TABLE IF EXISTS LNCEL_AMLEPR626_3225;
CREATE TABLE LNCEL_AMLEPR626_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 3225 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL amlepr combinations FROM 626 TO 9560
DROP TABLE IF EXISTS LNCEL_AMLEPR626_9560;
CREATE TABLE LNCEL_AMLEPR626_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 4 AS AMLEPR_id_New, 9560 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 626;
--
-- LNCEL amlepr combinations FROM 651 TO 3075
DROP TABLE IF EXISTS LNCEL_AMLEPR651_3075;
CREATE TABLE LNCEL_AMLEPR651_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3075 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL amlepr combinations FROM 651 TO 3225
DROP TABLE IF EXISTS LNCEL_AMLEPR651_3225;
CREATE TABLE LNCEL_AMLEPR651_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 3225 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL amlepr combinations FROM 651 TO 9560
DROP TABLE IF EXISTS LNCEL_AMLEPR651_9560;
CREATE TABLE LNCEL_AMLEPR651_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 4 AS AMLEPR_id_New, 9560 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 651;
--
-- LNCEL amlepr combinations FROM 3075 TO 651
DROP TABLE IF EXISTS LNCEL_AMLEPR3075_651;
CREATE TABLE LNCEL_AMLEPR3075_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 651 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL amlepr combinations FROM 3075 TO 626
DROP TABLE IF EXISTS LNCEL_AMLEPR3075_626;
CREATE TABLE LNCEL_AMLEPR3075_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 2 AS AMLEPR_id_New, 626 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL amlepr combinations FROM 3075 TO 3225
DROP TABLE IF EXISTS LNCEL_AMLEPR3075_3225;
CREATE TABLE LNCEL_AMLEPR3075_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3225 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL amlepr combinations FROM 3075 TO 9560
DROP TABLE IF EXISTS LNCEL_AMLEPR3075_9560;
CREATE TABLE LNCEL_AMLEPR3075_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 4 AS AMLEPR_id_New, 9560 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3075;
--
-- LNCEL amlepr combinations FROM 3225 TO 651
DROP TABLE IF EXISTS LNCEL_AMLEPR3225_651;
CREATE TABLE LNCEL_AMLEPR3225_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 651 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL amlepr combinations FROM 3225 TO 626
DROP TABLE IF EXISTS LNCEL_AMLEPR3225_626;
CREATE TABLE LNCEL_AMLEPR3225_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 2 AS AMLEPR_id_New, 626 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL amlepr combinations FROM 3225 TO 3075
DROP TABLE IF EXISTS LNCEL_AMLEPR3225_3075;
CREATE TABLE LNCEL_AMLEPR3225_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3075 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL amlepr combinations FROM 3225 TO 9560
DROP TABLE IF EXISTS LNCEL_AMLEPR3225_9560;
CREATE TABLE LNCEL_AMLEPR3225_9560 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 4 AS AMLEPR_id_New, 9560 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 3225;
--
-- LNCEL amlepr combinations FROM 9560 TO 651
DROP TABLE IF EXISTS LNCEL_AMLEPR9560_651;
CREATE TABLE LNCEL_AMLEPR9560_651 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 2 AS AMLEPR_id_New, 651 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL amlepr combinations FROM 9560 TO 626
DROP TABLE IF EXISTS LNCEL_AMLEPR9560_626;
CREATE TABLE LNCEL_AMLEPR9560_626 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 3 AS AMLEPR_id_New, 626 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL amlepr combinations FROM 9560 TO 3075
DROP TABLE IF EXISTS LNCEL_AMLEPR9560_3075;
CREATE TABLE LNCEL_AMLEPR9560_3075 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 0 AS AMLEPR_id_New, 3075 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
-- LNCEL amlepr combinations FROM 9560 TO 3225
DROP TABLE IF EXISTS LNCEL_AMLEPR9560_3225;
CREATE TABLE LNCEL_AMLEPR9560_3225 AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, 1 AS AMLEPR_id_New, 3225 AS targetCarrierFreq_New
FROM LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname
WHERE L.earfcnDL = 9560;
--
--
DROP TABLE IF EXISTS LNCEL_AMLEPR_FULL;
CREATE TABLE LNCEL_AMLEPR_FULL AS
SELECT * FROM LNCEL_AMLEPR626_3075
UNION ALL
SELECT * FROM LNCEL_AMLEPR626_3225
UNION ALL
SELECT * FROM LNCEL_AMLEPR626_9560
UNION ALL
SELECT * FROM LNCEL_AMLEPR651_3075
UNION ALL
SELECT * FROM LNCEL_AMLEPR651_3225
UNION ALL
SELECT * FROM LNCEL_AMLEPR651_9560
UNION ALL
SELECT * FROM LNCEL_AMLEPR3075_651
UNION ALL
SELECT * FROM LNCEL_AMLEPR3075_626
UNION ALL
SELECT * FROM LNCEL_AMLEPR3075_3225
UNION ALL
SELECT * FROM LNCEL_AMLEPR3075_9560
UNION ALL
SELECT * FROM LNCEL_AMLEPR3225_651
UNION ALL
SELECT * FROM LNCEL_AMLEPR3225_626
UNION ALL
SELECT * FROM LNCEL_AMLEPR3225_3075
UNION ALL
SELECT * FROM LNCEL_AMLEPR3225_9560
UNION ALL
SELECT * FROM LNCEL_AMLEPR9560_651
UNION ALL
SELECT * FROM LNCEL_AMLEPR9560_626
UNION ALL
SELECT * FROM LNCEL_AMLEPR9560_3075
UNION ALL
SELECT * FROM LNCEL_AMLEPR9560_3225
ORDER BY
    Region DESC, LNCELname;
--
--
DROP TABLE IF EXISTS AMLEPR_MISS;
CREATE TABLE AMLEPR_MISS AS
SELECT DISTINCT
L.LNCELname, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda, L.earfcnDL, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.LNCEL_id, L.AMLEPR_id_New, L.targetCarrierFreq_New, A.targetCarrierFreq
FROM LNCEL_AMLEPR_FULL AS L LEFT JOIN AMLEPR_ref AS A ON (L.PLMN_id = A.PLMN_id AND L.MRBTS_id = A.MRBTS_id AND L.LNBTS_id = A.LNBTS_id AND L.LNCEL_id = A.LNCEL_id AND L.targetCarrierFreq_New = A.targetCarrierFreq)
WHERE A.targetCarrierFreq IS NULL
ORDER BY L.Region DESC, L.LNCELname;
--
--
--
--
DROP TABLE IF EXISTS LNCEL_AUD1841_15_20;
CREATE TABLE LNCEL_AUD1841_15_20 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.PLMN_id, L.Prefijo, L.Sector, L.Banda, L.MRBTS_id,L.LNBTS_id,L.LNCEL_id,L.LNBTSname,
L.targetLoadNonGbrDl,L.targetLoadGbrDl,L.targetLoadPdcch,L.idleLBPercentageofUEs,L.t320,L.actAmle,L.amleMaxNumHo,L.amlePeriodLoadExchange,L.hysteresisLoadDlGbr,L.hysteresisLoadDlNonGbr,L.hysteresisLoadPdcch,L.iFLBBearCheckTimer,L.iFLBRetryTimer,L.maxLbPartners,L.mlbEicicOperMode,L.nomNumPrbNonGbr,L.ulCacSelection,L.ulStaticCac,L.idleLBCapThresh,L.idleLBCelResWeight,L.highLoadGbrDl,L.highLoadNonGbrDl,L.highLoadPdcch,L.iFLBHighLoadGBRDL,L.iFLBHighLoadNonGBRDL,L.iFLBHighLoadPdcch,L.dlChBw1
, 70 AS targetLoadNonGbrDl_N, 70 AS targetLoadGbrDl_N, 70 AS targetLoadPdcch_N, 80 AS idleLBPercentageofUEs_N, 10 AS t320_N, 1 AS actAmle_N, 10 AS amleMaxNumHo_N, 10000 AS amlePeriodLoadExchange_N, 2 AS hysteresisLoadDlGbr_N, 2 AS hysteresisLoadDlNonGbr_N, 2 AS hysteresisLoadPdcch_N, 12 AS iFLBBearCheckTimer_N, 60 AS iFLBRetryTimer_N, 16 AS maxLbPartners_N, 2 AS mlbEicicOperMode_N, 10 AS nomNumPrbNonGbr_N, 0 AS ulCacSelection_N, 100 AS ulStaticCac_N, 30 AS idleLBCapThresh_N, 30 AS idleLBCelResWeight_N, 90 AS highLoadGbrDl_N, 90 AS highLoadNonGbrDl_N, 90 AS highLoadPdcch_N, 90 AS iFLBHighLoadGBRDL_N, 90 AS iFLBHighLoadNonGBRDL_N, 90 AS iFLBHighLoadPdcch_N,CASE WHEN L.targetLoadNonGbrDl <> 70 THEN 1 ELSE 0 END AS targetLoadNonGbrDl_D,CASE WHEN L.targetLoadGbrDl <> 70 THEN 1 ELSE 0 END AS targetLoadGbrDl_D,CASE WHEN L.targetLoadPdcch <> 70 THEN 1 ELSE 0 END AS targetLoadPdcch_D,CASE WHEN L.idleLBPercentageofUEs <> 80 THEN 1 ELSE 0 END AS idleLBPercentageofUEs_D,CASE WHEN L.t320 <> 10 THEN 1 ELSE 0 END AS t320_D,CASE WHEN L.actAmle <> 1 THEN 1 ELSE 0 END AS actAmle_D,CASE WHEN L.amleMaxNumHo <> 10 THEN 1 ELSE 0 END AS amleMaxNumHo_D,CASE WHEN L.amlePeriodLoadExchange <> 10000 THEN 1 ELSE 0 END AS amlePeriodLoadExchange_D,CASE WHEN L.hysteresisLoadDlGbr <> 2 THEN 1 ELSE 0 END AS hysteresisLoadDlGbr_D,CASE WHEN L.hysteresisLoadDlNonGbr <> 2 THEN 1 ELSE 0 END AS hysteresisLoadDlNonGbr_D,CASE WHEN L.hysteresisLoadPdcch <> 2 THEN 1 ELSE 0 END AS hysteresisLoadPdcch_D,CASE WHEN L.iFLBBearCheckTimer <> 12 THEN 1 ELSE 0 END AS iFLBBearCheckTimer_D,CASE WHEN L.iFLBRetryTimer <> 60 THEN 1 ELSE 0 END AS iFLBRetryTimer_D,CASE WHEN L.maxLbPartners <> 16 THEN 1 ELSE 0 END AS maxLbPartners_D,CASE WHEN L.mlbEicicOperMode <> 2 THEN 1 ELSE 0 END AS mlbEicicOperMode_D,CASE WHEN L.nomNumPrbNonGbr <> 10 THEN 1 ELSE 0 END AS nomNumPrbNonGbr_D,CASE WHEN L.ulCacSelection <> 0 THEN 1 ELSE 0 END AS ulCacSelection_D,CASE WHEN L.ulStaticCac <> 100 THEN 1 ELSE 0 END AS ulStaticCac_D,CASE WHEN L.idleLBCapThresh <> 30 THEN 1 ELSE 0 END AS idleLBCapThresh_D,CASE WHEN L.idleLBCelResWeight <> 30 THEN 1 ELSE 0 END AS idleLBCelResWeight_D,CASE WHEN L.highLoadGbrDl <> 90 THEN 1 ELSE 0 END AS highLoadGbrDl_D,CASE WHEN L.highLoadNonGbrDl <> 90 THEN 1 ELSE 0 END AS highLoadNonGbrDl_D,CASE WHEN L.highLoadPdcch <> 90 THEN 1 ELSE 0 END AS highLoadPdcch_D,CASE WHEN L.iFLBHighLoadGBRDL <> 90 THEN 1 ELSE 0 END AS iFLBHighLoadGBRDL_D,CASE WHEN L.iFLBHighLoadNonGBRDL <> 90 THEN 1 ELSE 0 END AS iFLBHighLoadNonGBRDL_D,CASE WHEN L.iFLBHighLoadPdcch <> 90 THEN 1 ELSE 0 END AS iFLBHighLoadPdcch_D
FROM LNCEL_Full AS L
WHERE (L.dlChBw1=150 OR L.dlChBw1=200)  AND (L.targetLoadNonGbrDl<>70 OR L.targetLoadGbrDl<>70 OR L.targetLoadPdcch<>70 OR L.idleLBPercentageofUEs<>80 OR L.t320<>10 OR L.actAmle<>1 OR L.amleMaxNumHo<>10 OR L.amlePeriodLoadExchange<>10000 OR L.hysteresisLoadDlGbr<>2 OR L.hysteresisLoadDlNonGbr<>2 OR L.hysteresisLoadPdcch<>2 OR L.iFLBBearCheckTimer<>12 OR L.iFLBRetryTimer<>60 OR L.maxLbPartners<>16 OR L.mlbEicicOperMode<>2 OR L.nomNumPrbNonGbr<>10 OR L.ulCacSelection<>0 OR L.ulStaticCac<>100 OR L.idleLBCapThresh<>30 OR L.idleLBCelResWeight<>30 OR L.highLoadGbrDl<>90 OR L.highLoadNonGbrDl<>90 OR L.highLoadPdcch<>90 OR L.iFLBHighLoadGBRDL<>90 OR L.iFLBHighLoadNonGBRDL<>90 OR L.iFLBHighLoadPdcch<>90);
--
--
DROP TABLE IF EXISTS LNCEL_AUD1841_10;
CREATE TABLE LNCEL_AUD1841_10 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.PLMN_id, L.Prefijo, L.Sector, L.Banda, L.MRBTS_id,L.LNBTS_id,L.LNCEL_id,L.LNBTSname,
L.targetLoadNonGbrDl,L.targetLoadGbrDl,L.targetLoadPdcch,L.idleLBPercentageofUEs,L.t320,L.actAmle,L.amleMaxNumHo,L.amlePeriodLoadExchange,L.hysteresisLoadDlGbr,L.hysteresisLoadDlNonGbr,L.hysteresisLoadPdcch,L.iFLBBearCheckTimer,L.iFLBRetryTimer,L.maxLbPartners,L.mlbEicicOperMode,L.nomNumPrbNonGbr,L.ulCacSelection,L.ulStaticCac,L.idleLBCapThresh,L.idleLBCelResWeight,L.highLoadGbrDl,L.highLoadNonGbrDl,L.highLoadPdcch,L.iFLBHighLoadGBRDL,L.iFLBHighLoadNonGBRDL,L.iFLBHighLoadPdcch,L.dlChBw1
, 70 AS targetLoadNonGbrDl_N, 70 AS targetLoadGbrDl_N, 70 AS targetLoadPdcch_N, 80 AS idleLBPercentageofUEs_N, 10 AS t320_N, 1 AS actAmle_N, 10 AS amleMaxNumHo_N, 10000 AS amlePeriodLoadExchange_N, 2 AS hysteresisLoadDlGbr_N, 2 AS hysteresisLoadDlNonGbr_N, 2 AS hysteresisLoadPdcch_N, 12 AS iFLBBearCheckTimer_N, 60 AS iFLBRetryTimer_N, 16 AS maxLbPartners_N, 2 AS mlbEicicOperMode_N, 10 AS nomNumPrbNonGbr_N, 0 AS ulCacSelection_N, 100 AS ulStaticCac_N, 64 AS idleLBCapThresh_N, 10 AS idleLBCelResWeight_N, 70 AS highLoadGbrDl_N, 70 AS highLoadNonGbrDl_N, 70 AS highLoadPdcch_N, 70 AS iFLBHighLoadGBRDL_N, 70 AS iFLBHighLoadNonGBRDL_N, 70 AS iFLBHighLoadPdcch_N,CASE WHEN L.targetLoadNonGbrDl <> 70 THEN 1 ELSE 0 END AS targetLoadNonGbrDl_D,CASE WHEN L.targetLoadGbrDl <> 70 THEN 1 ELSE 0 END AS targetLoadGbrDl_D,CASE WHEN L.targetLoadPdcch <> 70 THEN 1 ELSE 0 END AS targetLoadPdcch_D,CASE WHEN L.idleLBPercentageofUEs <> 80 THEN 1 ELSE 0 END AS idleLBPercentageofUEs_D,CASE WHEN L.t320 <> 10 THEN 1 ELSE 0 END AS t320_D,CASE WHEN L.actAmle <> 1 THEN 1 ELSE 0 END AS actAmle_D,CASE WHEN L.amleMaxNumHo <> 10 THEN 1 ELSE 0 END AS amleMaxNumHo_D,CASE WHEN L.amlePeriodLoadExchange <> 10000 THEN 1 ELSE 0 END AS amlePeriodLoadExchange_D,CASE WHEN L.hysteresisLoadDlGbr <> 2 THEN 1 ELSE 0 END AS hysteresisLoadDlGbr_D,CASE WHEN L.hysteresisLoadDlNonGbr <> 2 THEN 1 ELSE 0 END AS hysteresisLoadDlNonGbr_D,CASE WHEN L.hysteresisLoadPdcch <> 2 THEN 1 ELSE 0 END AS hysteresisLoadPdcch_D,CASE WHEN L.iFLBBearCheckTimer <> 12 THEN 1 ELSE 0 END AS iFLBBearCheckTimer_D,CASE WHEN L.iFLBRetryTimer <> 60 THEN 1 ELSE 0 END AS iFLBRetryTimer_D,CASE WHEN L.maxLbPartners <> 16 THEN 1 ELSE 0 END AS maxLbPartners_D,CASE WHEN L.mlbEicicOperMode <> 2 THEN 1 ELSE 0 END AS mlbEicicOperMode_D,CASE WHEN L.nomNumPrbNonGbr <> 10 THEN 1 ELSE 0 END AS nomNumPrbNonGbr_D,CASE WHEN L.ulCacSelection <> 0 THEN 1 ELSE 0 END AS ulCacSelection_D,CASE WHEN L.ulStaticCac <> 100 THEN 1 ELSE 0 END AS ulStaticCac_D,CASE WHEN L.idleLBCapThresh <> 64 THEN 1 ELSE 0 END AS idleLBCapThresh_D,CASE WHEN L.idleLBCelResWeight <> 10 THEN 1 ELSE 0 END AS idleLBCelResWeight_D,CASE WHEN L.highLoadGbrDl <> 70 THEN 1 ELSE 0 END AS highLoadGbrDl_D,CASE WHEN L.highLoadNonGbrDl <> 70 THEN 1 ELSE 0 END AS highLoadNonGbrDl_D,CASE WHEN L.highLoadPdcch <> 70 THEN 1 ELSE 0 END AS highLoadPdcch_D,CASE WHEN L.iFLBHighLoadGBRDL <> 70 THEN 1 ELSE 0 END AS iFLBHighLoadGBRDL_D,CASE WHEN L.iFLBHighLoadNonGBRDL <> 70 THEN 1 ELSE 0 END AS iFLBHighLoadNonGBRDL_D,CASE WHEN L.iFLBHighLoadPdcch <> 70 THEN 1 ELSE 0 END AS iFLBHighLoadPdcch_D
FROM LNCEL_Full AS L
WHERE L.dlChBw1=100  AND (L.targetLoadNonGbrDl<>70 OR L.targetLoadGbrDl<>70 OR L.targetLoadPdcch<>70 OR L.idleLBPercentageofUEs<>80 OR L.t320<>10 OR L.actAmle<>1 OR L.amleMaxNumHo<>10 OR L.amlePeriodLoadExchange<>10000 OR L.hysteresisLoadDlGbr<>2 OR L.hysteresisLoadDlNonGbr<>2 OR L.hysteresisLoadPdcch<>2 OR L.iFLBBearCheckTimer<>12 OR L.iFLBRetryTimer<>60 OR L.maxLbPartners<>16 OR L.mlbEicicOperMode<>2 OR L.nomNumPrbNonGbr<>10 OR L.ulCacSelection<>0 OR L.ulStaticCac<>100 OR L.idleLBCapThresh<>64 OR L.idleLBCelResWeight<>10 OR L.highLoadGbrDl<>70 OR L.highLoadNonGbrDl<>70 OR L.highLoadPdcch<>70 OR L.iFLBHighLoadGBRDL<>70 OR L.iFLBHighLoadNonGBRDL<>70 OR L.iFLBHighLoadPdcch<>70);
--
--
DROP TABLE IF EXISTS LNCEL_AUD1841_5;
CREATE TABLE LNCEL_AUD1841_5 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.PLMN_id, L.Prefijo, L.Sector, L.Banda, L.MRBTS_id,L.LNBTS_id,L.LNCEL_id,L.LNBTSname,
L.targetLoadNonGbrDl,L.targetLoadGbrDl,L.targetLoadPdcch,L.idleLBPercentageofUEs,L.t320,L.actAmle,L.amleMaxNumHo,L.amlePeriodLoadExchange,L.hysteresisLoadDlGbr,L.hysteresisLoadDlNonGbr,L.hysteresisLoadPdcch,L.iFLBBearCheckTimer,L.iFLBRetryTimer,L.maxLbPartners,L.mlbEicicOperMode,L.nomNumPrbNonGbr,L.ulCacSelection,L.ulStaticCac,L.idleLBCapThresh,L.idleLBCelResWeight,L.highLoadGbrDl,L.highLoadNonGbrDl,L.highLoadPdcch,L.iFLBHighLoadGBRDL,L.iFLBHighLoadNonGBRDL,L.iFLBHighLoadPdcch,L.dlChBw1
, 70 AS targetLoadNonGbrDl_N, 70 AS targetLoadGbrDl_N, 70 AS targetLoadPdcch_N, 80 AS idleLBPercentageofUEs_N, 10 AS t320_N, 1 AS actAmle_N, 10 AS amleMaxNumHo_N, 10000 AS amlePeriodLoadExchange_N, 2 AS hysteresisLoadDlGbr_N, 2 AS hysteresisLoadDlNonGbr_N, 2 AS hysteresisLoadPdcch_N, 12 AS iFLBBearCheckTimer_N, 60 AS iFLBRetryTimer_N, 16 AS maxLbPartners_N, 2 AS mlbEicicOperMode_N, 10 AS nomNumPrbNonGbr_N, 0 AS ulCacSelection_N, 100 AS ulStaticCac_N, 70 AS idleLBCapThresh_N, 10 AS idleLBCelResWeight_N, 70 AS highLoadGbrDl_N, 70 AS highLoadNonGbrDl_N, 70 AS highLoadPdcch_N, 70 AS iFLBHighLoadGBRDL_N, 70 AS iFLBHighLoadNonGBRDL_N, 70 AS iFLBHighLoadPdcch_N,CASE WHEN L.targetLoadNonGbrDl <> 70 THEN 1 ELSE 0 END AS targetLoadNonGbrDl_D,CASE WHEN L.targetLoadGbrDl <> 70 THEN 1 ELSE 0 END AS targetLoadGbrDl_D,CASE WHEN L.targetLoadPdcch <> 70 THEN 1 ELSE 0 END AS targetLoadPdcch_D,CASE WHEN L.idleLBPercentageofUEs <> 80 THEN 1 ELSE 0 END AS idleLBPercentageofUEs_D,CASE WHEN L.t320 <> 10 THEN 1 ELSE 0 END AS t320_D,CASE WHEN L.actAmle <> 1 THEN 1 ELSE 0 END AS actAmle_D,CASE WHEN L.amleMaxNumHo <> 10 THEN 1 ELSE 0 END AS amleMaxNumHo_D,CASE WHEN L.amlePeriodLoadExchange <> 10000 THEN 1 ELSE 0 END AS amlePeriodLoadExchange_D,CASE WHEN L.hysteresisLoadDlGbr <> 2 THEN 1 ELSE 0 END AS hysteresisLoadDlGbr_D,CASE WHEN L.hysteresisLoadDlNonGbr <> 2 THEN 1 ELSE 0 END AS hysteresisLoadDlNonGbr_D,CASE WHEN L.hysteresisLoadPdcch <> 2 THEN 1 ELSE 0 END AS hysteresisLoadPdcch_D,CASE WHEN L.iFLBBearCheckTimer <> 12 THEN 1 ELSE 0 END AS iFLBBearCheckTimer_D,CASE WHEN L.iFLBRetryTimer <> 60 THEN 1 ELSE 0 END AS iFLBRetryTimer_D,CASE WHEN L.maxLbPartners <> 16 THEN 1 ELSE 0 END AS maxLbPartners_D,CASE WHEN L.mlbEicicOperMode <> 2 THEN 1 ELSE 0 END AS mlbEicicOperMode_D,CASE WHEN L.nomNumPrbNonGbr <> 10 THEN 1 ELSE 0 END AS nomNumPrbNonGbr_D,CASE WHEN L.ulCacSelection <> 0 THEN 1 ELSE 0 END AS ulCacSelection_D,CASE WHEN L.ulStaticCac <> 100 THEN 1 ELSE 0 END AS ulStaticCac_D,CASE WHEN L.idleLBCapThresh <> 70 THEN 1 ELSE 0 END AS idleLBCapThresh_D,CASE WHEN L.idleLBCelResWeight <> 10 THEN 1 ELSE 0 END AS idleLBCelResWeight_D,CASE WHEN L.highLoadGbrDl <> 70 THEN 1 ELSE 0 END AS highLoadGbrDl_D,CASE WHEN L.highLoadNonGbrDl <> 70 THEN 1 ELSE 0 END AS highLoadNonGbrDl_D,CASE WHEN L.highLoadPdcch <> 70 THEN 1 ELSE 0 END AS highLoadPdcch_D,CASE WHEN L.iFLBHighLoadGBRDL <> 70 THEN 1 ELSE 0 END AS iFLBHighLoadGBRDL_D,CASE WHEN L.iFLBHighLoadNonGBRDL <> 70 THEN 1 ELSE 0 END AS iFLBHighLoadNonGBRDL_D,CASE WHEN L.iFLBHighLoadPdcch <> 70 THEN 1 ELSE 0 END AS iFLBHighLoadPdcch_D
FROM LNCEL_Full AS L
WHERE L.dlChBw1=50  AND (
L.targetLoadNonGbrDl<>70 OR L.targetLoadGbrDl<>70 OR L.targetLoadPdcch<>70 OR L.idleLBPercentageofUEs<>80 OR L.t320<>10 OR L.actAmle<>1 OR L.amleMaxNumHo<>10 OR L.amlePeriodLoadExchange<>10000 OR L.hysteresisLoadDlGbr<>2 OR L.hysteresisLoadDlNonGbr<>2 OR L.hysteresisLoadPdcch<>2 OR L.iFLBBearCheckTimer<>12 OR L.iFLBRetryTimer<>60 OR L.maxLbPartners<>16 OR L.mlbEicicOperMode<>2 OR L.nomNumPrbNonGbr<>10 OR L.ulCacSelection<>0 OR L.ulStaticCac<>100 OR L.idleLBCapThresh<>70 OR L.idleLBCelResWeight<>10 OR L.highLoadGbrDl<>70 OR L.highLoadNonGbrDl<>70 OR L.highLoadPdcch<>70 OR L.iFLBHighLoadGBRDL<>70 OR L.iFLBHighLoadNonGBRDL<>70 OR L.iFLBHighLoadPdcch<>70);
--
--
DROP TABLE IF EXISTS LNCEL_IDCONGEN_15_20;
CREATE TABLE LNCEL_IDCONGEN_15_20 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.PLMN_id, L.Prefijo, L.Sector, L.Banda, L.MRBTS_id,L.LNBTS_id,L.LNCEL_id,L.LNBTSname, L.cellReSelPrio,L.qrxLevMin,L.Threshold1,L.threshold3,L.threshold3a,L.Threshold2InterFreq,L.Threshold2InterFreqQCI1,L.threshold2a,L.threshold2aQci1,L.Threshold2Wcdma,L.Threshold2WcdmaQCI1,L.threshold4,L.a3offset,L.measQuantityUtra,L.dlChBw1
, 7 AS cellReSelPrio_N, -122 AS qrxLevMin_N, 90 AS Threshold1_N, 32 AS threshold3_N, 34 AS threshold3a_N, 25 AS Threshold2InterFreq_N, 25 AS Threshold2InterFreqQCI1_N, 26 AS threshold2a_N, 26 AS threshold2aQci1_N, 23 AS Threshold2Wcdma_N, 23 AS Threshold2WcdmaQCI1_N, 20 AS threshold4_N, 12 AS a3offset_N, 1 AS measQuantityUtra_N,CASE WHEN L.cellReSelPrio <> 7 THEN 1 ELSE 0 END AS cellReSelPrio_D,CASE WHEN L.qrxLevMin <> -122 THEN 1 ELSE 0 END AS qrxLevMin_D,CASE WHEN L.Threshold1 <> 90 THEN 1 ELSE 0 END AS Threshold1_D,CASE WHEN L.threshold3 <> 32 THEN 1 ELSE 0 END AS threshold3_D,CASE WHEN L.threshold3a <> 34 THEN 1 ELSE 0 END AS threshold3a_D,CASE WHEN L.Threshold2InterFreq <> 25 THEN 1 ELSE 0 END AS Threshold2InterFreq_D,CASE WHEN L.Threshold2InterFreqQCI1 <> 25 THEN 1 ELSE 0 END AS Threshold2InterFreqQCI1_D,CASE WHEN L.threshold2a <> 26 THEN 1 ELSE 0 END AS threshold2a_D,CASE WHEN L.threshold2aQci1 <> 26 THEN 1 ELSE 0 END AS threshold2aQci1_D,CASE WHEN L.Threshold2Wcdma <> 23 THEN 1 ELSE 0 END AS Threshold2Wcdma_D,CASE WHEN L.Threshold2WcdmaQCI1 <> 23 THEN 1 ELSE 0 END AS Threshold2WcdmaQCI1_D,CASE WHEN L.threshold4 <> 20 THEN 1 ELSE 0 END AS threshold4_D,CASE WHEN L.a3offset <> 12 THEN 1 ELSE 0 END AS a3offset_D,CASE WHEN L.measQuantityUtra <> 1 THEN 1 ELSE 0 END AS measQuantityUtra_D
FROM LNCEL_Full AS L
WHERE (L.dlChBw1=150 OR L.dlChBw1=200)  AND (L.cellReSelPrio<>7 OR L.qrxLevMin<>-122 OR L.Threshold1<>90 OR L.threshold3<>32 OR L.threshold3a<>34 OR L.Threshold2InterFreq<>25 OR L.Threshold2InterFreqQCI1<>25 OR L.threshold2a<>26 OR L.threshold2aQci1<>26 OR L.Threshold2Wcdma<>23 OR L.Threshold2WcdmaQCI1<>23 OR L.threshold4<>20 OR L.a3offset<>12 OR L.measQuantityUtra<>1);
--
--
DROP TABLE IF EXISTS LNCEL_IDCONGEN_10;
CREATE TABLE LNCEL_IDCONGEN_10 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.PLMN_id, L.Prefijo, L.Sector, L.Banda, L.MRBTS_id,L.LNBTS_id,L.LNCEL_id,L.LNBTSname, L.cellReSelPrio,L.qrxLevMin,L.Threshold1,L.threshold3,L.threshold3a,L.Threshold2InterFreq,L.Threshold2InterFreqQCI1,L.threshold2a,L.threshold2aQci1,L.Threshold2Wcdma,L.Threshold2WcdmaQCI1,L.threshold4,L.a3offset,L.measQuantityUtra,L.dlChBw1, 6 AS cellReSelPrio_N, -120 AS qrxLevMin_N, 90 AS Threshold1_N, 34 AS threshold3_N, 36 AS threshold3a_N, 27 AS Threshold2InterFreq_N, 27 AS Threshold2InterFreqQCI1_N, 28 AS threshold2a_N, 28 AS threshold2aQci1_N, 25 AS Threshold2Wcdma_N, 25 AS Threshold2WcdmaQCI1_N, 22 AS threshold4_N, 12 AS a3offset_N, 1 AS measQuantityUtra_N,CASE WHEN L.cellReSelPrio <> 6 THEN 1 ELSE 0 END AS cellReSelPrio_D,CASE WHEN L.qrxLevMin <> -120 THEN 1 ELSE 0 END AS qrxLevMin_D,CASE WHEN L.Threshold1 <> 90 THEN 1 ELSE 0 END AS Threshold1_D,CASE WHEN L.threshold3 <> 34 THEN 1 ELSE 0 END AS threshold3_D,CASE WHEN L.threshold3a <> 36 THEN 1 ELSE 0 END AS threshold3a_D,CASE WHEN L.Threshold2InterFreq <> 27 THEN 1 ELSE 0 END AS Threshold2InterFreq_D,CASE WHEN L.Threshold2InterFreqQCI1 <> 27 THEN 1 ELSE 0 END AS Threshold2InterFreqQCI1_D,CASE WHEN L.threshold2a <> 28 THEN 1 ELSE 0 END AS threshold2a_D,CASE WHEN L.threshold2aQci1 <> 28 THEN 1 ELSE 0 END AS threshold2aQci1_D,CASE WHEN L.Threshold2Wcdma <> 25 THEN 1 ELSE 0 END AS Threshold2Wcdma_D,CASE WHEN L.Threshold2WcdmaQCI1 <> 25 THEN 1 ELSE 0 END AS Threshold2WcdmaQCI1_D,CASE WHEN L.threshold4 <> 22 THEN 1 ELSE 0 END AS threshold4_D,CASE WHEN L.a3offset <> 12 THEN 1 ELSE 0 END AS a3offset_D,CASE WHEN L.measQuantityUtra <> 1 THEN 1 ELSE 0 END AS measQuantityUtra_D
FROM LNCEL_Full AS L
WHERE (L.dlChBw1=100)  AND (L.cellReSelPrio<>6 OR L.qrxLevMin<>-120 OR L.Threshold1<>90 OR L.threshold3<>34 OR L.threshold3a<>36 OR L.Threshold2InterFreq<>27 OR L.Threshold2InterFreqQCI1<>27 OR L.threshold2a<>28 OR L.threshold2aQci1<>28 OR L.Threshold2Wcdma<>25 OR L.Threshold2WcdmaQCI1<>25 OR L.threshold4<>22 OR L.a3offset<>12 OR L.measQuantityUtra<>1);
--
--
DROP TABLE IF EXISTS LNCEL_IDCONGEN_5;
CREATE TABLE LNCEL_IDCONGEN_5 AS
SELECT DISTINCT
L.LNCELname, L.Cluster, L.Region, L.Depto, L.Mun, L.KeySector, L.PLMN_id, L.Prefijo, L.Sector, L.Banda, L.MRBTS_id,L.LNBTS_id,L.LNCEL_id,L.LNBTSname, L.cellReSelPrio,L.qrxLevMin,L.Threshold1,L.threshold3,L.threshold3a,L.Threshold2InterFreq,L.Threshold2InterFreqQCI1,L.threshold2a,L.threshold2aQci1,L.Threshold2Wcdma,L.Threshold2WcdmaQCI1,L.threshold4,L.a3offset,L.measQuantityUtra,L.dlChBw1
, 6 AS cellReSelPrio_N, -120 AS qrxLevMin_N, 90 AS Threshold1_N, 34 AS threshold3_N, 36 AS threshold3a_N, 27 AS Threshold2InterFreq_N, 27 AS Threshold2InterFreqQCI1_N, 28 AS threshold2a_N, 28 AS threshold2aQci1_N, 25 AS Threshold2Wcdma_N, 25 AS Threshold2WcdmaQCI1_N, 22 AS threshold4_N, 12 AS a3offset_N, 1 AS measQuantityUtra_N,CASE WHEN L.cellReSelPrio <> 6 THEN 1 ELSE 0 END AS cellReSelPrio_D,CASE WHEN L.qrxLevMin <> -120 THEN 1 ELSE 0 END AS qrxLevMin_D,CASE WHEN L.Threshold1 <> 90 THEN 1 ELSE 0 END AS Threshold1_D,CASE WHEN L.threshold3 <> 34 THEN 1 ELSE 0 END AS threshold3_D,CASE WHEN L.threshold3a <> 36 THEN 1 ELSE 0 END AS threshold3a_D,CASE WHEN L.Threshold2InterFreq <> 27 THEN 1 ELSE 0 END AS Threshold2InterFreq_D,CASE WHEN L.Threshold2InterFreqQCI1 <> 27 THEN 1 ELSE 0 END AS Threshold2InterFreqQCI1_D,CASE WHEN L.threshold2a <> 28 THEN 1 ELSE 0 END AS threshold2a_D,CASE WHEN L.threshold2aQci1 <> 28 THEN 1 ELSE 0 END AS threshold2aQci1_D,CASE WHEN L.Threshold2Wcdma <> 25 THEN 1 ELSE 0 END AS Threshold2Wcdma_D,CASE WHEN L.Threshold2WcdmaQCI1 <> 25 THEN 1 ELSE 0 END AS Threshold2WcdmaQCI1_D,CASE WHEN L.threshold4 <> 22 THEN 1 ELSE 0 END AS threshold4_D,CASE WHEN L.a3offset <> 12 THEN 1 ELSE 0 END AS a3offset_D,CASE WHEN L.measQuantityUtra <> 1 THEN 1 ELSE 0 END AS measQuantityUtra_D
FROM LNCEL_Full AS L
WHERE (L.dlChBw1=50)  AND (L.cellReSelPrio<>5 OR L.qrxLevMin<>-118 OR L.Threshold1<>90 OR L.threshold3<>36 OR L.threshold3a<>38 OR L.Threshold2InterFreq<>29 OR L.Threshold2InterFreqQCI1<>29 OR L.threshold2a<>30 OR L.threshold2aQci1<>30 OR L.Threshold2Wcdma<>27 OR L.Threshold2WcdmaQCI1<>27 OR L.threshold4<>24 OR L.a3offset<>12 OR L.measQuantityUtra<>1);
--
--
DROP TABLE IF EXISTS LNBTS_AUD2051;
CREATE TABLE LNBTS_AUD2051 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, L.actIdleLb, L.actMeasBasedIMLB, L.reportTimerIMLBA4, L.prohibitLBHOTimer
FROM LNBTS_Full AS L
WHERE (L.actIdleLb<>1 OR L.actMeasBasedIMLB<>1 OR L.reportTimerIMLBA4<>2000 OR L.prohibitLBHOTimer<>10);
--
--
--
--
DROP TABLE IF EXISTS LNMME_Paramf;
CREATE TABLE LNMME_Paramf AS
SELECT DISTINCT
B.Cluster, B.Region, B.Departamento AS Depto, B.Municipio AS Mun,
L.PLMN_id,L.MRBTS_id,L.LNBTS_id, N.LNMME_id, L.name AS LNBTSname, L.operationalState AS LNBTS_OpSt, N.moVersion, N.administrativeState, N.ipAddrPrim, N.ipAddrSec, N.relMmeCap, N.s1LinkStatus, N.transportNwId, N.mmeRatSupport, N.SBTS_id, N.mmeName
FROM (LNMME AS N LEFT JOIN LNBTS AS L ON (L.PLMN_Id=N.PLMN_Id) AND (L.MRBTS_Id=N.MRBTS_Id) AND (L.LNBTS_Id=N.LNBTS_Id)) LEFT JOIN baselinesite As B ON (B.Sitio = L.name COLLATE NOCASE)
;
--
DROP TABLE IF EXISTS LNMME_Param;
CREATE TABLE LNMME_Param AS
SELECT DISTINCT
N.Cluster, N.Region, N.Depto, N.Mun, N.PLMN_id, N.MRBTS_id, N.LNBTS_id, N.LNMME_id, N.LNBTSname,
N.LNBTS_OpSt, N.moVersion, N.administrativeState, N.ipAddrPrim, N.ipAddrSec, N.relMmeCap,
N.s1LinkStatus, N.transportNwId, N.mmeRatSupport, N.SBTS_id, N.mmeName
FROM LNMME_Paramf N
WHERE N.mmeName NOT LIKE 'cmm%' or N.mmeName IS NULL
;
--
DROP TABLE IF EXISTS LNMME_Audit;
CREATE TABLE LNMME_Audit AS
SELECT
N.Cluster, N.Region, N.Depto, N.Mun,
N.PLMN_id,N.MRBTS_id,N.LNBTS_id, COUNT(N.LNMME_id) AS MME_Count, N.LNBTSname, N.LNBTS_OpSt, N.moVersion, N.administrativeState
FROM LNMME_Param AS N
GROUP BY N.PLMN_id,N.MRBTS_id
;
--
DROP TABLE IF EXISTS LNMME_Miss;
CREATE TABLE LNMME_Miss AS
SELECT DISTINCT
N.Cluster, N.Region, N.Depto, N.Mun,
N.PLMN_id,N.MRBTS_id,N.LNBTS_id, N.MME_Count, N.LNBTSname, N.LNBTS_OpSt, N.moVersion, N.administrativeState
FROM LNMME_Audit AS N
WHERE N.MME_Count != 8 AND N.PLMN_id IS NOT NULL
ORDER BY N.MME_Count
;
--
--
--
--
DROP TABLE IF EXISTS ADJL_PARAM;
CREATE TABLE ADJL_PARAM AS
SELECT DISTINCT
W.WCELName, W.WBTSName, W.Cluster, W.Region, W.Depto, W.Mun, W.UARFCN, W.Escenario_1900, W.RNCName, A.PLMN_id, A.RNC_id, A.WBTS_id, A.WCEL_id, A.ADJL_id,
A.AdjLMeasBw, A.AdjLSelectFreq, A.HopLIdentifier, A.name, A.AdjLEARFCN, CASE WHEN A.AdjLEARFCN BETWEEN 2750 and 3449 THEN 2600 ELSE
(CASE WHEN A.AdjLEARFCN BETWEEN 600 and 1199 THEN 1900 ELSE (CASE WHEN A.AdjLEARFCN BETWEEN 9210 and 9659 THEN 700 ELSE
(CASE WHEN A.AdjLEARFCN BETWEEN 2400 and 2649 THEN 850 ELSE (CASE WHEN A.AdjLEARFCN BETWEEN 1950 and 2399 THEN 2100 ELSE NULL END)END)END)END)END AS ADJL_Band,
A.distName, A.moVersion
FROM WCEL_FULL1 AS W LEFT JOIN ADJL AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
ORDER BY W.Region DESC, W.WCELName;
--
DROP TABLE IF EXISTS ADJL_PARAMG;
CREATE TABLE ADJL_PARAMG AS
SELECT DISTINCT
B.BTSname, B.BCFname, B.Cluster, B.Region, B.Depto, B.Mun, B.BandName, B.BSCname, A.PLMN_id, B.bsc_Id, B.bcf_Id, B.bts_Id, A.ADJL_id,
A.name, A.barredLteAdjCellGroup, A.barredLteAdjCellPattern, A.barredLteAdjCellPatternSense, A.earfcn,
CASE WHEN A.earfcn BETWEEN 2750 and 3449 THEN 2600 ELSE (CASE WHEN A.earfcn BETWEEN 600 and 1199 THEN 1900 ELSE
(CASE WHEN A.earfcn BETWEEN 9210 and 9659 THEN 700 ELSE (CASE WHEN A.earfcn BETWEEN 2400 and 2649 THEN 850 ELSE
(CASE WHEN A.earfcn BETWEEN 1950 and 2399 THEN 2100 ELSE NULL END)END)END)END)END AS ADJL_Band,
A.lteAdjCellMcc, A.lteAdjCellMinBand, A.lteAdjCellMinRxLevel, A.lteAdjCellMnc, A.lteAdjCellPriority, A.lteAdjCellReselectLowerThr,
A.lteAdjCellReselectUpperThr, A.lteAdjCellTac, A.distName, A.moVersion
FROM BTS_PARAM AS B LEFT JOIN ADJL AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
ORDER BY B.Region DESC, B.BTSname;
--
--
--
--ADJL 1900 discrepancies
DROP TABLE IF EXISTS ADJL_DISC;
CREATE TABLE ADJL_DISC AS
SELECT DISTINCT
A.WCELName, A.WBTSName, A.Cluster, A.Region, A.Depto, A.Mun, A.RNCName, A.PLMN_id, A.RNC_id, A.WBTS_id, A.WCEL_id, A.ADJL_id, A.UARFCN, A.AdjLEARFCN,
A.name, A.ADJL_Band, A.Escenario_1900
FROM ADJL_PARAM AS A
WHERE (A.Escenario_1900 = 'Alta' AND A.AdjLEARFCN=651) OR (A.Escenario_1900 = 'Baja' AND A.AdjLEARFCN=626);
--
--
DROP TABLE IF EXISTS ADJL_AUD9560V2;
CREATE TABLE ADJL_AUD9560v2 AS
SELECT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L9560 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS 9560;
--
DROP TABLE IF EXISTS ADJL_AUD9560;
CREATE TABLE ADJL_AUD9560 AS
SELECT DISTINCT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L9560 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL_AUD9560V2 AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS NULL;
;

DROP TABLE IF EXISTS ADJL_AUD651V2;
CREATE TABLE ADJL_AUD651v2 AS
SELECT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L651 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS 651;
--
DROP TABLE IF EXISTS ADJL_AUD651;
CREATE TABLE ADJL_AUD651 AS
SELECT DISTINCT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L651 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL_AUD651V2 AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS NULL AND W.WCEL_id IS NOT NULL;
;
--
--
DROP TABLE IF EXISTS ADJL_AUD626V2;
CREATE TABLE ADJL_AUD626v2 AS
SELECT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L626 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS 626;
--
DROP TABLE IF EXISTS ADJL_AUD626;
CREATE TABLE ADJL_AUD626 AS
SELECT DISTINCT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L626 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL_AUD626V2 AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS NULL AND W.WCEL_id IS NOT NULL;
;
--
--
DROP TABLE IF EXISTS ADJL_AUD3225V2;
CREATE TABLE ADJL_AUD3225v2 AS
SELECT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L3225 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS 3225;
--
DROP TABLE IF EXISTS ADJL_AUD3225;
CREATE TABLE ADJL_AUD3225 AS
SELECT DISTINCT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L3225 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL_AUD3225V2 AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS NULL AND W.WCEL_id IS NOT NULL;
;
--
--
DROP TABLE IF EXISTS ADJL_AUD3075V2;
CREATE TABLE ADJL_AUD3075v2 AS
SELECT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L3075 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS 3075;
--
DROP TABLE IF EXISTS ADJL_AUD3075;
CREATE TABLE ADJL_AUD3075 AS
SELECT DISTINCT
W.WCELName, W.Cluster, W.Region, W.Depto, W.Mun, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, A.AdjLEARFCN
FROM (WCEL_PARAM1 AS W INNER JOIN Sites_L3075 AS L ON (W.WBTSName = L.LNBTSname)) LEFT JOIN ADJL_AUD3075V2 AS A ON (A.RNC_id = W.RNC_id) AND (A.WBTS_id = W.WBTS_id) AND (A.WCEL_id = W.WCEL_id)
WHERE A.AdjLEARFCN IS NULL AND W.WCEL_id IS NOT NULL;
--
--
--
--
DROP TABLE IF EXISTS ADJL_AUD9560G2;
CREATE TABLE ADJL_AUD9560G2 AS
SELECT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, A.PLMN_id, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L9560 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS 9560;
--
--
DROP TABLE IF EXISTS ADJL_AUD9560G;
CREATE TABLE ADJL_AUD9560G AS
SELECT DISTINCT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L9560 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL_AUD9560G2 AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS NULL;
--
--
DROP TABLE IF EXISTS ADJL_AUD651G2;
CREATE TABLE ADJL_AUD651G2 AS
SELECT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, A.PLMN_id, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L651 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS 651;
--
--
DROP TABLE IF EXISTS ADJL_AUD651G;
CREATE TABLE ADJL_AUD651G AS
SELECT DISTINCT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L651 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL_AUD651G2 AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS NULL;
--
--
DROP TABLE IF EXISTS ADJL_AUD626G2;
CREATE TABLE ADJL_AUD626G2 AS
SELECT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, A.PLMN_id, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L626 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS 626;
--
--
DROP TABLE IF EXISTS ADJL_AUD626G;
CREATE TABLE ADJL_AUD626G AS
SELECT DISTINCT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L626 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL_AUD626G2 AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS NULL;
--
--
DROP TABLE IF EXISTS ADJL_AUD3225G2;
CREATE TABLE ADJL_AUD3225G2 AS
SELECT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, A.PLMN_id, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L3225 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS 3225;
--
--
DROP TABLE IF EXISTS ADJL_AUD3225G;
CREATE TABLE ADJL_AUD3225G AS
SELECT DISTINCT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L3225 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL_AUD3225G2 AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS NULL;
--
--
DROP TABLE IF EXISTS ADJL_AUD3075G2;
CREATE TABLE ADJL_AUD3075G2 AS
SELECT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, A.PLMN_id, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L3075 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS 3075;
--
--
DROP TABLE IF EXISTS ADJL_AUD3075G;
CREATE TABLE ADJL_AUD3075G AS
SELECT DISTINCT
B.BTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.BSCname, B.bsc_Id, B.bcf_Id, B.bts_Id, A.earfcn
FROM (BTS_PARAM AS B INNER JOIN Sites_L3075 AS L ON (B.BCFname = L.LNBTSname)) LEFT JOIN ADJL_AUD3075G2 AS A ON (A.PLMN_id = B.PLMN_Id) AND (A.BSC_id = B.bsc_Id) AND (A.BCF_id = B.bcf_Id) AND (A.BTS_id = B.bts_Id)
WHERE A.earfcn IS NULL;
--
--
--
-- LNREL network
--
--
DROP TABLE IF EXISTS LNREL_P;
CREATE TABLE LNREL_P AS
SELECT
l.Cluster, l.Region, l.Zona, l.Depto, l.Mun, l.Prefijo, l.LNCELname, l.lcrId, r.PLMN_id, l.earfcnDL, r.MRBTS_id, r.LNBTS_id, r.LNCEL_id, r.LNREL_id, r.moVersion, r.mcc, r.mnc, r.amleAllowed, r.cellIndOffNeigh, r.cellIndOffNeighDelta, r.ecgiAdjEnbId,r.ecgiLcrId,r.handoverAllowed,r.nrControl,r.nrStatus,r.removeAllowed,r.SBTS_id,r.name,l.Latitud AS LatitudS, l.Longitud AS LongitudS,
l.LNBTSname, r.ecgiAdjEnbId AS MRBTS_idT, l.eutraCelId, l.PowerBoost, l.phyCellId AS PCI, l.rootSeqIndex AS RSI, l.tac, l.Estado, l.Banda, l.Sector, l.Az, CASE WHEN (l.Az > 180) THEN (l.Az -360) ELSE l.Az END AS AzS1, (r.ecgiAdjEnbId||r.ecgiLcrId) AS keyT
FROM LNREL r LEFT JOIN Lte_Param l ON (l.PLMN_Id = r.PLMN_Id) AND (L.MRBTS_ID = r.MRBTS_ID) AND (r.LNBTS_Id=l.LNBTS_Id) AND (r.LNCEL_id=l.LNCEL_id);
--
DROP TABLE IF EXISTS LNREL_P1;
CREATE TABLE LNREL_P1 AS
SELECT
r.Cluster, r.Region, r.Zona, r.Depto, r.Mun, r.Prefijo, r.LNCELname, r.lcrId, r.PLMN_id, r.earfcnDL, r.MRBTS_id, r.LNBTS_id, r.LNCEL_id, r.LNREL_id, r.moVersion, r.mcc, r.mnc, r.amleAllowed, r.cellIndOffNeigh, r.cellIndOffNeighDelta, r.ecgiAdjEnbId,r.ecgiLcrId,r.handoverAllowed,r.nrControl,r.nrStatus,r.removeAllowed,r.SBTS_id,r.name,r.LatitudS, r.LongitudS,
r.LNBTSname, r.MRBTS_idT, r.eutraCelId, r.PowerBoost, r.PCI, r.RSI, r.tac, r.Estado, r.Banda, r.Sector,  r.Az, r.AzS1,
l.Zona as ZonaT, l.Cluster AS ClusterT, l.Region AS RegionT, l.Depto AS DeptoT, l.Mun AS MunT,
l.LNCELname AS LNCELnameT, r.ecgiLcrId AS lcrIdT, l.PLMN_id AS PLMN_idT, l.earfcnDL AS earfcnDLT, l.Latitud AS LatitudT,  l.Longitud AS LongitudT,
l.LNBTSname AS LNBTSnameT, r.ecgiAdjEnbId AS MRBTS_idT, l.LNBTS_id AS LNBTS_idT,l.LNCEL_id AS LNCEL_idT, l.eutraCelId AS eutraCelIdT, l.PowerBoost AS PowerBoostT, l.phyCellId AS PCIT, l.rootSeqIndex AS RSIT, l.tac AS tacT, l.Estado AS EstadoT, l.Sector AS SectorT, CASE WHEN (r.LNBTSname = l.LNBTSname) THEN 1 ELSE 0 END AS SameSite, CASE WHEN (r.Sector = l.Sector) THEN 1 ELSE 0 END AS SameSector, l.Banda AS BandaT,
l.Az AS AzT, CASE WHEN (l.Az > 180) THEN (l.Az -360) ELSE l.Az END AS AzT1
FROM LNREL_P r LEFT JOIN Lte_Param l ON (r.keyT = l.klcrid);
--
--
DROP TABLE IF EXISTS LNREL_PAR;
-- Includes distance, bearing and bearback
CREATE TABLE LNREL_PAR AS
SELECT
r.Cluster, r.Region, r.Zona, r.ZonaT, r.Depto, r.Mun, r.ClusterT, r.RegionT, r.DeptoT, r.MunT, r.Prefijo, r.LNCELname, r.LNCELnameT, r.lcrId, r.lcrIdT, r.PLMN_id, r.PLMN_idT, r.earfcnDL, r.earfcnDLT, r.MRBTS_id, r.LNBTS_id, r.LNCEL_id, r.LNREL_id, r.moVersion, r.mcc, r.mnc, r.amleAllowed, r.cellIndOffNeigh, r.cellIndOffNeighDelta, r.ecgiAdjEnbId, r.ecgiLcrId, r.handoverAllowed, r.nrControl, r.nrStatus, r.removeAllowed, r.SBTS_id, r.name, r.LatitudS, r.LongitudS, r.LatitudT, r.LongitudT, r.LNBTSname, r.LNBTSnameT, r.MRBTS_idT, r.LNBTS_idT, r.LNCEL_idT, r.eutraCelId, r.PowerBoost, r.PCI, r.RSI, r.tac, r.eutraCelIdT, r.PowerBoostT, r.PCIT, r.RSIT, r.tacT, r.Estado, r.EstadoT, r.SameSite, r.SameSector, r.Banda, r.BandaT, r.Az, r.AzT, r.AzS1, r.AzT1,
ROUND (12756273.2 * ASIN(MIN(1 , SQRT(POWER( SIN(RADIANS(r.LatitudS - r.LatitudT)/2) , 2) +
                                    COS(RADIANS(r.LatitudS)) * COS(RADIANS(r.LatitudT)) * POWER ( SIN(RADIANS(r.LongitudS - r.LongitudT)/2) , 2))))
         , 0) AS Distance,
ROUND(180/ACOS(-1)*ATAN2(
                          COS(RADIANS(r.LatitudT)) * SIN(RADIANS(r.LongitudT - r.LongitudS)), COS(RADIANS(r.LatitudS)) * SIN(RADIANS(r.LatitudT)) -
                          SIN(RADIANS(r.LatitudS)) * COS(RADIANS(r.LatitudT))*COS(RADIANS(r.LongitudT - r.LongitudS))
                          )
       , 1) AS bearing,
ROUND(180/ACOS(-1)*ATAN2(
                         COS(RADIANS(r.LatitudS)) * SIN(RADIANS(r.LongitudS - r.LongitudT)), COS(RADIANS(r.LatitudT)) * SIN(RADIANS(r.LatitudS)) -
                         SIN(RADIANS(r.LatitudT)) * COS(RADIANS(r.LatitudS))*COS(RADIANS(r.LongitudS - r.LongitudT))
                         )
      , 1) AS bearback
FROM LNREL_P1 r;
--
--
--angles positive, includes CoefCoOrient usefull eg. when theta 180 and az to bear 90 for each sector, if coef =0 sector are heading to the same area,
--if 180 sectors are opposite oriented.
--
DROP TABLE IF EXISTS LNREL_PAR1;
CREATE TABLE LNREL_PAR1 AS
SELECT
r.Cluster, r.Region, r.Zona, r.ZonaT, r.Depto, r.Mun, r.ClusterT, r.RegionT, r.DeptoT, r.MunT, r.Prefijo, r.LNCELname, r.LNCELnameT, r.lcrId, r.lcrIdT, r.PLMN_id, r.PLMN_idT, r.earfcnDL, r.earfcnDLT, r.MRBTS_id, r.LNBTS_id, r.LNCEL_id, r.LNREL_id, r.moVersion, r.mcc, r.mnc, r.amleAllowed, r.cellIndOffNeigh, r.cellIndOffNeighDelta, r.ecgiAdjEnbId, r.ecgiLcrId, r.handoverAllowed, r.nrControl, r.nrStatus, r.removeAllowed, r.SBTS_id, r.name, r.LatitudS, r.LongitudS, r.LatitudT, r.LongitudT, r.LNBTSname, r.LNBTSnameT, r.MRBTS_idT, r.LNBTS_idT, r.LNCEL_idT, r.eutraCelId, r.PowerBoost, r.PCI, r.RSI, r.tac, r.eutraCelIdT, r.PowerBoostT, r.PCIT, r.RSIT, r.tacT, r.Estado, r.EstadoT, r.SameSite, r.SameSector, r.Banda, r.BandaT, r.Az, r.AzT, r.AzS1, r.AzT1, r.Distance,
CASE WHEN r.bearing < 0 THEN (360 + r.bearing) ELSE r.bearing END AS bearing,
CASE WHEN r.bearback < 0 THEN (360 + r.bearback) ELSE r.bearback END AS bearback,
ROUND(CASE WHEN(ABS(r.bearing - r.AzS1) > 180) THEN ABS(ABS(r.bearing - r.AzS1) - 360) ELSE (ABS(r.bearing - r.AzS1)) END +
      CASE WHEN(ABS(r.bearback - r.AzT1) > 180) THEN ABS(ABS(r.bearback - r.AzT1) - 360) ELSE (ABS(r.bearback - r.AzT1)) END,1) AS ThetaAng,
CASE WHEN (ABS(r.AzS1-r.AzT1)> 180) THEN ABS(ABS(r.AzS1-r.AzT1)-360) ELSE (ABS(r.AzS1-r.AzT1)) END AS CoefCoOrient
FROM LNREL_PAR r;
--
--
-- LNCEL cosite combinations
DROP TABLE IF EXISTS LNCEL_COSITE;
CREATE TABLE LNCEL_COSITE AS
SELECT
L.LNCELname AS LNCELnameS, L1.LNCELname AS LNCELnameT, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.Banda AS BandaS, L1.Banda AS BandaT, L.earfcnDL AS earfcnDLS, L1.earfcnDL AS earfcnDLT, L.PLMN_id, L.MRBTS_id AS MRBTS_idS, L.LNBTS_id AS LNBTS_idS, L.LNCEL_id AS LNCEL_idS, L1.MRBTS_id AS MRBTS_idT, L1.LNBTS_id AS LNBTS_idT, L1.LNCEL_id AS LNCEL_idT, L.lcrId AS lcrIdS, L1.lcrId AS lcrIdT
FROM LTE_Param L LEFT JOIN LTE_Param L1 ON (L.LNBTSname = L1.LNBTSname)
WHERE L.LNCEL_id <> L1.LNCEL_id;
--
--
-- LNREL cosite missing
DROP TABLE IF EXISTS LNREL_COS_MISS;
CREATE TABLE LNREL_COS_MISS AS
SELECT DISTINCT
L.LNCELnameS, L.LNCELnameT, L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.Prefijo, L.BandaS, L.BandaT, L.earfcnDLS, L.earfcnDLT, L.PLMN_id, L.MRBTS_idS, L.LNBTS_idS, L.LNCEL_idS, L.MRBTS_idT, L.LNBTS_idT, L.LNCEL_idT, R.LNREL_id
FROM LNCEL_COSITE L LEFT JOIN LNREL_PAR1 R ON ((R.ecgiLcrId = L.lcrIdT) AND (R.ecgiAdjEnbId = L.MRBTS_idT))
WHERE R.LNREL_id IS NULL
ORDER BY L.Region DESC, L.LNCELnameS;
--
--
DROP TABLE IF EXISTS LNREL_PART_UNDFND;
CREATE TABLE LNREL_PART_UNDFND AS
SELECT DISTINCT
r.Cluster, r.Region, r.Depto, r.Mun, r.ClusterT, r.RegionT, r.DeptoT, r.MunT,
r.LNCELname,r.LNCELnameT,r.lcrId,r.lcrIdT,r.PLMN_id,r.PLMN_idT,r.Prefijo,r.MRBTS_id,r.LNBTS_id,r.LNCEL_id,r.LNREL_id,r.moVersion,r.mcc,r.mnc, r.amleAllowed,r.cellIndOffNeigh,r.cellIndOffNeighDelta,r.handoverAllowed,r.nrControl,r.nrStatus,r.removeAllowed,r.SBTS_id,r.name,r.LNBTSname,r.LNBTSnameT,r.MRBTS_idT,r.LNBTS_idT,r.LNCEL_idT,r.eutraCelId,r.PowerBoost,r.PCI,r.RSI,r.tac,r.eutraCelIdT,r.PowerBoostT,r.PCIT,r.RSIT,r.tacT,r.Estado,r.EstadoT,r.SameSite, r.SameSector,r.Banda, r.BandaT, r.Distance,r.bearing, r.bearback,r.ThetaAng,r.CoefCoOrient, r.Az, r.AzT
FROM LNREL_PAR1 r
WHERE (r.amleAllowed=0 AND r.SameSector=1 AND r.SameSite=1 AND r.CoefCoOrient < 30);
--
--
DROP TABLE IF EXISTS LNREL_PART_NOCOLOC;
CREATE TABLE LNREL_PART_NOCOLOC AS
SELECT DISTINCT
r.Cluster, r.Region, r.Depto, r.Mun, r.ClusterT, r.RegionT, r.DeptoT, r.MunT,
r.LNCELname,r.LNCELnameT,r.lcrId,r.lcrIdT,r.PLMN_id,r.PLMN_idT,r.Prefijo,r.MRBTS_id,r.LNBTS_id,r.LNCEL_id,r.LNREL_id,r.moVersion,r.mcc,r.mnc, r.amleAllowed,r.cellIndOffNeigh,r.cellIndOffNeighDelta,r.handoverAllowed,r.nrControl,r.nrStatus,r.removeAllowed,r.SBTS_id,r.name,r.LNBTSname,r.LNBTSnameT,r.MRBTS_idT,r.LNBTS_idT,r.LNCEL_idT,r.eutraCelId,r.PowerBoost,r.PCI,r.RSI,r.tac,r.eutraCelIdT,r.PowerBoostT,r.PCIT,r.RSIT,r.tacT,r.Estado,r.EstadoT,r.SameSite, r.SameSector,r.Banda, r.BandaT, r.Distance,r.bearing, r.bearback,r.ThetaAng,r.CoefCoOrient,r.Az ,r.AzT
FROM LNREL_PAR1 r
WHERE (r.amleAllowed=1 AND r.SameSector=1 AND r.SameSite=1 AND r.CoefCoOrient >30);
--
--
DROP TABLE IF EXISTS LNREL_PART_NOCOSITE;
CREATE TABLE LNREL_PART_NOCOSITE AS
SELECT DISTINCT
r.Cluster, r.Region, r.Depto, r.Mun, r.ClusterT, r.RegionT, r.DeptoT, r.MunT,
r.LNCELname,r.LNCELnameT,r.lcrId,r.lcrIdT,r.PLMN_id,r.PLMN_idT,r.Prefijo,r.MRBTS_id,r.LNBTS_id,r.LNCEL_id,r.LNREL_id,r.moVersion,r.mcc,r.mnc, r.amleAllowed,r.cellIndOffNeigh,r.cellIndOffNeighDelta,r.handoverAllowed,r.nrControl,r.nrStatus,r.removeAllowed,r.SBTS_id,r.name,r.LNBTSname,r.LNBTSnameT,r.MRBTS_idT,r.LNBTS_idT,r.LNCEL_idT,r.eutraCelId,r.PowerBoost,r.PCI,r.RSI,r.tac,r.eutraCelIdT,r.PowerBoostT,r.PCIT,r.RSIT,r.tacT,r.Estado,r.EstadoT,r.SameSite, r.SameSector,r.Banda, r.BandaT, r.Distance,r.bearing, r.bearback,r.ThetaAng,r.CoefCoOrient,r.Az ,r.AzT
FROM LNREL_PAR1 r
WHERE (r.amleAllowed=1 AND r.SameSite=0);
--
--
DROP TABLE IF EXISTS LNREL_PART_NOCOSCTR;
CREATE TABLE LNREL_PART_NOCOSCTR AS
SELECT DISTINCT
r.Cluster, r.Region, r.Depto, r.Mun, r.ClusterT, r.RegionT, r.DeptoT, r.MunT,
r.LNCELname,r.LNCELnameT,r.lcrId,r.lcrIdT,r.PLMN_id,r.PLMN_idT,r.Prefijo,r.MRBTS_id,r.LNBTS_id,r.LNCEL_id,r.LNREL_id,r.moVersion,r.mcc,r.mnc, r.amleAllowed,r.cellIndOffNeigh,r.cellIndOffNeighDelta,r.handoverAllowed,r.nrControl,r.nrStatus,r.removeAllowed,r.SBTS_id,r.name,r.LNBTSname,r.LNBTSnameT,r.MRBTS_idT,r.LNBTS_idT,r.LNCEL_idT,r.eutraCelId,r.PowerBoost,r.PCI,r.RSI,r.tac,r.eutraCelIdT,r.PowerBoostT,r.PCIT,r.RSIT,r.tacT,r.Estado,r.EstadoT,r.SameSite, r.SameSector,r.Banda, r.BandaT, r.Distance,r.bearing, r.bearback,r.ThetaAng,r.CoefCoOrient,r.Az ,r.AzT
FROM LNREL_PAR1 r
WHERE (r.amleAllowed=1 AND r.SameSector=0 AND r.SameSite=1);
--
--
--
--PCI_RSI queries
--
--PCI audit. coPCI and distance
--
DROP TABLE IF EXISTS PCI_DistT;
CREATE TABLE PCI_DistT AS
SELECT
L.Cluster, L.Region, L.Zona, L.Depto, L.Mun, L.Prefijo, L1.Cluster AS ClusterT, L1.Region AS RegionT, L1.Zona AS ZonaT, L1.Depto AS DeptoT, L1.Mun AS MunT, L1.Prefijo AS PrefijoT, (L.LNCELname || L.phyCellId) AS Key, L.LNCELname AS LNCELSRC, L1.LNCELname AS LNCELTGT, L.phyCellId, CASE WHEN (L.LNBTSName = L1.LNBTSName) THEN 1 ELSE 0 END AS SameSite, CASE WHEN (L.earfcnDL = L1.earfcnDL) THEN 1 ELSE 0 END AS SameCarrier, L.MRBTS_Id, L.LNBTS_Id, L.LNCEL_Id, (L.LNBTSName || substr(L.LNCELname,-1,1)) AS KeySecS, L1.MRBTS_Id AS MRBTSIdT, L1.LNBTS_Id AS LNBTSIdT, L1.LNCEL_Id AS LNCEL_IdT, (L1.LNBTSName || substr(L1.LNCELname,-1,1)) AS KeySecT, L.earfcnDL AS EARFCN_SRC, L1.earfcnDL AS EARFCN_TGT, L.LNBTSName AS LNBTSSrc, L1.LNBTSName AS LNBTSTgt, L.LNBTS_OpSt AS LNBTS_OpStS, L.LNCEL_AdSt AS LNCEL_AdStS ,L.LNCEL_OpSt AS LNCEL_OpStS, L1.LNBTS_OpSt AS LNBTS_OpStT, L1.LNCEL_AdSt AS LNCEL_AdStT, L1.LNCEL_OpSt AS LNCEL_OpStT,
ROUND (12756273.2 * ASIN(MIN (1 , SQRT(POWER( SIN(RADIANS(L.Latitud - L1.Latitud)/2) , 2) + COS(RADIANS(L.Latitud)) * COS(RADIANS(L1.Latitud)) * POWER ( SIN(RADIANS(L.Longitud - L1.Longitud)/2) , 2)))) , 0) AS Distance,
L.Latitud, L.Longitud, L1.Latitud AS LatitudT, L1.Longitud AS LongitudT, L.Az, L1.Az AS AzT
FROM lte_param AS L INNER JOIN lte_param AS L1 ON (L.phyCellId = L1.phyCellId)
WHERE ((CASE WHEN (L.earfcnDL = L1.earfcnDL) THEN 1 ELSE 0 END) = 1) AND ((CASE WHEN (L.LNCELname = L1.LNCELname) THEN 1 ELSE 0 END) = 0);
--
--shortest key distance
--
DROP TABLE IF EXISTS PCI_DistMin;
CREATE TABLE PCI_DistMin AS
SELECT
PCI_DistT.Key, Min(PCI_DistT.Distance) AS MinOfDistancia
FROM PCI_DistT
GROUP BY PCI_DistT.Key;
--
--Query final asociando parametros de vecino mas cercano
--
DROP TABLE IF EXISTS PCI_DistF;
CREATE TABLE PCI_DistF AS
SELECT
l.Cluster, l.ClusterT, l.Region, l.Zona, l.ZonaT, l.Depto, l.Mun, l.RegionT, l.DeptoT, l.MunT, l.Key,l.LNCELSRC,l.LNCELTGT,l.phyCellId,l.Distance,
ROUND (180/ACOS(-1)*ATAN2(
                          COS(RADIANS(l.LatitudT)) * SIN(RADIANS(l.LongitudT - l.Longitud)), COS(RADIANS(l.Latitud)) * SIN(RADIANS(l.LatitudT)) - SIN(RADIANS(l.Latitud)) * COS(RADIANS(l.LatitudT))*COS(RADIANS(l.LongitudT - l.Longitud))
                          ), 1) AS bearing,
ROUND (180/ACOS(-1)*ATAN2(
                         COS(RADIANS(l.Latitud)) * SIN(RADIANS(l.Longitud - l.LongitudT)), COS(RADIANS(l.LatitudT)) * SIN(RADIANS(l.Latitud)) - SIN(RADIANS(l.LatitudT)) * COS(RADIANS(l.Latitud))*COS(RADIANS(l.Longitud - l.LongitudT))
                         ), 1) AS bearback,
l.Az AS AzS, l.AzT, CASE WHEN (l.Az > 180) THEN (l.Az -360) ELSE l.Az END AS AzS1, CASE WHEN (l.AzT > 180) THEN (l.AzT -360) ELSE l.AzT END AS AzT1,
l.SameSite, l.SameCarrier, l.LNBTS_OpStS, l.LNCEL_AdStS ,l.LNCEL_OpStS, l.LNBTS_OpStT, l.LNCEL_AdStT, l.LNCEL_OpStT, l.MRBTS_id, l.LNBTS_id, l.LNCEL_id, l.KeySecS, l.MRBTSIdT, l.LNBTSIdT, l.LNCEL_IdT, l.KeySecT, l.EARFCN_SRC, l.EARFCN_TGT, l.LNBTSSrc, l.LNBTSTgt
FROM PCI_DistT AS l INNER JOIN PCI_DistMin as d ON (l.Distance = d.MinOfDistancia) AND (l.Key = d.Key)
ORDER BY l.Distance;
--
DROP TABLE IF EXISTS PCI_DistF1;
CREATE TABLE PCI_DistF1 AS
SELECT DISTINCT
l.Cluster, l.ClusterT, l.Region, l.Zona, l.ZonaT, l.Depto, l.Mun, l.RegionT, l.DeptoT, l.MunT, l.LNCELSRC,l.LNCELTGT,l.phyCellId,l.Distance,
CASE WHEN l.bearing < 0 THEN (360 + l.bearing) ELSE l.bearing END AS bearing,
CASE WHEN l.bearback < 0 THEN (360 + l.bearback) ELSE l.bearback END AS bearback,
ROUND(CASE WHEN(ABS(l.bearing - l.AzS1) > 180) THEN ABS(ABS(l.bearing - l.AzS1) - 360) ELSE (ABS(l.bearing - l.AzS1)) END +
      CASE WHEN(ABS(l.bearback - l.AzT1) > 180) THEN ABS(ABS(l.bearback - l.AzT1) - 360) ELSE (ABS(l.bearback - l.AzT1)) END ,1) AS ThetaAng,
CASE WHEN (ABS(l.AzS1-l.AzT1)> 180) THEN ABS(ABS(l.AzS1-l.AzT1)-360) ELSE (ABS(l.AzS1-l.AzT1)) END AS CoefCoOrient,
l.AzS, l.AzT, l.AzS1, l.AzT1,
l.SameSite, l.SameCarrier, l.LNBTS_OpStS, l.LNCEL_AdStS ,l.LNCEL_OpStS, l.LNBTS_OpStT, l.LNCEL_AdStT, l.LNCEL_OpStT, l.MRBTS_id, l.LNBTS_id, l.LNCEL_id, l.KeySecS, l.MRBTSIdT, l.LNBTSIdT, l.LNCEL_IdT, l.KeySecT, l.EARFCN_SRC, l.EARFCN_TGT, l.LNBTSSrc, l.LNBTSTgt
FROM PCI_DistF AS l
WHERE(l.Distance < 15000 AND l.LNCELTGT IS NOT NULL);
--
--
--
--RSI audit. coRSI and distance
--
DROP TABLE IF EXISTS RSI_DistT;
CREATE TABLE RSI_DistT AS
SELECT
L.Cluster, L.Region, L.Zona, L.Depto, L.Mun, L.Prefijo, L1.Cluster AS ClusterT, L1.Region AS RegionT, L1.Zona AS ZonaT, L1.Depto AS DeptoT, L1.Mun AS MunT, L1.Prefijo AS PrefijoT, (L.LNCELname || L.rootSeqIndex) AS Key, L.LNCELname AS LNCELSRC, L1.LNCELname AS LNCELTGT, L.rootSeqIndex, CASE WHEN (L.LNBTSName = L1.LNBTSName) THEN 1 ELSE 0 END AS SameSite, CASE WHEN (L.earfcnDL = L1.earfcnDL) THEN 1 ELSE 0 END AS SameCarrier, L.MRBTS_Id, L.LNBTS_Id, L.LNCEL_Id, (L.LNBTSName || substr(L.LNCELname,-1,1)) AS KeySecS, L1.MRBTS_Id AS MRBTSIdT, L1.LNBTS_Id AS LNBTSIdT, L1.LNCEL_Id AS LNCEL_IdT, (L1.LNBTSName || substr(L1.LNCELname,-1,1)) AS KeySecT, L.earfcnDL AS EARFCN_SRC, L1.earfcnDL AS EARFCN_TGT, L.LNBTSName AS LNBTSSrc, L1.LNBTSName AS LNBTSTgt, L.LNBTS_OpSt AS LNBTS_OpStS, L.LNCEL_AdSt AS LNCEL_AdStS ,L.LNCEL_OpSt AS LNCEL_OpStS, L1.LNBTS_OpSt AS LNBTS_OpStT, L1.LNCEL_AdSt AS LNCEL_AdStT, L1.LNCEL_OpSt AS LNCEL_OpStT,
ROUND (12756273.2 * ASIN(MIN (1 , SQRT(POWER( SIN(RADIANS(L.Latitud - L1.Latitud)/2) , 2) + COS(RADIANS(L.Latitud)) * COS(RADIANS(L1.Latitud)) * POWER ( SIN(RADIANS(L.Longitud - L1.Longitud)/2) , 2)))) , 0) AS Distance,
L.Latitud, L.Longitud, L1.Latitud AS LatitudT, L1.Longitud AS LongitudT, L.Az, L1.Az AS AzT
FROM lte_param AS L INNER JOIN lte_param AS L1 ON (L.rootSeqIndex = L1.rootSeqIndex)
WHERE ((CASE WHEN (L.earfcnDL = L1.earfcnDL) THEN 1 ELSE 0 END) = 1) AND ((CASE WHEN (L.LNCELname = L1.LNCELname) THEN 1 ELSE 0 END) = 0);
--
--shortest key distance
--
DROP TABLE IF EXISTS RSI_DistMin;
CREATE TABLE RSI_DistMin AS
SELECT
l.Key, Min(l.Distance) AS MinOfDistancia
FROM RSI_DistT AS l
GROUP BY l.Key;
--
DROP TABLE IF EXISTS RSI_DistF;
CREATE TABLE RSI_DistF AS
SELECT
l.Cluster, l.ClusterT, l.Region, l.Zona, l.ZonaT, l.Depto, l.Mun, l.RegionT, l.DeptoT, l.MunT, l.Key,l.LNCELSRC, l.LNCELTGT, L.rootSeqIndex, l.Distance,
ROUND (180/ACOS(-1)*ATAN2(
                          COS(RADIANS(l.LatitudT)) * SIN(RADIANS(l.LongitudT - l.Longitud)), COS(RADIANS(l.Latitud)) * SIN(RADIANS(l.LatitudT)) - SIN(RADIANS(l.Latitud)) * COS(RADIANS(l.LatitudT))*COS(RADIANS(l.LongitudT - l.Longitud))
                          ), 1) AS bearing,
ROUND (180/ACOS(-1)*ATAN2(
                         COS(RADIANS(l.Latitud)) * SIN(RADIANS(l.Longitud - l.LongitudT)), COS(RADIANS(l.LatitudT)) * SIN(RADIANS(l.Latitud)) - SIN(RADIANS(l.LatitudT)) * COS(RADIANS(l.Latitud))*COS(RADIANS(l.Longitud - l.LongitudT))
                         ), 1) AS bearback,
l.Az AS AzS, l.AzT, CASE WHEN (l.Az > 180) THEN (l.Az -360) ELSE l.Az END AS AzS1, CASE WHEN (l.AzT > 180) THEN (l.AzT -360) ELSE l.AzT END AS AzT1,
l.SameSite, l.SameCarrier, l.LNBTS_OpStS, l.LNCEL_AdStS ,l.LNCEL_OpStS, l.LNBTS_OpStT, l.LNCEL_AdStT, l.LNCEL_OpStT, l.MRBTS_id, l.LNBTS_id, l.LNCEL_id, l.KeySecS, l.MRBTSIdT, l.LNBTSIdT, l.LNCEL_IdT, l.KeySecT, l.EARFCN_SRC, l.EARFCN_TGT, l.LNBTSSrc, l.LNBTSTgt
FROM RSI_DistT AS l INNER JOIN RSI_DistMin as d ON (l.Distance = d.MinOfDistancia) AND (l.Key = d.Key)
ORDER BY l.Distance;
--
DROP TABLE IF EXISTS RSI_DistF1;
CREATE TABLE RSI_DistF1 AS
SELECT DISTINCT
l.Cluster, l.ClusterT, l.Region, l.Zona, l.ZonaT, l.Depto, l.Mun, l.RegionT, l.DeptoT, l.MunT, l.LNCELSRC, l.LNCELTGT, L.rootSeqIndex, l.Distance,
CASE WHEN l.bearing < 0 THEN (360 + l.bearing) ELSE l.bearing END AS bearing,
CASE WHEN l.bearback < 0 THEN (360 + l.bearback) ELSE l.bearback END AS bearback,
ROUND(CASE WHEN(ABS(l.bearing - l.AzS1) > 180) THEN ABS(ABS(l.bearing - l.AzS1) - 360) ELSE (ABS(l.bearing - l.AzS1)) END +
      CASE WHEN(ABS(l.bearback - l.AzT1) > 180) THEN ABS(ABS(l.bearback - l.AzT1) - 360) ELSE (ABS(l.bearback - l.AzT1)) END ,1) AS ThetaAng,
CASE WHEN (ABS(l.AzS1-l.AzT1)> 180) THEN ABS(ABS(l.AzS1-l.AzT1)-360) ELSE (ABS(l.AzS1-l.AzT1)) END AS CoefCoOrient,
l.AzS, l.AzT, l.AzS1, l.AzT1,
l.SameSite, l.SameCarrier, l.LNBTS_OpStS, l.LNCEL_AdStS ,l.LNCEL_OpStS, l.LNBTS_OpStT, l.LNCEL_AdStT, l.LNCEL_OpStT, l.MRBTS_id, l.LNBTS_id, l.LNCEL_id, l.KeySecS, l.MRBTSIdT, l.LNBTSIdT, l.LNCEL_IdT, l.KeySecT, l.EARFCN_SRC, l.EARFCN_TGT, l.LNBTSSrc, l.LNBTSTgt
FROM RSI_DistF AS l
WHERE(l.Distance < 10000 AND l.LNCELTGT IS NOT NULL);
--
--
DROP TABLE IF EXISTS PCI_DistT;
DROP TABLE IF EXISTS PCI_DistF;
DROP TABLE IF EXISTS RSI_DistT;
DROP TABLE IF EXISTS RSI_DistF;
--
--
--End of daily info
--
--
--031 parameters
--
DROP TABLE IF EXISTS T031_PAR_1;
CREATE TABLE T031_PAR_1 AS
SELECT
l.PLMN_Id, r."Source LNCEL name" AS LNCELS, l.Cluster, l.MRBTS_Id, l.LNBTS_Id, l.LNCEL_Id, r."Source MRBTS name", r."Source LNBTS name", (r.eci_id - (r.eci_id % 256))/256 AS MRBTS_IdT, (r.eci_id - (r.eci_id % 256))/256 AS LNBTS_IdT, (r.eci_id % 256) AS LcrIdT,
((r.eci_id - (r.eci_id % 256))/256)||(r.eci_id % 256) AS keyT,
1*r.mcc_id AS MCC, 1*r.mnc_id AS MNC, 1*r.eci_id AS ECI, 1*r."Adj Intra eNB HO PREP SR" AS IntraPrepSR, 1*r."Adj Intra eNB HO SR" AS IntraSR, 1*r."Intra eNB HO attempts per neighbor cell" AS IntraATT, 1*r."Intra eNB NB HO  cancel rate" AS IntraCancelR, 1*r."Adj Inter eNB HO Prep SR" AS InterPrepSR, 1*r."Adj Inter eNB HO SR" AS InterSR, 1*r."Number of Inter eNB Handover attempts per neighbor cell relationship" AS InterATT, 1*r."Inter eNB NB HO fail ratio" AS InterFR, 1*r."IFHO LB SR neigh" AS LBSR, 1*r."Number of inter-frequency load balancing handover attempts per neighbor cell relationship" AS LBATT, 1*r."Late HO R" AS LateHO, 1*r."Early HO type 1 R" AS EarlyHOtype1, 1*r."Early HO type 2 R" AS EarlyHOtype2, l.Latitud, l.Longitud
FROM RSLTE031 AS r INNER JOIN LTE_Param AS l ON (r."Source LNCEL name" = l.LNCELname);
--
--
DROP TABLE IF EXISTS T031_PAR_2;
CREATE TABLE T031_PAR_2 AS
SELECT
r.PLMN_Id, r.LNCELS, l.LNCELname AS LNCELT, r.Cluster, l.Cluster AS ClusterT, r.MRBTS_Id, r.LNBTS_Id, r.LNCEL_Id, r."Source MRBTS name", r."Source LNBTS name", r.MRBTS_IdT, r.LNBTS_IdT, l.LNCEL_Id AS LNCEL_IdT, r.LcrIdT, r.KeyT, l.LNBTSname AS LNBTST, r.MCC, r.MNC, r.ECI, r.IntraPrepSR, r.IntraSR, r.IntraATT, r.IntraCancelR, r.InterPrepSR, r.InterSR, r.InterATT, r.InterFR, r.LBSR, r.LBATT, r.LateHO, r.EarlyHOtype1, r.EarlyHOtype2,
ROUND (12756273.2 * ASIN(MIN (1 , SQRT(POWER( SIN(RADIANS(r.Latitud - l.Latitud)/2) , 2) + COS(RADIANS(r.Latitud)) * COS(RADIANS(l.Latitud)) * POWER ( SIN(RADIANS(r.Longitud - l.Longitud)/2) , 2)))) , 0) AS Distance
FROM T031_PAR_1 AS r INNER JOIN LTE_Param AS l ON (r.keyT = l.klcrid);
--
--
--
--
-- LNREL cross
--
DROP TABLE IF EXISTS T031_PAR_LNREL;
CREATE TABLE T031_PAR_LNREL AS
SELECT DISTINCT
l.PLMN_Id, l.LNCELS, l.LNCELT, l.IntraPrepSR, l.IntraSR, l.IntraATT, l.IntraCancelR, l.InterPrepSR, l.InterSR, l.InterATT, l.InterFR, l.LBSR ,l.LBATT, l.LateHO, l.EarlyHOtype1, l.EarlyHOtype2, l.Distance, r.MRBTS_id, r.LNBTS_id, r.LNCEL_id, r.LNREL_id, r.amleAllowed, r.handoverAllowed, r.removeAllowed, r.cellIndOffNeigh, r.cellIndOffNeighDelta, r.nrControl,r.nrStatus, r.SameSite, r.SameSector, r.Banda, r.BandaT, r.bearing,r.bearback,r.ThetaAng,r.CoefCoOrient,r.Az,r.AzT, r.Cluster, r.Region, r.Depto, r.Mun, r.ClusterT, r.RegionT, r.DeptoT, r.MunT, r.LNCELname, r.LNCELnameT, r.lcrId, r.lcrIdT, r.PLMN_id, r.PLMN_idT, r.Prefijo, l.Cluster,l.ClusterT,l.MRBTS_id,l.LNBTS_id,l.LNCEL_id,l."Source MRBTS name",l."Source LNBTS name", l.MRBTS_IdT, l.LNBTS_IdT, l.LNCEL_IdT, l.LcrIdT, l.LNBTST, l.MCC, l.MNC, l.ECI, r.moVersion,r.mcc,r.mnc,
r.SBTS_id,r.name,r.LNBTSname,r.LNBTSnameT,r.MRBTS_idT,r.LNBTS_idT,r.LNCEL_idT,r.eutraCelId,r.PowerBoost,r.PCI,r.RSI,r.tac,r.eutraCelIdT,r.PowerBoostT,r.PCIT,r.RSIT,r.tacT,r.Estado,r.EstadoT
FROM T031_PAR_2 AS l LEFT JOIN LNREL_PAR1 AS r ON (l.LNCELS = r.LNCELname) AND (l.MRBTS_IdT = r.MRBTS_idT) AND (l.LNBTS_IdT = r.LNBTS_idT) AND (l.LNCEL_IdT = r.LNCEL_IdT);
--
--
DROP TABLE IF EXISTS T031_PAR_LNREL_RA;
CREATE TABLE T031_PAR_LNREL_RA AS
SELECT *
FROM T031_PAR_LNREL AS l
WHERE l.IntraPrepSR IS NOT NULL;
--
--Inter info per Cluster
--
DROP TABLE IF EXISTS T031_PAR_LNREL_ER1;
CREATE TABLE T031_PAR_LNREL_ER1 AS
SELECT *
FROM T031_PAR_LNREL AS l
WHERE l.PLMN_Id = 'rc1' AND l.InterPrepSR IS NOT NULL;
--
DROP TABLE IF EXISTS T031_PAR_LNREL_ER2;
CREATE TABLE T031_PAR_LNREL_ER2 AS
SELECT *
FROM T031_PAR_LNREL AS l
WHERE l.PLMN_Id = 'rc2' AND l.InterPrepSR IS NOT NULL;
--
DROP TABLE IF EXISTS T031_PAR_LNREL_ER7;
CREATE TABLE T031_PAR_LNREL_ER7 AS
SELECT *
FROM T031_PAR_LNREL AS l
WHERE l.PLMN_Id = 'rc7' AND l.InterPrepSR IS NOT NULL;
--
DROP TABLE IF EXISTS T031_PAR_LNREL_ER8;
CREATE TABLE T031_PAR_LNREL_ER8 AS
SELECT *
FROM T031_PAR_LNREL AS l
WHERE l.PLMN_Id = 'rc8' AND l.InterPrepSR IS NOT NULL;
--
DROP TABLE IF EXISTS T031_PAR_LNREL_ER9;
CREATE TABLE T031_PAR_LNREL_ER9 AS
SELECT *
FROM T031_PAR_LNREL AS l
WHERE l.PLMN_Id = 'rc9' AND l.InterPrepSR IS NOT NULL;
--
DROP TABLE IF EXISTS T031_PAR_LNREL_ER10;
CREATE TABLE T031_PAR_LNREL_ER10 AS
SELECT *
FROM T031_PAR_LNREL AS l
WHERE l.PLMN_Id = 'rc10' AND l.InterPrepSR IS NOT NULL;
--
--
DROP TABLE IF EXISTS T031_PAR_1;
DROP TABLE IF EXISTS T031_PAR_2;
--
--
--ADJI info per Cluster
--
DROP TABLE IF EXISTS ADJI_1;
CREATE TABLE ADJI_1 AS
SELECT *
FROM adjicustom AS l
WHERE l.PLMN_Id = 'rc1';
--
DROP TABLE IF EXISTS ADJI_2;
CREATE TABLE ADJI_2 AS
SELECT *
FROM adjicustom AS l
WHERE l.PLMN_Id = 'rc2';
--
DROP TABLE IF EXISTS ADJI_7;
CREATE TABLE ADJI_7 AS
SELECT *
FROM adjicustom AS l
WHERE l.PLMN_Id = 'rc7';
--
DROP TABLE IF EXISTS ADJI_8;
CREATE TABLE ADJI_8 AS
SELECT *
FROM adjicustom AS l
WHERE l.PLMN_Id = 'rc8';
--
DROP TABLE IF EXISTS ADJI_9;
CREATE TABLE ADJI_9 AS
SELECT *
FROM adjicustom AS l
WHERE l.PLMN_Id = 'rc9';
--
DROP TABLE IF EXISTS ADJI_10;
CREATE TABLE ADJI_10 AS
SELECT *
FROM adjicustom AS l
WHERE l.PLMN_Id = 'rc10';
--
--
--ADJG info per Cluster
--
DROP TABLE IF EXISTS ADJG_1;
CREATE TABLE ADJG_1 AS
SELECT *
FROM ADJGcustom AS l
WHERE l.PLMN_Id = 'rc1';
--
DROP TABLE IF EXISTS ADJG_2;
CREATE TABLE ADJG_2 AS
SELECT *
FROM ADJGcustom AS l
WHERE l.PLMN_Id = 'rc2';
--
DROP TABLE IF EXISTS ADJG_7;
CREATE TABLE ADJG_7 AS
SELECT *
FROM ADJGcustom AS l
WHERE l.PLMN_Id = 'rc7';
--
DROP TABLE IF EXISTS ADJG_8;
CREATE TABLE ADJG_8 AS
SELECT *
FROM ADJGcustom AS l
WHERE l.PLMN_Id = 'rc8';
--
DROP TABLE IF EXISTS ADJG_9;
CREATE TABLE ADJG_9 AS
SELECT *
FROM ADJGcustom AS l
WHERE l.PLMN_Id = 'rc9';
--
DROP TABLE IF EXISTS ADJG_10;
CREATE TABLE ADJG_10 AS
SELECT *
FROM ADJGcustom AS l
WHERE l.PLMN_Id = 'rc10';
--
--ADJW info per Cluster
--
DROP TABLE IF EXISTS ADJW_1;
CREATE TABLE ADJW_1 AS
SELECT *
FROM adjwcustom AS l
WHERE l.PLMN_Id = 'rc1';
--
DROP TABLE IF EXISTS ADJW_2;
CREATE TABLE ADJW_2 AS
SELECT *
FROM adjwcustom AS l
WHERE l.PLMN_Id = 'rc2';
--
DROP TABLE IF EXISTS ADJW_7;
CREATE TABLE ADJW_7 AS
SELECT *
FROM adjwcustom AS l
WHERE l.PLMN_Id = 'rc7';
--
DROP TABLE IF EXISTS ADJW_8;
CREATE TABLE ADJW_8 AS
SELECT *
FROM adjwcustom AS l
WHERE l.PLMN_Id = 'rc8';
--
DROP TABLE IF EXISTS ADJW_9;
CREATE TABLE ADJW_9 AS
SELECT *
FROM adjwcustom AS l
WHERE l.PLMN_Id = 'rc9';
--
DROP TABLE IF EXISTS ADJW_10;
CREATE TABLE ADJW_10 AS
SELECT *
FROM adjwcustom AS l
WHERE l.PLMN_Id = 'rc10';
--
--
--
DROP TABLE IF EXISTS WNCELcustom;
CREATE TABLE WNCELcustom AS
SELECT
l.LNBTSname, l.Cluster, l.Region, l.Depto, l.Mun, l.Prefijo, l.PLMN_id, l.MRBTS_id,
W.WCELName, W.Banda, W.PLMN_id, W.Sector, W.WBTSName, W.RNCName, W.RNC_id, W.WBTS_id, W.WCEL_id, W.UARFCN,
n.moVersion, n.distName, n.PLMN_id, n.MRBTS_id, n.WNBTS_id, n.WNCEL_id, n.defaultCarrier, n.lCelwDN, n.maxCarrierPower, n.maxRxLevelDifference,
n.mimoType, n.vamEnabled, n.picPool, n.rxBandwidth, n.txBandwidth, n.siteTemplateName, n. filterCenterTx
FROM (WNCEL n LEFT JOIN LNBTS_Full l ON (n.PLMN_id = l.PLMN_id AND n.MRBTS_id = l.MRBTS_id))
LEFT JOIN WCEL_PARAM1 W ON (n.PLMN_id = W.PLMN_id AND n.WNCEL_id = W.WCEL_id)
;
--
--
--
--
-- 651 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD651V2;
CREATE TABLE ANRPRL_AUD651v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 651;
--
--651 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD651;
CREATE TABLE ANRPRL_AUD651 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell,
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 651 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L651 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD651v2 AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
-- 626 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD626V2;
CREATE TABLE ANRPRL_AUD626v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 626;
--
--626 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD626;
CREATE TABLE ANRPRL_AUD626 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id,A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell,
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 626 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L626 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD626v2 AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
-- 3075 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD3075V2;
CREATE TABLE ANRPRL_AUD3075v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 3075;
--
--3075 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD3075;
CREATE TABLE ANRPRL_AUD3075 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell,
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 3075 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L3075 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD3075v2 AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
-- 3225 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD3225V2;
CREATE TABLE ANRPRL_AUD3225v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 3225;
--
--3225 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD3225;
CREATE TABLE ANRPRL_AUD3225 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell,
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 3225 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L3225 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD3225v2 AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
-- 9560 sites with ANRPRL
DROP TABLE IF EXISTS ANRPRL_AUD9560V2;
CREATE TABLE ANRPRL_AUD9560v2 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq
FROM (LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS 9560;
--
--9560 sites with ANRPRL miss
DROP TABLE IF EXISTS ANRPRL_AUD9560;
CREATE TABLE ANRPRL_AUD9560 AS
SELECT DISTINCT
L.LNBTSname, L.Cluster, L.Region, L.Depto, L.Mun, L.PLMN_id, L.MRBTS_id, L.LNBTS_id, A.targetCarrierFreq,
1 AS actAlsoForUeBasedANR, -80 AS anrThresRSRPNbCell, -80 AS anrThresRSRPNbCellMobEv, -24 AS anrThresRSRQNbCell,
256 AS nrLimitInterFreq, 256 AS nrLimitIntraFreq, 9560 AS targetCarrierFreqN
FROM (LNCEL_Full AS L INNER JOIN Sites_L9560 AS S ON L.LNBTSname = S.LNBTSname) LEFT JOIN ANRPRL_AUD9560v2 AS A ON (L.PLMN_id = A.PLMN_id)
AND (L.MRBTS_id = A.MRBTS_id) AND (L.LNBTS_id = A.LNBTS_id)
WHERE A.targetCarrierFreq IS NULL;
--
--
DROP TABLE IF EXISTS ANRPRL_MISS_FULL;
CREATE TABLE ANRPRL_MISS_FULL AS
SELECT * FROM ANRPRL_AUD626
UNION ALL
SELECT * FROM ANRPRL_AUD651
UNION ALL
SELECT * FROM ANRPRL_AUD3225
UNION ALL
SELECT * FROM ANRPRL_AUD3075
UNION ALL
SELECT * FROM ANRPRL_AUD9560
ORDER BY
    LNBTS_id;
--
--
-- Combinations from missing tuples
--
DROP TABLE IF EXISTS ANRPRL1;
CREATE TABLE ANRPRL1 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 1 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell,
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL2;
CREATE TABLE ANRPRL2 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 2 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell,
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL3;
CREATE TABLE ANRPRL3 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 3 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell,
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL4;
CREATE TABLE ANRPRL4 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 4 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell,
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL5;
CREATE TABLE ANRPRL5 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 5 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell,
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL6;
CREATE TABLE ANRPRL6 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 6 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell,
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL7;
CREATE TABLE ANRPRL7 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 7 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell,
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
DROP TABLE IF EXISTS ANRPRL8;
CREATE TABLE ANRPRL8 AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, 8 AS ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell,
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_MISS_FULL AS B;
--
--
DROP TABLE IF EXISTS ANRPRL_COMB;
CREATE TABLE ANRPRL_COMB AS
SELECT * FROM ANRPRL1
UNION ALL
SELECT * FROM ANRPRL2
UNION ALL
SELECT * FROM ANRPRL3
UNION ALL
SELECT * FROM ANRPRL4
UNION ALL
SELECT * FROM ANRPRL5
UNION ALL
SELECT * FROM ANRPRL6
UNION ALL
SELECT * FROM ANRPRL7
UNION ALL
SELECT * FROM ANRPRL8
ORDER BY
    LNBTS_id, ANRPRL_Id;
--
--
-- Possible ids from not used in ANRPRL
--
DROP TABLE IF EXISTS ANRPRL_AVAIL;
CREATE TABLE ANRPRL_AVAIL AS
SELECT DISTINCT
B.LNBTSname, B.Cluster, B.Region, B.Depto, B.Mun, B.PLMN_id, B.MRBTS_id, B.ANRPRL_Id, B.LNBTS_id,
B.actAlsoForUeBasedANR, B.anrThresRSRPNbCell, B.anrThresRSRPNbCellMobEv, B.anrThresRSRQNbCell,
B.nrLimitInterFreq, B.nrLimitIntraFreq
FROM ANRPRL_COMB AS B LEFT JOIN ANRPRL AS A ON (B.PLMN_id = A.PLMN_id)
AND (B.MRBTS_id = A.MRBTS_id) AND (B.LNBTS_id = A.LNBTS_id) AND (B.ANRPRL_Id = A.ANRPRL_Id)
WHERE A.ANRPRL_id IS NULL
ORDER BY
    B.LNBTS_id;
--
--
--
-- ADJW combinations
DROP TABLE IF EXISTS ADJW_COMB;
CREATE TABLE ADJW_COMB AS
SELECT DISTINCT
b.BTSname, w.WCELName, b.Cluster, b.Region, b.Depto, b.Mun, b.Prefijo, b.PLMN_Id, b.bsc_Id, b.bcf_Id, b.bts_Id,
w.Banda, w.Sector, w.WBTSName, w.RNCName, w.RNC_id, w.WBTS_id, w.WCEL_id, w.SectorID, w.WCELName AS name, w.CellDN AS targetCellDN,
b.Sector, b.BSCname, b.BCFname, b.BandName,b.DistName, b.gsmPriority, b.utranQualRxLevelMargin, b.utranThresholdReselection,
b.timeHysteresis, b.qSearchI, b.qSearchP, b.fddQOffset, b.fddQMin, b.rxLevAccessMin, b.radioLinkTimeout, b.radioLinkTimeoutAmr,
b.msMaxDistInCallSetup, b.sector_ID, w.WCEL_id AS AdjwCId, 25 AS intSystemDaEcioThr, w.LAC, w.WCELMCC AS MCC, b.cellId AS SourceCI,
b.locationAreaIdLAC AS SourceLAC, b.adjwcounto,  w.Estado, b.BCF_AdSt, b.BTS_AdSt, w.WCELMNC AS MNC, 18 AS minEcnoThreshold,
0 AS reportingPriority, w.SAC, w.PriScrCode AS scramblingCode, 0 AS txDiversityInd, w.UARFCN
FROM BTS_PARAM b INNER JOIN WCEL_PARAM1 w ON b.BCFname = w.WBTSName COLLATE NOCASE
;
--
DROP TABLE IF EXISTS ADJW_Miss;
CREATE TABLE ADJW_Miss AS
SELECT DISTINCT
a.BTSname, a.WCELName, a.Cluster, a.Region, a.Depto, a.Mun, a.Prefijo, a.PLMN_Id, a.bsc_Id, a.bcf_Id, a.bts_Id,
a.Banda, a.UARFCN, a.Sector, a.WBTSName, a.RNCName, a.RNC_id, a.WBTS_id, a.WCEL_id, a.SectorID, a.name, a.targetCellDN,
a.Sector, a.BSCname, a.BCFname, a.BandName,a.DistName, a.gsmPriority, a.utranQualRxLevelMargin, a.utranThresholdReselection,
a.timeHysteresis, a.qSearchI, a.qSearchP, a.fddQOffset, a.fddQMin, a.rxLevAccessMin, a.radioLinkTimeout, a.radioLinkTimeoutAmr,
a.msMaxDistInCallSetup, a.sector_ID, a.AdjwCId, a.intSystemDaEcioThr, a.LAC, a.MCC, a.SourceCI,
a.SourceLAC, a.adjwcounto,  a.Estado, a.BCF_AdSt, a.BTS_AdSt, a.MNC, a.minEcnoThreshold,
a.reportingPriority, a.SAC, a.scramblingCode, a.txDiversityInd,
w.CellDN AS CellDN_found, w.ADJW_id
FROM ADJW_COMB a LEFT JOIN ADJWcustom w ON a.BSC_id = w.BSC_id AND a.BCF_id = w.BCF_id AND a.BTS_id = w.BTS_id AND a.targetCellDN = w.CellDN
WHERE w.ADJW_id IS NULL AND a.Estado = 1 AND a.BCF_AdSt = 1 AND a.BTS_AdSt = 1
ORDER BY a.Region DESC, a.BTSname;
--
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
