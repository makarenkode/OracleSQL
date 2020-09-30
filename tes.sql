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
	station_id NUMBER NOT NULL PRIMARY KEY,
	name CHARACTER(50) NOT NULL,
	
	CONSTRAINT stations_name_unique UNIQUE(name)
)


CREATE TABLE trains (
	train_id NUMBER NOT NULL PRIMARY KEY,
	category CHARACTER(5) NOT NULL,
	head_station_id NUMBER NOT NULL,
	
	CONSTRAINT trains_head_station_fkey FOREIGN KEY (head_station_id)
		REFERENCES stations (station_id)
		ON DELETE CASCADE
);

CREATE TABLE routes(
	route_id NUMBER NOT NULL PRIMARY KEY,
	name     CHARACTER(5) NOT NULL
);

CREATE TABLE train_staff(
	stuff_id NUMBER PRIMARY KEY,
	name CHARACTER(255) NOT NULL,
	train_id NUMBER NOT NULL,
	post CHARACTER(50) NOT NULL,

	CONSTRAINT train_stuff_train_fkey FOREIGN KEY (train_id)
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

CREATE TABLE routes_stations(
	route_station_id NUMBER PRIMARY KEY,
	route_id NUMBER NOT NULL,
	station_id NUMBER NOT NULL,
	arrive_dt INTERVAL DAY TO SECOND NOT NULL CHECK(arrive_dt >= INTERVAL '0' DAY),
	depart_dt INTERVAL DAY TO SECOND NOT NULL CHECK(depart_dt >= INTERVAL '0' DAY),

	CONSTRAINT routes_stations_route_fkey FOREIGN KEY (route_id)
		REFERENCES routes (route_id)
		ON DELETE CASCADE,
	
	CONSTRAINT routes_stations_station_fkey FOREIGN KEY (station_id)
		REFERENCES stations (station_id)
		ON DELETE CASCADE,
	
	CONSTRAINT routes_stations_route_station_unique UNIQUE(route_id, station_id)
);

CREATE TABLE delays(
	departure_id NUMBER NOT NULL,
	route_station_id NUMBER NOT NULL,
	delay_dt INTERVAL DAY TO SECOND NOT NULL CHECK(delay_dt >= INTERVAL '0' DAY),

	CONSTRAINT delays_departure_fkey FOREIGN KEY (departure_id)
		REFERENCES departures (departure_id)
		ON DELETE CASCADE,

	CONSTRAINT delays_routes_station_fkey FOREIGN KEY (route_station_id)
		REFERENCES routes_stations (route_station_id)
		ON DELETE CASCADE,

	CONSTRAINT delays_pkey PRIMARY KEY (departure_id, route_station_id)
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
	INTO departures VALUES (1, 1, 1, TO_DATE('2019/12/20', 'yyyy/mm/dd'))
	INTO departures VALUES (2, 1, 1, TO_DATE('2020/01/03', 'yyyy/mm/dd'))
	INTO departures VALUES (3, 2, 2, TO_DATE('2019/12/23', 'yyyy/mm/dd'))
	INTO departures VALUES (4, 3, 3, TO_DATE('2019/12/24', 'yyyy/mm/dd'))
	INTO departures VALUES (5, 4, 4, TO_DATE('2019/12/24', 'yyyy/mm/dd'))
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

--UPDATE seats_taken SET taken = 20 WHERE departure_id = 3 AND seat_type_id = 3 

INSERT ALL
	INTO routes_stations VALUES(1, 1, 1, INTERVAL '0 00:35:00' DAY TO SECOND, INTERVAL '0 00:35:00' DAY TO SECOND)
	INTO routes_stations VALUES(2, 1, 5, INTERVAL '1 03:21:00' DAY TO SECOND, INTERVAL '1 04:17:00' DAY TO SECOND)
	INTO routes_stations VALUES(3, 1, 6, INTERVAL '1 15:13:00' DAY TO SECOND, INTERVAL '1 15:33:00' DAY TO SECOND)
	INTO routes_stations VALUES(4, 1, 7, INTERVAL '1 23:15:00' DAY TO SECOND, INTERVAL '1 23:31:00' DAY TO SECOND)
	INTO routes_stations VALUES(5, 1, 3, INTERVAL '2 07:55:00' DAY TO SECOND, INTERVAL '2 08:53:00' DAY TO SECOND)
	INTO routes_stations VALUES(6, 1, 4, INTERVAL '2 21:25:00' DAY TO SECOND, INTERVAL '2 21:55:00' DAY TO SECOND)
	INTO routes_stations VALUES(7, 1, 8, INTERVAL '3 16:15:00' DAY TO SECOND, INTERVAL '3 16:55:00' DAY TO SECOND)
	INTO routes_stations VALUES(8, 1, 9, INTERVAL '6 23:06:00' DAY TO SECOND, INTERVAL '6 23:06:00' DAY TO SECOND)

	INTO routes_stations VALUES(9, 2, 2, INTERVAL '0 14:20:00' DAY TO SECOND, INTERVAL '0 14:20:00' DAY TO SECOND)
	INTO routes_stations VALUES(10, 2, 3, INTERVAL '1 12:15:00' DAY TO SECOND, INTERVAL '1 13:00:00' DAY TO SECOND)
	INTO routes_stations VALUES(11, 2, 7, INTERVAL '2 21:19:00' DAY TO SECOND, INTERVAL '2 21:47:00' DAY TO SECOND)
	INTO routes_stations VALUES(12, 2, 6, INTERVAL '3 04:48:00' DAY TO SECOND, INTERVAL '3 05:08:00' DAY TO SECOND)
	INTO routes_stations VALUES(13, 2, 10, INTERVAL '3 10:59:00' DAY TO SECOND, INTERVAL '3 11:41:00' DAY TO SECOND)
	INTO routes_stations VALUES(14, 2, 5, INTERVAL '3 17:20:00' DAY TO SECOND, INTERVAL '3 17:40:00' DAY TO SECOND)
	INTO routes_stations VALUES(15, 2, 1, INTERVAL '4 16:58:00' DAY TO SECOND, INTERVAL '4 16:58:00' DAY TO SECOND)
	
	INTO routes_stations VALUES(16, 3, 2, INTERVAL '0 21:15:00' DAY TO SECOND, INTERVAL '0 21:15:00' DAY TO SECOND)
	INTO routes_stations VALUES(17, 3, 11, INTERVAL '1 12:53:00' DAY TO SECOND, INTERVAL '1 13:56:00' DAY TO SECOND)
	INTO routes_stations VALUES(18, 3, 7, INTERVAL '2 00:29:00' DAY TO SECOND, INTERVAL '2 00:47:00' DAY TO SECOND)
	INTO routes_stations VALUES(19, 3, 6, INTERVAL '2 06:48:00' DAY TO SECOND, INTERVAL '2 07:08:00' DAY TO SECOND)
	INTO routes_stations VALUES(20, 3, 5, INTERVAL '2 19:20:00' DAY TO SECOND, INTERVAL '2 19:40:00' DAY TO SECOND)
	INTO routes_stations VALUES(21, 3, 1, INTERVAL '3 16:58:00' DAY TO SECOND, INTERVAL '3 16:58:00' DAY TO SECOND)

	INTO routes_stations VALUES(22, 4, 3, INTERVAL '0 19:55:00' DAY TO SECOND, INTERVAL '0 19:55:00' DAY TO SECOND)
	INTO routes_stations VALUES(23, 4, 4, INTERVAL '1 07:55:00' DAY TO SECOND, INTERVAL '1 07:55:00' DAY TO SECOND)
SELECT * FROM DUAL;


INSERT ALL
	INTO delays VALUES(1, 4, INTERVAL '0 00:15:00' DAY TO SECOND)
SELECT * FROM DUAL;

SELECT * FROM routes_stations;

--1. Справка о величине задержки указанного поезда в указанное время.

SELECT del.d_delay * SIGN( SIGN(del.d_delay) + 1) || ' ' ||
       del.h_delay * SIGN( SIGN(del.h_delay) + 1) || ':' ||
       del.m_delay * SIGN( SIGN(del.m_delay) + 1) || ':' ||
       del.s_delay * SIGN( SIGN(del.s_delay) + 1) as "delay"
FROM 
(
    SELECT EXTRACT( day FROM ((dep.start_date + (rs.arrive_dt + d.delay_dt)) - TO_DATE('2019/12/21 23:25:00', 'yyyy/mm/dd hh24:mi:ss'))day to second) d_delay,
           EXTRACT( hour FROM ((dep.start_date + (rs.arrive_dt + d.delay_dt)) - TO_DATE('2019/12/21 23:25:00', 'yyyy/mm/dd hh24:mi:ss')) day to second) h_delay,
           EXTRACT( minute FROM ((dep.start_date + (rs.arrive_dt + d.delay_dt)) - TO_DATE('2019/12/21 23:25:00', 'yyyy/mm/dd hh24:mi:ss')) day to second) m_delay,
           EXTRACT( second FROM ((dep.start_date + (rs.arrive_dt + d.delay_dt)) - TO_DATE('2019/12/21 23:25:00', 'yyyy/mm/dd hh24:mi:ss')) day to second) s_delay
    FROM trains tr
    LEFT JOIN departures dep ON dep.train_id = tr.train_id
    INNER JOIN routes_stations rs ON dep.route_id=rs.route_id
    INNER JOIN stations st ON st.station_id = rs.station_id
    LEFT JOIN delays d ON rs.route_station_id=d.route_station_id AND d.departure_id = dep.departure_id 
    WHERE tr.train_id = 1 AND st.station_id = 7 AND ((rs.depart_dt + d.delay_dt) + dep.start_date >= TO_DATE('2019/12/21 23:25:00', 'yyyy/mm/dd hh24::mi:ss') )
) del


--1. Справка о величине задержки указанного поезда в указанное время.

--2. Справка о маршрутах и поездах между указанными городами (без привязки к датам/расписанию)

  DROP VIEW edge_routes;
  CREATE VIEW edge_routes AS (
      
      SELECT DISTINCT 
             tmp.st_b st_b,
             tmp.st_e st_e,
             tmp.route_id route_id,
             tr.train_id train_id,
             dep.departure_id departure_id
      FROM    
      (
          SELECT rs1.station_id st_b,
                 rs2.station_id st_e,
                 rs1.route_id route_id,
                 ROW_NUMBER() OVER (PARTITION BY rs1.station_id, rs1.route_id  ORDER BY (rs2.arrive_dt - rs1.depart_dt) ASC) rn
          FROM routes_stations rs1
          INNER JOIN routes_stations rs2 ON rs1.route_id=rs2.route_id
          WHERE rs1.station_id <> rs2.station_id AND (rs1.depart_dt < rs2.arrive_dt)
          ORDER BY rs1.route_id, rn
      ) tmp
      INNER JOIN departures dep ON dep.route_id = tmp.route_id
      INNER JOIN trains tr ON dep.train_id = tr.train_id
      WHERE tmp.rn = 1
      --ORDER BY tr.train_id ASC
  )
  
  select * from edge_routes;

    -- WITH stepbystep (node, way, lastNode) AS (
        -- SELECT DISTINCT 
               -- st2.name node,
               -- (st1.name || '->' || st2.name) way,
               -- st2.name lastNode     
        -- FROM routes_stations rs1
        -- INNER JOIN routes_statoins rs2 ON rs1.route_id==rs2.route_id
        -- INNER JOIN stations st1 ON rs1.station_id=st1.station_id
        -- INNER JOIN stations st2 ON rs2.station_id=st2.station_id
        -- WHERE st.name = 'Новосибирск' AND rs1.depart_dt < rs2.arrive_dt
        -- UNION ALL
        -- SELECT st2.name,
               -- s.way || '->' || st2.name,
               -- st2.name
        -- FROM routes_stations rs1
        -- INNER JOIN routes_statoins rs2 ON rs1.route_id==rs2.route_id
        -- INNER JOIN stations st1 ON rs1.station_id=st1.station_id
        -- INNER JOIN stations st2 ON rs2.station_id=st2.station_id
        -- INNER JOIN stepbystep s ON s.node = st1.name
    -- )
    -- CYCLE node SET cyclemark TO 'X' DEFAULT '-'
    -- SELECT DISTINCT way, lastNode FROM stepbystep
    -- WHERE lastNode = 'Пермь';


    WITH stepbystep (node, way, trainWay, lastNode, lastTrain) AS (
        SELECT DISTINCT 
                st2.name node,
                (st1.name || '->' || st2.name) way,
                TO_CHAR(er.train_id) trainWay,
                st2.name lastNode,
                er.train_id lastTrain
        FROM edge_routes er
        INNER JOIN stations st1 ON er.st_b=st1.station_id
        INNER JOIN stations st2 ON er.st_e=st2.station_id
        WHERE st1.name = 'Пермь'
        UNION ALL
        SELECT st2.name,
               s.way || '->' || st2.name,
               trainWay || '->' || TO_CHAR(er.train_id),
               st2.name,
               er.train_id
        FROM edge_routes er
        INNER JOIN stations st1 ON st1.station_id=er.st_b
        INNER JOIN stations st2 ON st2.station_id=er.st_e
        INNER JOIN stepbystep s ON s.node = st1.name
     --   WHERE er.train_id != lastTrain
    )
    CYCLE node SET cyclemark TO 'X' DEFAULT '-'
    SELECT DISTINCT way, trainWay, cyclemark FROM stepbystep
    WHERE lastNode = 'Владивосток';

    
--2. Справка о маршрутах и поездах между указанными городами (без привязки к датам/расписанию)    

--3.	Станции-пересадки по маршруту до указанной станции (от заданной до заданной).

    WITH stepbystep (node, way, lastNode) AS (
        SELECT DISTINCT 
                st2.name node,
                (st1.name || '->' || st2.name) way,
                st2.name lastNode
        FROM edge_routes er1
        INNER JOIN stations st1 ON er1.st_b=st1.station_id
        INNER JOIN stations st2 ON er1.st_e=st2.station_id
        WHERE st1.name = 'Новосибирск'
        UNION ALL
        SELECT st2.name,
               s.way || '->' || st2.name,
               st2.name
        FROM edge_routes er
        INNER JOIN stations st1 ON st1.station_id=er.st_b
        INNER JOIN stations st2 ON st2.station_id=er.st_e
        INNER JOIN stepbystep s ON s.node = st1.name
    )
    CYCLE node SET cyclemark TO 'X' DEFAULT '-'
    SELECT DISTINCT way FROM stepbystep
    WHERE lastNode = 'Иркустк';
    
    WITH stepbystep (node, way, lastNode) AS (
        SELECT DISTINCT 
                st2.name node,
                (st1.name || '->' || st2.name) way,
                st2.name lastNode
        FROM edge_routes er1
        INNER JOIN stations st1 ON er1.st_b=st1.station_id
        INNER JOIN stations st2 ON er1.st_e=st2.station_id
        WHERE st1.name = 'Новосибирск'
        UNION ALL
        SELECT st2.name,
               s.way || '->' || st2.name,
               st2.name
        FROM edge_routes er
        INNER JOIN stations st1 ON st1.station_id=er.st_b
        INNER JOIN stations st2 ON st2.station_id=er.st_e
        INNER JOIN stepbystep s ON s.node = st1.name
    )
    CYCLE node SET cyclemark TO 'X' DEFAULT '-'
    SELECT DISTINCT way FROM stepbystep
    WHERE lastNode = 'Пермь';
    
    

--3. Станции-пересадки по маршруту до указанной станции (от заданной до заданной).

--4. Количество билетов на указанный поезд (от заданного города до заданного в указанный промежуток времени) с заданным типом мест (плацкарт/купе/СВ).
    
    SELECT tr.train_id,
           TO_CHAR((dep.start_date + rs.arrive_dt), 'yyyy/mm/dd hh24:mi:ss') arrive,
           TO_CHAR((dep.start_date + rs1.depart_dt), 'yyyy/mm/dd hh24:mi:ss') depart,
           sts.name nameOfType,
           se.num numOfSeats,
           se.num - COALESCE 
           (
               (
                   SELECT MAX(seta2.taken)
                   FROM departures dep2
                   INNER JOIN routes_stations rs2 ON rs2.route_id = dep2.route_id 
                   INNER JOIN seats_taken seta2 ON seta2.departure_id=dep2.departure_id AND seta2.seat_type_id=se.seat_type_id AND seta2.station_id=rs2.station_id
                   WHERE dep2.train_id = tr.train_id AND rs2.depart_dt >= rs.depart_dt AND  rs2.arrive_dt < rs1.arrive_dt
               ) 
               , 0
           ) numOfEmptySeats
    FROM trains tr
    INNER JOIN departures dep ON dep.train_id = tr.train_id
    INNER JOIN routes_stations rs ON rs.route_id = dep.route_id AND rs.station_id = 2
    INNER JOIN routes_stations rs1 ON rs1.route_id = dep.route_id AND rs1.station_id = 10
    INNER JOIN seats se ON se.train_id = tr.train_id AND se.seat_type_id = 3
    INNER JOIN seat_types sts ON sts.seat_type_id = se.seat_type_id
    WHERE tr.train_id = 2
            AND     rs1.arrive_dt + dep.start_date BETWEEN TO_DATE('2018/01/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss') AND TO_DATE('2020/02/08 00:00:00', 'yyyy/mm/dd hh24:mi:ss')
            AND     rs.depart_dt + dep.start_date BETWEEN TO_DATE('2018/01/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss') AND TO_DATE('2020/02/08 00:00:00', 'yyyy/mm/dd hh24:mi:ss')

--4. Количество билетов на указанный поезд (от заданного города до заданного в указанный промежуток времени) с заданным типом мест (плацкарт/купе/СВ).

--5. Справка о ближайших поездах в указанный город в указанный отрезок времени

    SELECT DISTINCT er.train_id,
                    dep.start_date,
                    st1.name || '->' || st2.name as way
    
    FROM edge_routes er
    INNER JOIN departures dep ON dep.departure_id = er.departure_id
    INNER JOIN routes_stations rs ON rs.route_id = er.route_id 
    INNER JOIN stations st1 ON st1.station_id = er.st_b 
    INNER JOIN stations st2 ON st2.station_id = er.st_e
    WHERE er.st_e = 7
            AND dep.start_date + rs.arrive_dt BETWEEN TO_DATE('2018/01/01 00:00:00', 'yyyy/mm/dd hh24:mi:ss') AND TO_DATE('2020/02/08 00:00:00', 'yyyy/mm/dd hh24:mi:ss')
    
           
--5. Справка о ближайших поездах в указанный город в указанный отрезок времени
