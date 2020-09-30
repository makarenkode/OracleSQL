DROP TABLE delays;
DROP TABLE routes_stations;
DROP TABLE seats_taken;
DROP TABLE seats;
DROP TABLE seat_types;
DROP TABLE departures;
DROP TABLE train_staff;
DROP TABLE routes;
DROP TABLE trains;
DROP TABLE stations;


CREATE TABLE stations(
	station_id NUMBER PRIMARY KEY,
	name CHARACTER(50) NOT NULL,
	
	CONSTRAINT stations_name_unique UNIQUE(name)
)


CREATE TABLE trains (
	train_id NUMBER PRIMARY KEY,
	category CHARACTER(5) NOT NULL,
	head_station_id NUMBER NOT NULL,
	
	CONSTRAINT trains_head_station_fkey FOREIGN KEY (head_station_id)
		REFERENCES stations (station_id)
		ON DELETE CASCADE
);

CREATE TABLE routes(
	route_id NUMBER PRIMARY KEY,
	name     CHARACTER(5) NOT NULL
);

CREATE TABLE routes_stations(
	route_station_id NUMBER PRIMARY KEY,
	route_id NUMBER NOT NULL,
	station_id NUMBER NOT NULL,
    station_order NUMBER NOT NULL CHECK(station_order > 0),
	
	CONSTRAINT routes_stations_route_fkey FOREIGN KEY (route_id)
		REFERENCES routes (route_id)
		ON DELETE CASCADE,
	
	CONSTRAINT routes_stations_station_fkey FOREIGN KEY (station_id)
		REFERENCES stations (station_id)
		ON DELETE CASCADE, 
		
	CONSTRAINT  routes_stations_route_station_unique UNIQUE(route_id, station_id),
	
	CONSTRAINT routes_stations_route_station_station_order_unique UNIQUE(route_id, station_id, station_order)
);

CREATE TABLE train_crew(
	stuff_id NUMBER PRIMARY KEY,
	name CHARACTER(255) NOT NULL,
	train_id NUMBER NOT NULL,
	post CHARACTER(50) NOT NULL,

	CONSTRAINT train_crew_train_fkey FOREIGN KEY (train_id)
		REFERENCES trains (train_id)
		ON DELETE CASCADE
);


CREATE TABLE departures (
	departure_id NUMBER PRIMARY KEY,
	train_id NUMBER NOT NULL,
	route_id NUMBER NOT NULL,
	start_date DATE NOT NULL,

	CONSTRAINT departures_train_fkey FOREIGN KEY (train_id)
		REFERENCES trains (train_id)
		ON DELETE CASCADE,
	
	CONSTRAINT departures_route_fkey FOREIGN KEY (route_id)
		REFERENCES routes (route_id)
		ON DELETE CASCADE
);

CREATE TABLE departures_stations(
    departure_id NUMBER NOT NULL,
    station_id NUMBER NOT NULL,
    arrive_dt INTERVAL DAY TO SECOND NOT NULL CHECK(arrive_dt >= INTERVAL '0' DAY),
	depart_dt INTERVAL DAY TO SECOND NOT NULL CHECK(depart_dt >= INTERVAL '0' DAY),
	delay_dt INTERVAL DAY TO SECOND DEFAULT INTERVAL '0 00:00:00' DAY TO SECOND NOT NULL  CHECK(delay_dt >= INTERVAL '0' DAY),
    
    CONSTRAINT departures_stations_departure_fkey FOREIGN KEY (departure_id)
		REFERENCES departures (departure_id)
		ON DELETE CASCADE,
	
	CONSTRAINT departures_stations_station_fkey FOREIGN KEY (station_id)
		REFERENCES stations (station_id)
		ON DELETE CASCADE,
        
    CONSTRAINT departures_stations_arrive_depart_check CHECK(depart_dt >= arrive_dt),
    
    CONSTRAINT departures_stations_departure_station_pk PRIMARY KEY(departure_id, station_id)
);

CREATE TABLE distances(
	begin_station_id NUMBER NOT NULL,
	end_station_id NUMBER NOT NULL,
	distance NUMBER NOT NULL CHECK(distance > 0),
	
	CONSTRAINT distances_begin_station_fk FOREIGN KEY (begin_station_id)
		REFERENCES stations(station_id)
		ON DELETE CASCADE,
		
	CONSTRAINT distances_end_station_fk FOREIGN KEY (end_station_id)
		REFERENCES stations(station_id)
		ON DELETE CASCADE,	
	
	CONSTRAINT distances_begin_station_end_station_pk  PRIMARY KEY(begin_station_id, end_station_id)
);


