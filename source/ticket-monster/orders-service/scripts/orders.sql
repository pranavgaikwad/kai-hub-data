CREATE DATABASE IF NOT EXISTS orders;
USE orders;
CREATE TABLE `section` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `number_of_rows` int(11) NOT NULL,
  `row_capacity` int(11) NOT NULL,
  `venue_id` bigint(20) DEFAULT NULL,
  `venue_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKbdpgnn9f25eootvop4cqics0i` (`name`,`venue_id`)
) ;


CREATE TABLE `appearance` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `event_id` bigint(20) DEFAULT NULL,
  `event_name` varchar(255) DEFAULT NULL,
  `venue_id` bigint(20) DEFAULT NULL,
  `venue_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKfgr2nkyi0qpjhjvji0mdfvudc` (`event_id`,`venue_id`)
) ;


CREATE TABLE `booking` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cancellation_code` varchar(255) NOT NULL,
  `contact_email` varchar(255) NOT NULL,
  `created_on` datetime NOT NULL,
  `performance_id` bigint(20) DEFAULT NULL,
  `performance_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ;

CREATE TABLE `section_allocation` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `allocated` longblob,
  `occupied_count` int(11) NOT NULL,
  `performance_id` bigint(20) DEFAULT NULL,
  `performance_name` varchar(255) DEFAULT NULL,
  `version` bigint(20) NOT NULL,
  `section_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKcbyh3leaebtlwfc4eiotooopq` (`performance_id`,`section_id`),
  KEY `FK3rw79cvgssmpg21ds219dydrp` (`section_id`),
  CONSTRAINT `FK3rw79cvgssmpg21ds219dydrp` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`)
) ;

CREATE TABLE `ticket_category` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK_hbsjuus8lw4socklmianxb00r` (`description`)
) ;

# we write to this table, so definitely need it
CREATE TABLE `ticket` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `price` float NOT NULL,
  `number` int(11) NOT NULL,
  `row_number` int(11) NOT NULL,
  `section_id` bigint(20) DEFAULT NULL,
  `ticket_category_id` bigint(20) NOT NULL,
  `booking_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK43lerp18busrqen2gd43vhepi` (`section_id`),
  KEY `FKbt7yntrpp48qd82aubrq6lbx8` (`ticket_category_id`),
  KEY `FK8h02qtjhsys9q4ibyomkoctu6` (`booking_id`),
  CONSTRAINT `FK8h02qtjhsys9q4ibyomkoctu6` FOREIGN KEY (`booking_id`) REFERENCES `booking` (`id`)
) ;

CREATE TABLE `ticket_price_guide` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `price` float NOT NULL,
  `section_id` bigint(20) NOT NULL,
  `show_id` bigint(20) NOT NULL,
  `ticketcategory_id` bigint(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKqgjl8uim31mh6vop6pnt188b4` (`section_id`,`show_id`,`ticketcategory_id`),
  KEY `FKt21lxux6lmhmw6jyx3schteio` (`show_id`),
  KEY `FKbdxqxoxov15nyypxdryur5fs5` (`ticketcategory_id`),
  CONSTRAINT `FK60ub03ab2r2j6d5v8v3v0dprr` FOREIGN KEY (`section_id`) REFERENCES `section` (`id`),
  CONSTRAINT `FKbdxqxoxov15nyypxdryur5fs5` FOREIGN KEY (`ticketcategory_id`) REFERENCES `ticket_category` (`id`),
  CONSTRAINT `FKt21lxux6lmhmw6jyx3schteio` FOREIGN KEY (`show_id`) REFERENCES `appearance` (`id`)
) ;

CREATE TABLE id_generator
(
  IDKEY char(20) NOT NULL,
  IDVALUE bigint NOT NULL
);

INSERT INTO id_generator(IDKEY, IDVALUE) VALUES ('booking', 1);
INSERT INTO id_generator(IDKEY, IDVALUE) VALUES ('ticket', 1);
INSERT INTO id_generator(IDKEY, IDVALUE) VALUES ('section_allocation', 1);

commit;