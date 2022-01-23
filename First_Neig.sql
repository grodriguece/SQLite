DROP TABLE IF EXISTS FIRST_NEIG;
CREATE TABLE FIRST_NEIG AS
SELECT DISTINCT
r.PLMN_Id, r.Cluster, r.Region, r.Depto, r.Mun, r.ClusterT, r.RegionT, r.DeptoT, r.MunT, r.LNBTSname, r.LNBTSnameT, r.LNCELname, r.LNCELnameT,
MIN(r.Distance) AS FirstNeigDist, r.Banda, r.BandaT, r.bearing, r.bearback, r.ThetaAng, r.CoefCoOrient, r.Az, r.AzT
FROM T031_PAR_LNREL r
WHERE r.LNBTSname != r.LNBTSnameT AND r.LNBTSnameT NOT LIKE '%.IND %' COLLATE NOCASE AND r.Distance > 0 AND
(CASE WHEN (ABS(r.Az-r.bearing)> 180) THEN ABS(ABS(r.Az-r.bearing)-360) ELSE (ABS(r.Az-r.bearing)) END) < 45
GROUP BY r.PLMN_Id, r.LNCELname
;