CREATE TABLE seat_types(
	seat_type_id NUMBER PRIMARY KEY,
	name CHARACTER(50) NOT NULL,

	CONSTRAINT seat_types_name_unique UNIQUE(name)
);

CREATE TABLE seats(
	train_id NUMBER NOT NULL,
	seat_type_id NUMBER NOT NULL,
	num NUMBER NOT NULL CHECK( num >= 0),

	CONSTRAINT seats_train_fkey FOREIGN KEY (train_id)
		REFERENCES trains (train_id)
		ON DELETE CASCADE,

    CONSTRAINT seats_seat_type_fkey FOREIGN KEY (seat_type_id)
		REFERENCES seat_types (seat_type_id)
		ON DELETE CASCADE,

	CONSTRAINT seats_pkey PRIMARY KEY (train_id, seat_type_id)
);

CREATE TABLE seats_taken(
	departure_id NUMBER NOT NULL,
	seat_type_id NUMBER NOT NULL,
	station_id NUMBER NOT NULL,
	taken NUMBER NOT NULL CHECK( taken >= 0),

	CONSTRAINT seats_taken_departure_fkey FOREIGN KEY (departure_id)
		REFERENCES departures (departure_id)
		ON DELETE CASCADE,

	CONSTRAINT seats_taken_seat_type_fkey FOREIGN KEY (seat_type_id)
		REFERENCES seat_types (seat_type_id)
		ON DELETE CASCADE,
    
    CONSTRAINT seats_taken_station_fkey FOREIGN KEY (station_id)
		REFERENCES stations (station_id)
		ON DELETE CASCADE,

	CONSTRAINT seats_taken_pkey PRIMARY KEY (departure_id, seat_type_id, station_id)
);

CREATE TABLE trans_routes(
	trans_route_id NUMBER PRIMARY KEY,
	start_route_id NUMBER NOT NULL,
	end_route_id NUMBER NOT NULL,
	intersec_station_id NUMBER NOT NULL,

	CONSTRAINT trans_routes_start_route_fkey FOREIGN KEY (start_route_id)
		REFERENCES routes (route_id)
		ON DELETE CASCADE,
		
	CONSTRAINT trans_routes_end_route_fkey FOREIGN KEY (end_route_id)
		REFERENCES routes (route_id)
		ON DELETE CASCADE,

	CONSTRAINT delays_routes_intersec_station_fkey FOREIGN KEY (intersec_station_id)
		REFERENCES stations (station_id)
		ON DELETE CASCADE
);




INSERT ALL
	INTO stations VALUES(1, 'Москва')
	INTO stations VALUES(2, 'Абакан')
	INTO stations VALUES(3, 'Новосибирск')
	INTO stations VALUES(4, 'Красноярск')
	INTO stations VALUES(5, 'Пермь')
	INTO stations VALUES(6, 'Тюмень')
	INTO stations VALUES(7, 'Омск')
	INTO stations VALUES(8, 'Иркутск')
	INTO stations VALUES(9, 'Владивосток')
	INTO stations VALUES(10, 'Екатеринбург')
    INTO stations VALUES(11, 'Барнаул')
SELECT * FROM DUAL;


INSERT ALL
	INTO trains VALUES(1, '701', 1)
	INTO trains VALUES(2, '701', 2)
	INTO trains VALUES(3, '702', 2)
	INTO trains VALUES(4, '702', 3)
SELECT * FROM DUAL;

INSERT ALL
	INTO seat_types VALUES(1, 'Купе')
	INTO seat_types VALUES(2, 'Плацкарт')
	INTO seat_types VALUES(3, 'Общий')
	INTO seat_types VALUES(4, 'Первый класс')
SELECT * FROM DUAL;

INSERT ALL
	INTO routes VALUES(1, '100Э')
	INTO routes VALUES(2, '067Ы')
	INTO routes VALUES(3, '077Ы')
	INTO routes VALUES(4, '106Ы')
