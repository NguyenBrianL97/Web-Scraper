ALTER TABLE team_standard_pitching CHANGE H H_ float(5);
ALTER TABLE team_standard_pitching CHANGE R R_ float(5);
ALTER TABLE team_standard_pitching CHANGE HR HR_ float(5);
ALTER TABLE team_standard_pitching CHANGE BB BB_ float(5);
ALTER TABLE team_standard_pitching CHANGE IBB IBB_ float(5);
ALTER TABLE team_standard_pitching CHANGE SO SO_ float(5);
ALTER TABLE team_standard_pitching CHANGE HBP HBP_ float(5);
ALTER TABLE team_standard_pitching CHANGE LOB LOB_ float(5);
ALTER TABLE team_standard_pitching ADD id INT PRIMARY KEY AUTO_INCREMENT;

CREATE TABLE combined_table AS 
  (SELECT
	TSP.id, TSB.Tm, TSB.RBI ,TSP.`ERA`, TSB.G,
            
	TSB.`#Bat`, TSB.`BatAge`, TSB.`R/G`, TSB.`PA`, TSB.`AB`, TSB.`R`, TSB.`H`, TSB.`2B`, TSB.`3B`, TSB.`HR`,
	TSB.`SB`, TSB.`CS`, TSB.`BB`, TSB.`SO`, TSB.`BA`, TSB.`OBP`, TSB.`SLG`, TSB.`OPS`, TSB.`OPS+`, TSB.`TB`,
	TSB.`GDP`, TSB.`HBP`, TSB.`SH`, TSB.`SF`, TSB.`IBB`, TSB.`LOB`,
            
	TSP.`#P`, TSP.Page, TSP.`RA/G`, TSP.`W`, TSP.`L`, TSP.`W-L%`,  TSP.`GS`,
	TSP.`GF`, TSP.`CG`, TSP.`tSho`, TSP.`cSho`, TSP.`SV`, TSP.`IP`, TSP.`H_`, TSP.`R_`, TSP.`ER`, TSP.`HR_`, TSP.`BB_`,
	TSP.`IBB_`, TSP.`SO_`, TSP.`HBP_`, TSP.`BK`, TSP.`WP`, TSP.`BF`, TSP.`ERA+`, TSP.`FIP`, TSP.`WHIP`, TSP.`H9`, 
	TSP.`HR9`, TSP.`BB9`, TSP.`SO9`, TSP.`SO/W`, TSP.`LOB_`
	FROM   team_standard_batting TSB LEFT JOIN team_standard_pitching TSP ON TSB.Tm = TSP.Tm
		UNION 
			SELECT  
            
            TSP.id, TSP.Tm, TSB.RBI ,TSP.`ERA`, TSB.G,
            
            TSB.`#Bat`, TSB.`BatAge`, TSB.`R/G`, TSB.`PA`, TSB.`AB`, TSB.`R`, TSB.`H`, TSB.`2B`, TSB.`3B`, TSB.`HR`,
            TSB.`SB`, TSB.`CS`, TSB.`BB`, TSB.`SO`, TSB.`BA`, TSB.`OBP`, TSB.`SLG`, TSB.`OPS`, TSB.`OPS+`, TSB.`TB`,
            TSB.`GDP`, TSB.`HBP`, TSB.`SH`, TSB.`SF`, TSB.`IBB`, TSB.`LOB`,
            
            TSP.`#P`, TSP.Page, TSP.`RA/G`, TSP.`W`, TSP.`L`, TSP.`W-L%`,  TSP.`GS`,
			TSP.`GF`, TSP.`CG`, TSP.`tSho`, TSP.`cSho`, TSP.`SV`, TSP.`IP`, TSP.`H_`, TSP.`R_`, TSP.`ER`, TSP.`HR_`, TSP.`BB_`,
			TSP.`IBB_`, TSP.`SO_`, TSP.`HBP_`, TSP.`BK`, TSP.`WP`, TSP.`BF`, TSP.`ERA+`, TSP.`FIP`, TSP.`WHIP`, TSP.`H9`, 
			TSP.`HR9`, TSP.`BB9`, TSP.`SO9`, TSP.`SO/W`, TSP.`LOB_`
			FROM   team_standard_batting TSB RIGHT JOIN team_standard_pitching TSP ON TSB.Tm = TSP.Tm) ORDER BY RBI DESC, ERA DESC;
DELETE FROM `team_standard_batting` WHERE `Tm` = "LgAvgTSB";
DELETE FROM `team_standard_batting` WHERE `Tm` = "TSBEx";
DELETE FROM `team_standard_pitching` WHERE `Tm` = "LgAvgTSP";
DELETE FROM `team_standard_pitching` WHERE `Tm` = "TSPEx";
ALTER TABLE team_standard_batting ADD id INT PRIMARY KEY AUTO_INCREMENT;
UPDATE combined_table SET id = null WHERE "LgAvgTSP" = Tm;
UPDATE combined_table SET id = null WHERE "TSPEx" = Tm;

Create table RBI_RANK AS
(SELECT Tm, id, RBI, DENSE_RANK() OVER (ORDER BY RBI) RBI_rank FROM team_standard_batting);
Create table ERA_RANK AS
(SELECT Tm, id, ERA, DENSE_RANK() OVER (ORDER BY ERA) ERA_rank FROM team_standard_pitching);