SELECT * FROM DUAL;
INSERT ALL
	INTO routes_stations VALUES(1, 1, 1, 1)
	INTO routes_stations VALUES(2, 1, 5, 2)
	INTO routes_stations VALUES(3, 1, 6, 3)
	INTO routes_stations VALUES(4, 1, 7, 4)
	INTO routes_stations VALUES(5, 1, 3, 5)
	INTO routes_stations VALUES(6, 1, 4, 6)
	INTO routes_stations VALUES(7, 1, 8, 7)
	INTO routes_stations VALUES(8, 1, 9, 8)

	INTO routes_stations VALUES(9,  2, 2,  1)
	INTO routes_stations VALUES(10, 2, 3, 2)
	INTO routes_stations VALUES(11, 2, 7, 3)
	INTO routes_stations VALUES(12, 2, 6,  4)
	INTO routes_stations VALUES(13, 2, 10, 5)
	INTO routes_stations VALUES(14, 2, 5,  6)
	INTO routes_stations VALUES(15, 2, 1,  7)
    
	INTO routes_stations VALUES(16, 3, 2,  1)
	INTO routes_stations VALUES(17, 3, 11, 2)
	INTO routes_stations VALUES(18, 3, 7,  3)
	INTO routes_stations VALUES(19, 3, 6,  4)
	INTO routes_stations VALUES(20, 3, 5,  5)
	INTO routes_stations VALUES(21, 3, 1,  6)

	INTO routes_stations VALUES(22, 4, 3, 1)
	INTO routes_stations VALUES(23, 4, 4, 2)
SELECT * FROM DUAL;


INSERT ALL
	INTO departures VALUES (1, 1, 1, TO_DATE('2019/12/20', 'yyyy/mm/dd'))
	INTO departures VALUES (2, 1, 1, TO_DATE('2020/01/03', 'yyyy/mm/dd'))
	INTO departures VALUES (3, 2, 2, TO_DATE('2019/12/23', 'yyyy/mm/dd'))
	INTO departures VALUES (4, 3, 3, TO_DATE('2019/12/24', 'yyyy/mm/dd'))
	INTO departures VALUES (5, 4, 4, TO_DATE('2019/12/24', 'yyyy/mm/dd'))
SELECT * FROM DUAL;

INSERT ALL
    INTO departures_stations VALUES(1, 1, INTERVAL '0 00:35:00' DAY TO SECOND, INTERVAL '0 00:35:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(1, 5, INTERVAL '1 03:21:00' DAY TO SECOND, INTERVAL '1 04:17:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(1, 6, INTERVAL '1 15:13:00' DAY TO SECOND, INTERVAL '1 15:33:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(1, 7, INTERVAL '1 23:15:00' DAY TO SECOND, INTERVAL '1 23:31:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(1, 3, INTERVAL '2 07:55:00' DAY TO SECOND, INTERVAL '2 08:53:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(1, 4, INTERVAL '2 21:25:00' DAY TO SECOND, INTERVAL '2 21:55:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(1, 8, INTERVAL '3 16:15:00' DAY TO SECOND, INTERVAL '3 16:55:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(1, 9, INTERVAL '6 23:06:00' DAY TO SECOND, INTERVAL '6 23:06:00' DAY TO SECOND, DEFAULT)
    
    INTO departures_stations VALUES(2, 1, INTERVAL '0 00:35:00' DAY TO SECOND, INTERVAL '0 00:35:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(2, 5, INTERVAL '1 03:21:00' DAY TO SECOND, INTERVAL '1 04:17:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(2, 6, INTERVAL '1 15:13:00' DAY TO SECOND, INTERVAL '1 15:33:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(2, 7, INTERVAL '1 23:15:00' DAY TO SECOND, INTERVAL '1 23:31:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(2, 3, INTERVAL '2 07:55:00' DAY TO SECOND, INTERVAL '2 08:53:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(2, 4, INTERVAL '2 21:25:00' DAY TO SECOND, INTERVAL '2 21:55:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(2, 8, INTERVAL '3 16:15:00' DAY TO SECOND, INTERVAL '3 16:55:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(2, 9, INTERVAL '6 23:06:00' DAY TO SECOND, INTERVAL '6 23:06:00' DAY TO SECOND, DEFAULT)
    
    INTO departures_stations VALUES(3, 2,  INTERVAL '0 14:20:00' DAY TO SECOND, INTERVAL '0 14:20:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(3, 3,  INTERVAL '1 12:15:00' DAY TO SECOND, INTERVAL '1 13:00:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(3, 7,  INTERVAL '2 21:19:00' DAY TO SECOND, INTERVAL '2 21:47:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(3, 6,  INTERVAL '3 04:48:00' DAY TO SECOND, INTERVAL '3 05:08:00' DAY TO SECOND, INTERVAL '0 00:35:00' DAY TO SECOND)
    INTO departures_stations VALUES(3, 10, INTERVAL '3 10:59:00' DAY TO SECOND, INTERVAL '3 11:41:00' DAY TO SECOND, INTERVAL '0 00:20:00' DAY TO SECOND)
    INTO departures_stations VALUES(3, 5,  INTERVAL '3 17:20:00' DAY TO SECOND, INTERVAL '3 17:40:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(3, 1,  INTERVAL '4 16:58:00' DAY TO SECOND, INTERVAL '4 16:58:00' DAY TO SECOND, DEFAULT)
    
    INTO departures_stations VALUES(4, 2,  INTERVAL '0 21:15:00' DAY TO SECOND, INTERVAL '0 21:15:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(4, 11, INTERVAL '1 12:53:00' DAY TO SECOND, INTERVAL '1 13:56:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(4, 7,  INTERVAL '2 00:29:00' DAY TO SECOND, INTERVAL '2 00:47:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(4, 6,  INTERVAL '2 06:48:00' DAY TO SECOND, INTERVAL '2 07:08:00' DAY TO SECOND, INTERVAL '0 00:20:00' DAY TO SECOND)
    INTO departures_stations VALUES(4, 5,  INTERVAL '2 19:20:00' DAY TO SECOND, INTERVAL '2 19:40:00' DAY TO SECOND, INTERVAL '0 00:05:00' DAY TO SECOND)
    INTO departures_stations VALUES(4, 1,  INTERVAL '3 16:58:00' DAY TO SECOND, INTERVAL '3 16:58:00' DAY TO SECOND, DEFAULT)
    
    INTO departures_stations VALUES(5, 3, INTERVAL '0 19:55:00' DAY TO SECOND, INTERVAL '0 19:55:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(5, 4, INTERVAL '1 07:55:00' DAY TO SECOND, INTERVAL '1 07:55:00' DAY TO SECOND, DEFAULT)
SELECT * FROM DUAL;

INSERT ALL
	INTO distances VALUES(5,	1,	1437)
	INTO distances VALUES(7,	3,	627)
	INTO distances VALUES(2,	3,	1037)
	INTO distances VALUES(3,	4,	762)
	INTO distances VALUES(10,	5,	381)
	INTO distances VALUES(6,	5,	707)
	INTO distances VALUES(1,	5,	1438)
	INTO distances VALUES(7,	6,	572)
	INTO distances VALUES(5,	6,	707)
	INTO distances VALUES(6,	7,	572)
	INTO distances VALUES(3,	7,	627)
	INTO distances VALUES(11,	7,	836)
	INTO distances VALUES(4,	8,	1088)
	INTO distances VALUES(8,	9,	4106)
	INTO distances VALUES(6,	10, 326)
	INTO distances VALUES(2,	11, 696)
SELECT * FROM DUAL;

INSERT ALL
	INTO seats VALUES(1, 1, 5)
	INTO seats VALUES(1, 2, 10)
	INTO seats VALUES(1, 3, 20)
	INTO seats VALUES(1, 4, 3)
	
	INTO seats VALUES(2, 1, 3)
	INTO seats VALUES(2, 2, 15)
	INTO seats VALUES(2, 3, 20)
	INTO seats VALUES(2, 4, 4)
	
	INTO seats VALUES(3, 1, 2)
	INTO seats VALUES(3, 2, 8)
	INTO seats VALUES(3, 3, 25)
	INTO seats VALUES(3, 4, 2)
	
	INTO seats VALUES(4, 1, 0)
	INTO seats VALUES(4, 2, 0)
	INTO seats VALUES(4, 3, 40)
	INTO seats VALUES(4, 4, 0)
SELECT * FROM DUAL;

INSERT ALL

	INTO seats_taken VALUES(1, 1, 1, 5)
	INTO seats_taken VALUES(1, 2, 1, 10)
	INTO seats_taken VALUES(1, 3, 1, 19)
	INTO seats_taken VALUES(1, 4, 1, 3)

	INTO seats_taken VALUES(1, 1, 4, 5)
	INTO seats_taken VALUES(1, 2, 4, 9)
	INTO seats_taken VALUES(1, 3, 4, 20)
	INTO seats_taken VALUES(1, 4, 4, 3)
    
	INTO seats_taken VALUES(2, 1, 1, 2)
	INTO seats_taken VALUES(2, 2, 1, 10)
	INTO seats_taken VALUES(2, 3, 1, 15)
	INTO seats_taken VALUES(2, 4, 1, 0)
    
    INTO seats_taken VALUES(2, 1, 7, 4)
	INTO seats_taken VALUES(2, 2, 7, 10)
	INTO seats_taken VALUES(2, 3, 7, 20)
	INTO seats_taken VALUES(2, 4, 7, 2)
    
	INTO seats_taken VALUES(3, 1, 3, 3)
	INTO seats_taken VALUES(3, 2, 3, 10)
	INTO seats_taken VALUES(3, 3, 3, 15)
	INTO seats_taken VALUES(3, 4, 3, 0)
	
	INTO seats_taken VALUES(4, 1, 11, 1)
	INTO seats_taken VALUES(4, 2, 11, 7)
	INTO seats_taken VALUES(4, 3, 11, 25)
	INTO seats_taken VALUES(4, 4, 11, 1)
SELECT * FROM DUAL;

INSERT INTO trans_routes VALUES (1, 2, 1, 7);


-----------------------------1-------------------------------------
WITH 
stats AS
(
    SELECT		dep.start_date dat,
				COUNT(DISTINCT dep.departure_id) d,
				SUM(COALESCE(st.taken,0)) t,
				SUM(COALESCE(st.taken,0)*COALESCE(dist.distance, 0)) pkm
    FROM departures dep 
	INNER JOIN seats_taken st ON dep.departure_id=st.departure_id
	INNER JOIN routes_stations rs1 ON rs1.route_id=dep.route_id AND st.station_id=rs1.station_id
	INNER JOIN routes_stations rs2 ON rs1.route_id=rs2.route_id AND rs1.station_order + 1 = rs2.station_order
	INNER JOIN distances dist ON dist.begin_station_id=rs1.station_id AND dist.end_station_id=rs2.station_id
	GROUP BY dep.start_date
),
reportDate AS 
(
    SELECT  TO_DATE('2019/12/21', 'yyyy/mm/dd') rd
    FROM DUAL
),
dates as 
(
    SELECT dep.start_date dat,
           CEIL(EXTRACT(MONTH FROM (dep.start_date))/3) quartal,
           EXTRACT(YEAR FROM dep.start_date) year
    FROM departures dep
    WHERE dep.start_date BETWEEN (SELECT rd.rd FROM reportDate rd) AND (SELECT SYSDATE FROM DUAL)
),
resultDatesStat AS 
(
    SELECT		da.dat dat,
				da.quartal quartal,
				da.year year,
				COALESCE(ds.d, 0) resultDeparts,
				COALESCE(ds.t, 0) resultPassengers,
				COALESCE(ds.pkm, 0) resultPassengersKM
    FROM dates da
    INNER JOIN stats ds ON ds.dat=da.dat
)
SELECT		DECODE
				(
					grouping(rds.dat) + grouping(rds.quartal) + grouping(rds.year), 
					0, TO_CHAR(rds.dat),
					1, 'Q' || rds.quartal || ' ' || rds.year,
					2,  rds.year || ' (total)',
					3, 'TOTAL',
					rds.dat
				) dates,
				SUM(rds.resultDeparts) departs,
				SUM(rds.resultPassengers) passengers,
				SUM(rds.resultPassengersKM) passengerKM
FROM	resultDatesStat rds
GROUP BY ROLLUP(rds.year, rds.quartal, rds.dat);

-----------------------------1-------------------------------------

-----------------------------2-------------------------------------

CREATE OR REPLACE TYPE report_table_record AS OBJECT (
	dat VARCHAR2(20),
	departs NUMBER,
	passengers NUMBER,
	passengersKM NUMBER
);

CREATE OR REPLACE TYPE report_table AS TABLE OF report_table_record;

CREATE OR REPLACE FUNCTION isQuartalEnd(inDate DATE) RETURN BOOLEAN
IS
BEGIN
    RETURN ((TRUNC(ADD_MONTHS(inDate, 3), 'Q') - 1) = inDate);
END;

CREATE OR REPLACE FUNCTION isYearEnd(inDate DATE) RETURN BOOLEAN
IS
BEGIN
    RETURN ((TRUNC(ADD_MONTHS(inDate, 12), 'Y') - 1) = inDate);
END;

CREATE OR REPLACE FUNCTION getReport(start_date DATE) 
RETURN report_table PIPELINED
IS
	TYPE GenericCursor IS REF CURSOR;
	c1 GenericCursor;

	tmp_record report_table_record;
	TYPE subreport_table_record IS RECORD 
	(
		dat DATE, 
		departs NUMBER,
		passengers NUMBER,
		passengersKM NUMBER
	);
	TYPE subreport_table IS TABLE OF subreport_table_record INDEX BY BINARY_INTEGER;
	subrecord_t subreport_table;
	tmp_subreport_record subreport_table_record;
	quartal_record report_table_record;-- := report_table_record('', 0, 0, 0);
	year_record report_table_record;-- := report_table_record('', 0, 0, 0);
	curr_date DATE := start_date;
BEGIN
	OPEN c1 FOR		SELECT		dep.start_date dat,
								COUNT(DISTINCT dep.departure_id) departs,
								SUM(COALESCE(st.taken,0)) passengers,
								SUM(COALESCE(st.taken,0)*COALESCE(dist.distance, 0)) passengersKM
					FROM departures dep 
					INNER JOIN seats_taken st ON dep.departure_id=st.departure_id
					INNER JOIN routes_stations rs1 ON rs1.route_id=dep.route_id AND st.station_id=rs1.station_id
					INNER JOIN routes_stations rs2 ON rs1.route_id=rs2.route_id AND rs1.station_order + 1 = rs2.station_order
					INNER JOIN distances dist ON dist.begin_station_id=rs1.station_id AND dist.end_station_id=rs2.station_id
					GROUP BY dep.start_date
					ORDER BY dep.start_date;
		FETCH c1 BULK COLLECT INTO subrecord_t;
	CLOSE c1;
	
	quartal_record := report_table_record('', 0, 0, 0);
	year_record := report_table_record('', 0, 0, 0);
	tmp_record :=  report_table_record('', 0, 0, 0);
	
	FOR i IN 1..subrecord_t.COUNT
	LOOP
		tmp_subreport_record := subrecord_t(i);
		WHILE tmp_subreport_record.dat >= curr_date AND curr_date <= SYSDATE
		LOOP
			IF tmp_subreport_record.dat = curr_date THEN
				tmp_record.departs := tmp_subreport_record.departs;
				tmp_record.passengers := tmp_subreport_record.passengers;
				tmp_record.passengersKM := tmp_subreport_record.passengersKM;
				
				tmp_record.dat := TO_CHAR(curr_date);
				quartal_record.departs := quartal_record.departs + tmp_record.departs;
				quartal_record.passengers := quartal_record.passengers + tmp_record.passengers;
				quartal_record.passengersKM := quartal_record.passengersKM + tmp_record.passengersKM;
                pipe row(tmp_record);
			END IF;

			tmp_record := report_table_record('', 0, 0, 0);
			IF isQuartalEnd(curr_date) THEN
				quartal_record.dat := 'Q' || ceil((EXTRACT(MONTH FROM curr_date))/3) || ' ' || EXTRACT(YEAR FROM curr_date);
				pipe row(quartal_record);
				year_record.departs := year_record.departs + quartal_record.departs;
				year_record.passengers := year_record.passengers + quartal_record.passengers;
				year_record.passengersKM := year_record.passengersKM + quartal_record.passengersKM;
				quartal_record := report_table_record('', 0, 0, 0); 
				IF isYearEnd(curr_date) THEN
					year_record.dat := EXTRACT(YEAR FROM curr_date) || ' (total)';
					pipe row(year_record);
					year_record :=  report_table_record('', 0, 0, 0);
				END IF;
			END IF;			
			
			curr_date := curr_date + 1;
		END LOOP;
	END LOOP;
	
	
	
	curr_date := curr_date - 1;
	
	IF NOT isQuartalEnd(curr_date) THEN
		quartal_record.dat := 'Q' || ceil((EXTRACT(MONTH FROM curr_date))/3) || ' ' || EXTRACT(YEAR FROM curr_date);
		pipe row(quartal_record);
		
		year_record.departs := year_record.departs + quartal_record.departs;
		year_record.passengers := year_record.passengers + quartal_record.passengers;
		year_record.passengersKM := year_record.passengersKM + quartal_record.passengersKM;
	END IF;
	IF NOT isYearEnd(curr_date) THEN
			year_record.dat := EXTRACT(YEAR FROM curr_date) || ' (total)';
			pipe row(year_record);
	END IF;
END getReport;

SELECT * FROM table(getReport(TO_DATE('2019/12/19','yyyy/mm/dd')));

-----------------------------------------------2------------------------------------------------------

-----------------------------------------------3------------------------------------------------------

CREATE OR REPLACE PROCEDURE updateArrival(dat IN DATE) IS
	CURSOR c1 IS    SELECT		ds.arrive_dt,
								ds.depart_dt,
								ds.delay_dt
					FROM departures dep
					INNER JOIN departures_stations ds ON ds.departure_id=dep.departure_id
					WHERE 	ds.arrive_dt + dep.start_date >= dat 
						AND 	ds.arrive_dt + dep.start_date < dat + 1
						AND 	ds.delay_dt > INTERVAL '0 00:00:00' DAY TO SECOND
					FOR UPDATE OF ds.arrive_dt, ds.depart_dt, ds.delay_dt;
					
	TYPE temp_rec IS RECORD 
	(
		arrive_dt INTERVAL DAY TO SECOND,
		depart_dt INTERVAL DAY TO SECOND,
		delay_dt INTERVAL DAY TO SECOND
	);
	rec temp_rec;
	
BEGIN
	OPEN c1;
	LOOP
		FETCH c1 INTO rec;
		IF c1%NOTFOUND THEN EXIT;
		END IF;
		UPDATE departures_stations ds
		SET	ds.arrive_dt=rec.arrive_dt + rec.delay_dt,
			ds.depart_dt=rec.depart_dt + rec.delay_dt,
			ds.delay_dt=DEFAULT
		WHERE CURRENT OF c1;
	END LOOP;
	CLOSE c1;
END updateArrival;

BEGIN
	updateArrival(TO_DATE('2019/12/26', 'yyyy/mm/dd'));
END;


------------------------For example--------------------------------------------
UPDATE	departures_stations ds 
SET	ds.arrive_dt=INTERVAL '2 06:48:00' DAY TO SECOND,
		ds.depart_dt=INTERVAL '2 07:08:00' DAY TO SECOND,
		ds.delay_dt= INTERVAL '0 00:20:00' DAY TO SECOND
WHERE ds.departure_id=4 AND ds.station_id = 6;
-----------------------------------------------3-----------------------------------------------------------

-----------------------------------------------Task_2------------------------------------------------------

DROP TRIGGER checkingTimetable;

CREATE OR REPLACE TRIGGER checkTimetable
AFTER INSERT ON departures_stations
FOR EACH ROW
DECLARE
	invalid_id EXCEPTION;
	quantity NUMBER;
BEGIN
	SELECT COUNT(*) INTO quantity
	FROM departures dep
	INNER JOIN routes_stations rs ON rs.route_id=dep.route_id
	WHERE rs.station_id = :new.station_id
		AND dep.departure_id = :new.departure_id;
		
	IF quantity = 0
	THEN	RAISE invalid_id;
	END IF;
END;
---------------------------------------------For example--------------------------------------------
INSERT INTO departures_stations VALUES(4, 3,  INTERVAL '4 16:58:00' DAY TO SECOND, INTERVAL '4 16:58:00' DAY TO SECOND, DEFAULT);

DELETE FROM departures_stations ds WHERE ds.departure_id=4 AND ds.station_id=3;
-------------------------------------------------------------1---------------------------------------------------------------------------

----------------------------------------------------------------2------------------------------------------------------------------------
CREATE OR REPLACE TRIGGER DepStationBI
BEFORE INSERT ON departures_stations
FOR EACH ROW
DECLARE
	cur_route_id NUMBER;
	prev_station_id NUMBER;
	cur_station_route_order NUMBER;
	prev_station_depart_dt  INTERVAL DAY TO SECOND;
	
	new_depart_dt INTERVAL DAY TO SECOND := NULL;
	new_arrive_dt INTERVAL DAY TO SECOND := NULL;
	
PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
	SELECT dep.route_id
	INTO cur_route_id
	FROM departures dep
	WHERE dep.departure_id=:new.departure_id;
	
	SELECT rs.station_order
	INTO cur_station_route_order
	FROM routes_stations rs
	WHERE rs.station_id=:new.station_id AND rs.route_id=cur_route_id;
	
	IF cur_station_route_order > 1 
	THEN
		SELECT	rs.station_id
		INTO prev_station_id
		FROM routes_stations rs
		WHERE rs.route_id=cur_route_id AND rs.station_order=cur_station_route_order - 1; 
		
		
		SELECT ds.depart_dt
		INTO prev_station_depart_dt
		FROM departures_stations ds
		INNER JOIN departures dep ON ds.departure_id=dep.departure_id AND dep.route_id=cur_route_id
		WHERE ds.station_id=prev_station_id;
		
		IF prev_station_depart_dt IS NOT NULL
		THEN
			IF	prev_station_depart_dt > :new.arrive_dt
			THEN			
			
				SELECT	ds.arrive_dt,
						ds.depart_dt
				INTO	new_arrive_dt,
						new_depart_dt
				FROM departures_stations ds
				INNER JOIN departures dep ON ds.departure_id=dep.departure_id AND dep.route_id=cur_route_id
				WHERE ds.station_id=:new.station_id;
				
				IF new_arrive_dt IS NULL OR new_depart_dt IS NULL
				THEN
					new_arrive_dt := prev_station_depart_dt + INTERVAL '0 10:00:00' DAY TO SECOND;
					new_depart_dt := new_arrive_dt + INTERVAL '0 00:05:00' DAY TO SECOND;
				END IF;
				
				:new.depart_dt := new_depart_dt;
				:new.arrive_dt := new_arrive_dt;
			END IF;
		END IF;
	END IF;
COMMIT;
END DepStationBI;
-----------------------------------------------------------For example----------------------------------------------------
INSERT INTO departures VALUES(6, 1, 1, TO_DATE('2020/12/31', 'yyyy/mm/dd'));

INSERT ALL 
	INTO departures_stations VALUES(6, 1, INTERVAL '0 00:35:00' DAY TO SECOND, INTERVAL '0 00:35:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(6, 6, INTERVAL '1 15:13:00' DAY TO SECOND, INTERVAL '1 15:33:00' DAY TO SECOND, DEFAULT)
    INTO departures_stations VALUES(6, 7, INTERVAL '1 14:15:00' DAY TO SECOND, INTERVAL '1 14:31:00' DAY TO SECOND, DEFAULT)
SELECT * FROM DUAL;
SELECT * FROM departures_stations ds WHERE ds.departure_id =6;


SELECT * FROM routes_stations rt WHERE rt.route_id=1 ORDER BY rt.station_order ASC;
----------------------------------------------------------------2------------------------------------------------------------------------

----------------------------------------------------------------3------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION NewMinRoute RETURN NUMBER
IS
CURSOR c IS 
  SELECT route_id as id FROM routes
  ORDER BY id;
  
rec c%ROWTYPE;
new_route NUMBER := 0;

BEGIN
OPEN c;
LOOP
  FETCH c INTO rec;
  new_route := new_route + 1;
  IF (c%NOTFOUND) THEN EXIT;
  END IF;
  IF (rec.id <> new_route) THEN EXIT;
  END IF;
END LOOP;
CLOSE c;
  
return new_route;
END NewMinRoute;

CREATE OR REPLACE TRIGGER MinRouteIdBI
BEFORE INSERT OR UPDATE ON routes
FOR EACH ROW
WHEN(new.route_id IS NULL)
Declare
BEGIN
:new.route_id := NewMinRoute;
END

INSERT INTO routes values(NULL, 'exmpl');
SELECT * FROM routes;
----------------------------------------------------------------3------------------------------------------------------------------------

----------------------------------------------------------------4------------------------------------------------------------------------
CREATE TABLE remove_trains(
	log_id	NUMBER PRIMARY KEY,
	remove_date DATE NOT NULL,
    start_date DATE NOT NULL,
    route_name CHARACTER(5) NOT NULL,
	seats_taken NUMBER NOT NULL CHECK(seats_taken > 0)
);


CREATE OR REPLACE TRIGGER RemoveTrainLogBD
BEFORE DELETE ON departures
FOR EACH ROW
DECLARE
	minSeatsTaken NUMBER := 5;
    newId NUMBER;
    routeName VARCHAR(20);
	taken NUMBER;
	PRAGMA AUTONOMOUS_TRANSACTION; 
BEGIN
	SELECT SUM(st.taken)
	INTO taken
	FROM seats_taken st
	WHERE st.departure_id=:old.departure_id; 
	
	IF taken >= minSeatsTaken 
	THEN 
		SELECT COALESCE(MAX(rt.log_id),0) + 1
		INTO newId
		FROM remove_trains rt;
		
		SELECT route.name
		INTO routeName
		FROM routes route
		WHERE route.route_id = :old.route_id;
		INSERT INTO remove_trains VALUES(newId, SYSDATE, :old.start_date, routeName, taken);
	END IF;
	COMMIT;
END RemoveTrainLogBD;
--------------------------------------------------------------For example----------------------------------------------------
INSERT INTO departures VALUES(6, 1, 1, TO_DATE('2020/12/31', 'yyyy/mm/dd'));

INSERT ALL
	INTO seats_taken VALUES(6, 1, 1, 5)
	INTO seats_taken VALUES(6, 2, 1, 10)
	INTO seats_taken VALUES(6, 3, 1, 19)
	INTO seats_taken VALUES(6, 4, 1, 3)

SELECT * FROM DUAL;

SELECT SUM(st.taken)
FROM seats_taken st
WHERE st.departure_id=6;

DELETE FROM departures dep WHERE dep.departure_id = 6;
SELECT *
FROM remove_trains;
----------------------------------------------------------------4------------------------------------------------------------------------
