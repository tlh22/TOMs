CREATE SEQUENCE public."TimePeriods_Code_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE public."TimePeriods_Code_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE public."TimePeriods_Code_seq" TO postgres;

CREATE TABLE public."TimePeriods"
(
    "Code" integer NOT NULL DEFAULT nextval('public."TimePeriods_Code_seq"'::regclass),
    "Description" character varying COLLATE pg_catalog."default",
    "LabelText" character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT "TimePeriods_pkey" PRIMARY KEY ("Code"),
    CONSTRAINT "TimePeriods_Description_key" UNIQUE ("Description")
)

TABLESPACE pg_default;

ALTER TABLE public."TimePeriods"
    OWNER to postgres;

GRANT ALL ON TABLE public."TimePeriods" TO postgres;

--
-- PostgreSQL database dump
--

-- Dumped from database version 12.2
-- Dumped by pg_dump version 12.4

-- Started on 2021-01-29 11:15:39

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4775 (class 0 OID 869224)
-- Dependencies: 521
-- Data for Name: TimePeriods; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (225, 'Jan-July 8.00pm-10.00am Aug 8.00pm-9.00am Sep-Nov 8.00pm-10.00am Dec 8.00pm-9.00am', 'Jan-July 8.00pm-10.00am;Aug 8.00pm-9.00am;Sep-Nov 8.00pm-10.00am;Dec 8.00pm-9.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (103, '6.30pm-7.00am', '6.30pm-7.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (102, '6.00pm-7.00am', '6.00pm-7.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (226, 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.10am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (111, 'At Any Time May-Sept', 'At Any Time May-Sept');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (217, 'Mon-Fri 8.00am-8.00pm', 'Mon-Fri 8.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (219, 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm Fri 8.30am-9.15am 11.45am-1.15pm', 'Mon-Thu 8.30am-9.15am 2.30pm-4.00pm;Fri 8.30am-9.15am 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (218, 'Mon-Fri 7.30am-9.00am', 'Mon-Fri 7.30am-9.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (222, 'Mon-Fri 8.30am-6.00pm', 'Mon-Fri 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (162, 'Mon-Sat 9.00am-5.30pm', 'Mon-Sat 9.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (163, 'Mon-Sun 10.30am-4.30pm', 'Mon-Sun 10.30am-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (169, 'Sat-Sun 10.00am-4.00pm', 'Sat-Sun 10.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (170, 'Sat-Sun 8.00am-6.00pm May-Sept', 'Sat-Sun 8.00am-6.00pm May-Sept');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (171, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (139, 'Mon-Fri 8.30am-4.30pm', 'Mon-Fri 8.30am-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (201, 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.15am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (221, 'Mon-Sat 8.00am-4.00pm', 'Mon-Sat 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (147, 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 9.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (133, 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.00 pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (141, 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.15am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (12, 'Mon-Fri 8.30am-6.30pm', 'Mon-Fri 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (33, 'Mon-Sat 8.30am-6.30pm', 'Mon-Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (45, 'Mon-Sat 9.30am-6.30pm', 'Mon-Sat 9.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (19, 'Mon-Fri 9.00am-4.00pm', 'Mon-Fri 9.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (26, 'Mon-Sat 7.00am-6.30pm', 'Mon-Sat 7.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (83, 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (124, 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (118, 'Mon-Fri 7.30am-5.00pm', 'Mon-Fri 7.30am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (119, 'Mon-Fri 7.30am-6.30pm Sat-Sun 10.00am-5.30pm', 'Mon-Fri 7.30am-6.30pm;Sat-Sun 10.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (120, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (121, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (75, 'Mon-Fri 8.00am-4.00pm', 'Mon-Fri 8.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (14, 'Mon-Fri 8.00am-6.30pm', 'Mon-Fri 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (15, 'Mon-Fri 8.00am-6.00pm', 'Mon-Fri 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (101, '6.00am-10.00pm', '6.00am-10.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (78, 'Unknown - no sign', 'Unknown - no sign');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (10, 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (11, 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm', 'Mon-Fri 8.15am-9.15am 3.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (16, 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (34, 'Mon-Sat 8.30am-6.30pm Sun 11.00am-5.00pm', 'Mon-Sat 8.30am-6.30pm;Sun 11.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (43, 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (97, 'Mon-Fri 8.30am-5.30pm', 'Mon-Fri 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (203, 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (204, 'Mon-Fri 9.30am-4pm Sat All day', 'Mon-Fri 9.30am-4pm;Sat All day');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (205, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (107, '8.00am-6.00pm', '8.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (108, '8.00am-6.00pm 2.15pm-4.00pm', '8.00am-6.00pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (126, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (127, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-Noon', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-Noon');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (128, 'Mon-Fri 8.00am-6.00pm Sat 8.00am-12.30pm', 'Mon-Fri 8.00am-6.00pm;Sat 8.00am-12.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (129, 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (130, 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.00am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (131, 'Mon-Fri 8.00am-9.00am Mon-Thurs 2.30pm-3.45pm Fri Noon-1.30pm', 'Mon-Fri 8.00am-9.00am;Mon-Thurs 2.30pm-3.45pm;Fri Noon-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (132, 'Mon-Fri 8.00am-9.15am', 'Mon-Fri 8.00am-9.15am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (134, 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm', 'Mon-Fri 8.00am-9.15am 4.30pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (135, 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (136, 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.45pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (137, 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (138, 'Mon-Fri 8.15am-5.30pm Sat 8.15am-1.30pm', 'Mon-Fri 8.15am-5.30pm;Sat 8.15am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (142, 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (140, 'Mon-Fri 8.30am-5.00pm', 'Mon-Fri 8.30am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (143, 'Mon-Fri 9.00am-5.00pm', 'Mon-Fri 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (144, 'Mon-Fri 9.00am-6.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.00am-6.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (145, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-1.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (146, 'Mon-Fri 9.00am-8.30pm Sat 9.00am-5.00pm', 'Mon-Fri 9.00am-8.30pm;Sat 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (148, 'Mon-Fri 9.15am-4.30pm', 'Mon-Fri 9.15am-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (156, 'Mon-Fri 9.30am-4.00pm Sat 9.30am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 9.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (164, 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sun 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (212, 'Mon-Fri 8.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.00am-6.30pm;Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (125, 'Mon-Fri 8.00am-5.30pm', 'Mon-Fri 8.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (40, 'Mon-Sat 8.00am-6.00pm', 'Mon-Sat 8.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (123, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm Sat 8.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm;Sat 8.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (109, '8.15am-9.00am 11.30am-1.15pm', '8.15am-9.00am 11.30am-1.15pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (168, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.30am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.30am Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (39, 'Mon-Sat 8.00am-6.30pm', 'Mon-Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (228, 'Mon-Fri 9.30am-4.00pm', 'Mon-Fri 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (99, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (167, 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.30am 3.00pm-4.30pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (105, '7.30am-6.30pm', '7.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (106, '8.00am-5.30pm', '8.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (213, 'Mon-Sat 8.30am-5.30pm', 'Mon-Sat 8.30am-5.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (110, '9.00am-5.30pm', '9.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (8, 'Mon-Fri 7.00am-7.00pm', 'Mon-Fri 7.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (149, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-1.30pm', 'Mon-Fri 9.15am-4.30pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (150, 'Mon-Fri 9.15pm-8.00am', 'Mon-Fri 9.15pm-8.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (151, 'Mon-Fri 9.30am-11.00am', 'Mon-Fri 9.30am-11.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (152, 'Mon-Fri 9.30am-3.30pm', 'Mon-Fri 9.30am-3.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (153, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-1.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (154, 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am', 'Mon-Fri 9.30am-4.00pm 6.30pm-7.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (155, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (202, 'Mon-Sat 8.15am-6.00pm', 'Mon-Sat 8.15am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (115, 'Mon-Fri 11.30am-1.00pm', 'Mon-Fri 11.30am-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (122, 'Mon-Fri 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.30am-9.30am;4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (157, 'Mon-Sat 7.00am-6.00pm', 'Mon-Sat 7.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (158, 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.00am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (160, 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm', 'Mon-Sat 7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (159, 'Mon-Sat 7.30am-6.30pm', 'Mon-Sat 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (161, 'Mon-Sat 8.30am-6.00pm', 'Mon-Sat 8.30am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (206, 'Sat 1.30pm-6.30pm', 'Sat 1.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (224, '7.00am-7.00pm', '7.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (1, 'At Any Time', 'At Any Time');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (210, 'Mon-Fri 9.30am-4.00pm Sat 8.30am-6.30pm', 'Mon-Fri 9.30am-4.00pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (211, 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (220, 'Mon-Sat 9.00am-6.00pm', 'Mon-Sat 9.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (227, 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm', 'Mon-Fri 8.00am-9.15am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (215, '8.00am-9.30am 4.00pm-6.00pm', '8.00am-9.30am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (216, 'Mon-Fri 7.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (166, 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm Fri 11.45am-1.15pm', 'Mon-Thurs 8.30am-9.15am 2.30pm-4.00pm;Fri 11.45am-1.15pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (104, '7.00am-8.00pm', '7.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (165, 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm Fri 8.00am-9.00am Noon-1.00pm', 'Mon-Thurs 8.00am-9.00am 3.15pm-4.15pm;Fri 8.00am-9.00am Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (98, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.30am-6.30pm;Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (112, 'Mon-Fri 1.30pm-3.00pm', 'Mon-Fri 1.30pm-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (113, 'Mon-Fri 10.00am-11.30am', 'Mon-Fri 10.00am-11.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (2, 'Mon-Fri 10.00am-3.30pm', 'Mon-Fri 10.00am-3.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (114, 'Mon-Fri 11.00am-12.30pm', 'Mon-Fri 11.00am-12.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (116, 'Mon-Fri 12.30pm-2.00pm', 'Mon-Fri 12.30pm-2.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (117, 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm', 'Mon-Fri 7.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (207, '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm', '8.15am-9.00am 11.30am-1.15pm 2.15pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (208, 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (209, '7.30am-9.30am 4.00pm-6.30pm', '7.30am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (96, 'Mon-Fri 8.00am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.15am;4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (229, 'Mon-Sun 9.30am-4.00pm', 'Mon-Sun 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (230, 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ', 'Mon-Fri 8.30am-9.30am 4.00pm-5.00pm ');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (223, 'Mon-Sat 7.30am-9.30am 4.30pm-6.30pm', 'Mon-Sat 7.30am-9.30am; 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (231, 'Mon-Sun', 'Mon-Sun');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (232, '10.30am-11.00pm', '10.30am-11.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (234, '10.30am-10.00pm', '10.30am-10pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (235, 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm', 'Mon-Thurs 2.45pm-3.45pm Fri Noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (236, '7.00am-10.00am 4.00pm-6.30pm', '7.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (237, 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm', 'Mon-Thurs 8.15am-9.15am 2.15pm-3.30pm Fri 8.15am-9.15am 12.00pm-12.45pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (238, 'Mon-Sat 7.00am-8.00am', 'Mon-Sat 7.00am-8.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (239, 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm', 'Mon-Fri 8.30am-9.15am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (240, '8.30am-6.30pm', '8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (241, 'Mon-Fri 12 Noon-2.00pm', 'Mon-Fri 12 Noon-2.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (242, 'Mon-Fri 9.00am-10.00am', 'Mon-Fri 9.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (244, 'Mon-Sat 9.00am-6.30pm', 'Mon-Sat 9.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (245, 'Mon-Fri 8.00am-5.00pm', 'Mon-Fri 8.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (247, 'Mon-Sun 7.00am-5.00pm', 'Mon-Sun 7.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (248, 'Mon-Fri 9.00am-11.00am', 'Mon-Fri 9.00am-11.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (249, 'Mon-Sat 9.00am-5.00pm', 'Mon-Sat 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (250, 'Mon-Fri 8.30am-1.30pm', 'Mon-Fri 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (251, 'Mon-Fri 7.00am-2.00pm', 'Mon-Fri 7.00am-2.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (252, 'Mon-Fri 9.00am-8.00pm Sat 9.00-5.00pm Sun 1.00pm-5.00pm', 'Mon-Fri 9.00am-8.00pm Sat 9.00-5.00pm Sun 1.00pm-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (253, 'Mon-Sat 7.00am-7.00pm', 'Mon-Sat 7.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (254, 'Mon-Fri 8.15am-9.15am 2.45pm-4.00pm', 'Mon-Fri 8.15am-9.15am 2.45pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (256, 'Mon-Fri 8.30am-7.00pm Sat 8.30am-6.30pm', 'Mon-Fri 8.30am-7.00pm Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (257, 'Mon-Fri 8.00am-7.00pm', 'Mon-Fri 8.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (258, 'Mon-Fri 8.30am-9.30am 3.30pm-4.30pm', 'Mon-Fri 8.30am-9.30am 3.30pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (259, 'Mon-Fri 7.30am-4.30pm', 'Mon-Fri 7.30am-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (260, 'Fri 7.00am-6.30pm Sat 7.00am-1.30pm', 'Fri 7.00am-6.30pm Sat 7.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (261, 'Mon-Fri 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (262, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm Sun 1.00pm-5.00pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm Sun 1.00pm-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (263, '10.00pm-5.00am', '10.00pm-5.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (264, 'Mon-Sat 8.00am-7.00pm', 'Mon-Sat 8.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (266, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (267, 'Mon-Fri 8.30am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 8.30am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (268, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-1.30pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (269, 'Mon-Fri 8.00am-7.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-7.00pm Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (270, 'Mon-Fri 7.00am-6.30pm Sat 8.30am-6.30pm', 'Mon-Fri 7.00am-6.30pm Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (271, 'Mon-Fri 8.30am-9.30am 2.30pm-4.30pm', 'Mon-Fri 8.30am-9.30am 2.30pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (272, 'Mon-Fri 7.00am-6.30pm Sat 7.00am-1.30pm', 'Mon-Fri 7.00am-6.30pm Sat 7.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (273, 'Mon-Fri 8.00am-9.00am 3.00pm-5.00pm', 'Mon-Fri 8.00am-9.00am 3.00pm-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (274, 'Mon-Fri 8.30am-10.00pm', 'Mon-Fri 8.30am-10.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (233, '10.30am-Midnight Midnight-6.30am', '10.30am-midnight, midnight-6.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (243, 'Mon-Fri 11.00am-12 Noon', 'Mon-Fri 11.00am-12 noon');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (275, 'Mon-Fri 10.00am-4.00pm Sat 10.00am-1.30pm', 'Mon-Fri 10.00am-4.00pm Sat 10.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (276, 'Mon-Fri 8.30am-6.30pm and Sat 7.00am-3.00pm', 'Mon-Fri 8.30am-6.30pm and Sat 7.00am-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (356, 'Mon-Fri 4.30pm-6.30pm', 'Mon-Fri 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (278, 'Mon-Fri 8.00am-10.00am 4.00pm-6.30pm Sat 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am 4.00pm-6.30pm Sat 8.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (279, 'Sat 8.30am-6.30pm', 'Sat 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (280, 'Mon-Fri 8.00am-9.00am 2.00pm-4.00pm', 'Mon-Fri 8.00am-9.00am 2.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (281, 'Mon-Fri 8.30am-9.30am 2.30pm-4.00pm', 'Mon-Fri 8.30am-9.30am 2.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (282, 'Mon-Thu 8.30am-6.30pm', 'Mon-Thu 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (283, 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm Sat 7.00am-1.30pm', 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm Sat 7.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (284, 'Fri 8.30am-6.30pm Sat 8.30am-1.30pm', 'Fri 8.30am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (285, 'Mon-Fri 10.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 10.00am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (286, 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm 7.30pm-8.00pm Sat 7.00am-1.30pm 7.30pm-8.00pm', 'Mon-Thu 8.30am-6.30pm Fri 7.00am-6.30pm 7.30pm-8.00pm Sat 7.00am-1.30pm 7.30pm-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (287, 'Mon-Fri 7.30am-9.30am 3.00pm-6.00pm', 'Mon-Fri 7.30am-9.30am 3.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (290, 'Mon-Thu 8.30am-7.30pm Fri-Sat 8.30am-11.00pm Sun 10.00am-4.00pm', 'Mon-Thu 8.30am-7.30pm Fri-Sat 8.30am-11.00pm Sun 10.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (291, '8.00am-11.00pm', '8.00am-11.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (292, 'Mon-Fri 8.00am-9.30am 3.00pm-4.30pm', 'Mon-Fri 8.00am-9.30am 3.00pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (293, 'Mon-Fri 9.00am-5.30pm', 'Mon-Fri 9.00am-5.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (294, 'Mon-Fri 10.00am-11.00am 2.00pm-3.00pm', 'Mon-Fri 10.00am-11.00am 2.00pm-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (296, 'Mon-Fri 1.00pm-2.00pm', 'Mon-Fri 1.00pm-2.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (298, 'Mon-Fri 10.00am-4.30pm', 'Mon-Fri 10.00am-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (300, 'Mon-Sat 7.00am-10.00pm', 'Mon-Sat 7.00am-10.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (301, '6.30am-6.00pm', '6.30am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (302, 'Mon-Sat 6.00am-6.30pm', 'Mon-Sat 6.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (303, 'Mon-Fri 7.30am-9.30am 2.30pm-4.30pm', 'Mon-Fri 7.30am-9.30am 2.30pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (304, 'Mon-Fri 8.00am-9.00am 2.30pm-4.30pm term time only', 'Mon-Fri 8.00am-9.00am 2.30pm-4.30pm term time only');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (295, 'Mon-Fri 8.30am-4.00pm', 'Mon-Fri 8.30am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (306, 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (307, 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.30am-4.00pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (308, 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (309, 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (310, 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-8.00pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (311, 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (312, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (313, 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (314, 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (315, 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 8.30am-5.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (316, 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 9.15am-4.30pm Sat 8.00am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (317, 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm', 'Mon-Sat 7.30am-6.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (318, 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm', 'Mon-Fri 7.30am-6.30pm Sat 8.00am-1.30pm Sun 12.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (328, '8.00am-7.00pm', '8.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (320, '8.00am-9.00pm', '8.00am-9.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (322, 'Mon-Sat 1.00pm-2.00pm', 'Mon-Sat 1.00pm-2.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (323, 'Mon-Fri 6.00am-5.00pm', 'Mon-Fri 6.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (324, 'Mon-Sun 8.00am-6.30pm', 'Mon-Sun 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (325, 'Mon-Fri 2.00pm-3.00pm', 'Mon-Fri 2.00pm-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (326, 'Mon-Fri 3.00pm-4.00pm', 'Mon-Fri 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (332, 'Mon-Sat 8.00am-9.30am 4.00pm-6.30pm', 'Mon-Sat 8.00am-9.30am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (333, 'Mon-Fri 8.15am-9.15am 2.45pm-3.45pm', 'Mon-Fri 8.15am-9.15am 2.45pm-3.45pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (334, 'Mon-Fri 8.30am-9.15am 2.45pm-3.30pm', 'Mon-Fri 8.30am-9.15am 2.45pm-3.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (335, 'Mon-Sat 2.00pm-3.00pm', 'Mon-Sat 2.00pm-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (336, 'Mon-Fri 8.30am-9.30am 2.30pm-3.30pm', 'Mon-Fri 8.30am-9.30am 2.30pm-3.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (337, 'Mon-Fri 8.30am-9.30am 3.00pm-4.00pm', 'Mon-Fri 8.30am-9.30am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (338, 'Mon-Fri 2.45pm-3.45pm', 'Mon-Fri 2.45pm-3.45pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (339, '8.30am-9.30am 2.30pm-3.30pm', '8.30am-9.30am 2.30pm-3.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (340, 'Mon-Fri 8.00am-9.30am 3.00pm-5.00pm', 'Mon-Fri 8.00am-9.30am 3.00pm-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (341, 'Mon-Fri 8.00am-6.30pm Sat 9.30am-12.30pm', 'Mon-Fri 8.00am-6.30pm Sat 9.30am-12.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (342, 'Mon-Fri Midnight-7.00am 8.00pm-Midnight Sat & Sun At Any Time', 'Mon-Fri Midnight-7.00am 8.00pm-Midnight Sat & Sun At Any Time');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (343, 'Mon-Fri 9.30am-4.30pm', 'Mon-Fri 9.30am-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (344, 'Mon-Sat 9.30am-5.30pm', 'Mon-Sat 9.30am-5.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (345, 'Mon-Fri 10.30am-11.30am', 'Mon-Fri 10.30am-11.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (346, 'Mon-Fri 10.00am-4.00pm', 'Mon-Fri 10.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (347, 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm', 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (348, 'Mon-Fri 8.15am-9.45am 3.00pm-4.30pm', 'Mon-Fri 8.15am-9.45am 3.00pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (349, 'Mon-Fri 6.30am-7.30am 9.30am-4.30pm 6.30pm-7.30pm', 'Mon-Fri 6.30am-7.30am 9.30am-4.30pm 6.30pm-7.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (288, 'Mon-Fri 10.00am-11.00am', 'Mon-Fri 10.00am-11.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (350, 'Mon-Fri 7.30am-9.30am 4.30pm-8.30pm', 'Mon-Fri 7.30am-9.30am 4.30pm-8.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (351, 'Mon-Fri 8.00am-9.30am 2.30pm-4.30pm', 'Mon-Fri 8.00am-9.30am 2.30pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (246, '7.00am-Midnight', '7.00am-midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (255, 'Mon-Sat 8.00am-Midnight', 'Mon-Sat 8.00am-midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (265, '9.00pm-Midnight Midnight-3.00am', '9.00pm-midnight midnight-3.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (297, 'Mon-Fri 12 Noon-1.00pm', 'Mon-Fri 12 noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (319, 'Sat-Sun & Bank Holidays 12 Noon-6.00pm April-September', 'Sat-Sun & Bank Holidays 12 noon-6.00pm April-September');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (321, 'Mon-Fri 10.00am-12 Noon 2.30pm-4.30pm', 'Mon-Fri 10.00am-12 noon 2.30pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (327, 'Mon-Sat 12 Noon-1.00pm', 'Mon-Sat 12 noon-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (0, NULL, NULL);
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (443, 'Mon-Fri Midnight-4.00pm 7.00pm-Midnight Sat & Sun At Any Time', 'Mon-Fri Midnight-4.00pm 7.00pm-Midnight Sat & Sun At Any Time');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (352, 'Mon-Sat Midnight-Noon 2.30pm-Midnight Sun anytime', 'Mon-Sat Midnight-Noon 2.30pm-Midnight Sun anytime');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (353, 'Mon-Fri 7.00am-8.30pm Sat 8.30am-4.30pm Sun Noon-4.30pm', 'Mon-Fri 7.00am-8.30pm Sat 8.30am-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (354, 'Mon-Sun 8.30am-6.30pm', 'Mon-Sun 8.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (355, 'Tue-Fri Midnight-8.30am Mon-Fri 6.30pm-Midnight Sat anytime Sun anytime', 'Tue-Fri Midnight-8.30am Mon-Fri 6.30pm-Midnight Sat anytime Sun anytime');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (357, 'Mon-Sun Midnight-8.30am 6.30pm-Midnight', 'Mon-Sun Midnight-8.30am 6.30pm-Midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (358, 'Mon-Fri 6.30pm-8.30pm Sat 1.30pm-4.30pm Sun Noon-4.30pm', 'Mon-Fri 6.30pm-8.30pm Sat 1.30pm-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (359, 'Mon-Fri 2.00pm-8.30pm Sat 1.30pm-4.30pm Sun Noon-4.30pm', 'Mon-Fri 2.00pm-8.30pm Sat 1.30pm-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (360, 'Mon-Fri 8.00am-9.30am', 'Mon-Fri 8.00am-9.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (361, 'Mon-Fri 7.00am-5.00pm', 'Mon-Fri 7.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (363, 'Mon-Fri 8.00am-9.30am 4.00pm-7.00pm', 'Mon-Fri 8.00am-9.30am 4.00pm-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (364, 'Mon-Fri 8.30am-9.30am 4.30pm-6.30pm', 'Mon-Fri 8.30am-9.30am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (365, '6.30pm-11.00pm', '6.30pm-11.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (366, 'Mon-Fri 5.00pm-8.30pm Sat Noon-4.30pm Sun Noon-4.30pm', 'Mon-Fri 5.00pm-8.30pm Sat Noon-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (367, 'Mon-Fri 7.00am-7.00pm Sat 8.30am-1.30pm', 'Mon-Fri 7.00am-7.00pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (368, 'Mon-Sun 10.00am-4.00pm 6.30pm-8.30pm', 'Mon-Sun 10.00am-4.00pm 6.30pm-8.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (370, 'Mon-Sat 7.00am-10.00am', 'Mon-Sat 7.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (445, '3.00pm-10.00am', '3.00pm-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (446, '10.00am-3.00pm', '10.00am-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (362, 'Mon-Sat At any time Sun Midnight-6.00am', 'Mon-Sat At any time Sun Midnight-6.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (369, 'Mon-Fri 6.30pm-11.00pm Sat 1.30pm-11pm Sun 8.30am-11.00pm', 'Mon-Fri 6.30pm-11.00pm Sat 1.30pm-11pm Sun 8.30am-11.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (371, 'Mon-Sat 6.30pm-9.00pm Sun 8.30am-9.00pm', 'Mon-Sat 6.30pm-9.00pm Sun 8.30am-9.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (372, 'Mon-Fri 10.00am-6.30pm Sat 10.00-1.30pm', 'Mon-Fri 10.00am-6.30pm Sat 10.00-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (373, 'Mon-Fri 8.30am-9.30am 4.00pm-7.00pm', 'Mon-Fri 8.30am-9.30am 4.00pm-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (374, 'Mon-Fri 8.30am-6.30pm Sat 8.30am-10.00am', 'Mon-Fri 8.30am-6.30pm Sat 8.30am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (375, 'Mon-Fri 9.30am-6.30pm', 'Mon-Fri 9.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (376, 'Sun 2.30pm-5.00pm Last Sunday in April Third Sunday in June Second Sunday in September First Sunday in December', 'Sun 2.30pm-5.00pm Last Sunday in April Third Sunday in June Second Sunday in September First Sunday in December');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (377, 'Mon-Sun 8.00am-8.00pm', 'Mon-Sun 8.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (378, 'Mon-Fri 10.00am-2.00pm Sat 8.30am-1.30pm', 'Mon-Fri 10.00am-2.00pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (379, 'Mon-Fri 10.30am-3.30pm 7.00pm-8.30pm Sat 10.30am-4.30pm Sun Noon-4.30pm', 'Mon-Fri 10.30am-3.30pm 7.00pm-8.30pm Sat 10.30am-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (380, 'Mon-Fri 8.00am-10.00am 4.00pm-7.00pm Sat 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am 4.00pm-7.00pm Sat 8.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (381, 'Mon-Sat Noon-2.30pm', 'Mon-Sat Noon-2.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (382, 'Mon-Fri 6.30pm-8.30pm Sat Noon-4.30pm Sun Noon-4.30pm', 'Mon-Fri 6.30pm-8.30pm Sat Noon-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (383, 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm Sat 8.30am-1.30pm', 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (384, 'Mon-Sun 7.00pm-2.00am', 'Mon-Sun 7.00pm-2.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (385, 'Mon-Sat 10.00am-4.00pm', 'Mon-Sat 10.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (386, 'Mon-Fri 8.30am-7.00pm Sat 8.30am-1.30pm', 'Mon-Fri 8.30am-7.00pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (387, '8.00am-Midnight', '8.00am-Midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (388, 'Tue-Fri Midnight-8.30am Mon-Fri 6.30pm-Midnight Sat 1.30pm-Midnight Sun Midnight-6.00am', 'Tue-Fri Midnight-8.30am Mon-Fri 6.30pm-Midnight Sat 1.30pm-Midnight Sun Midnight-6.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (389, '8.30am-11.00pm', '8.30am-11.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (390, 'Mon-Fri 10.00am-4.00pm Sat 8.30am-1.30pm', 'Mon-Fri 10.00am-4.00pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (391, 'Mon-Fri 2.00pm-8.30pm Sat Noon-4.30pm Sun Noon-4.30pm', 'Mon-Fri 2.00pm-8.30pm Sat Noon-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (392, 'Mon-Fri 10.00am-4.00pm Sat 7.00am-7.00pm', 'Mon-Fri 10.00am-4.00pm Sat 7.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (394, '6.30pm-Midnight', '6.30pm-Midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (395, 'Mon-Sat 10.30am-3.30pm', 'Mon-Sat 10.30am-3.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (396, 'Mon-Fri 7.00am-7.00pm Sat 8.00am-1.30pm', 'Mon-Fri 7.00am-7.00pm Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (397, 'Mon-Sun 9.00am-8.00pm', 'Mon-Sun 9.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (398, 'Mon-Sat 8.30am-10.00am 4.00pm-6.30pm', 'Mon-Sat 8.30am-10.00am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (399, 'Mon-Sat 8.30am-6.30pm Sun 7.00am-4.00pm', 'Mon-Sat 8.30am-6.30pm Sun 7.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (400, 'Mon-Sun 7.00am-6.00pm', 'Mon-Sun 7.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (401, 'Mon-Fri 8.00am-7.00pm Sat 8.00am-6.30pm', 'Mon-Fri 8.00am-7.00pm Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (402, 'Mon-Sat 8.00am-9.30am 5.00pm-6.30pm', 'Mon-Sat 8.00am-9.30am 5.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (403, '6.30pm-9.00pm', '6.30pm-9.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (404, 'Mon-Sun 9.00am-5.00pm', 'Mon-Sun 9.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (405, 'Mon-Fri 7.00am-7.00pm Sat 8.30am-4.00pm', 'Mon-Fri 7.00am-7.00pm Sat 8.30am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (406, 'Mon-Fri 4.00pm-7.00pm', 'Mon-Fri 4.00pm-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (407, '8.00am-10.00am 4.00pm-6.30pm', '8.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (408, 'Mon-Fri 7.00am-6.30pm', 'Mon-Fri 7.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (409, 'Mon-Fri 8.30am-8.30pm Sat 8.30am-6.30pm Sun Noon-4.30pm', 'Mon-Fri 8.30am-8.30pm Sat 8.30am-6.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (410, 'Sat 10.00am-6.30pm', 'Sat 10.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (411, 'Mon-Fri 7.00am-8.30pm Sat 7.00am-7.00pm Sun Noon-4.30pm', 'Mon-Fri 7.00am-8.30pm Sat 7.00am-7.00pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (412, 'Mon-Fri 10.00am-Noon', 'Mon-Fri 10.00am-Noon');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (413, 'Mon-Fri 8.00am-10.00am 4.00pm-7.00pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-10.00am 4.00pm-7.00pm Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (414, 'Mon-Fri 7.00am-6.30pm Sat 8.30am-1.30pm', 'Mon-Fri 7.00am-6.30pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (415, 'Mon-Sat 7.00am-Midnight', 'Mon-Sat 7.00am-Midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (416, 'Mon-Fri 7.00am-10.00am 4.30pm-6.30pm', 'Mon-Fri 7.00am-10.00am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (417, 'Mon-Fri 7.00am-7.00pm Sat 7.00am-7.00pm', 'Mon-Fri 7.00am-7.00pm Sat 7.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (418, 'Mon-Fri 8.00am-10.00am 4.00pm-7.00pm', 'Mon-Fri 8.00am-10.00am 4.00pm-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (419, 'Mon-Fri 7.00pm-8.30pm Sat 8.30am-4.30pm Sun Noon-4.30pm', 'Mon-Fri 7.00pm-8.30pm Sat 8.30am-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (420, 'Mon-Sat 9.00am-4.00pm', 'Mon-Sat 9.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (421, 'Mon-Fri 1.30pm-6.30pm', 'Mon-Fri 1.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (422, 'Mon-Fri 7.00am-9.00am 4.00pm-6.00pm', 'Mon-Fri 7.00am-9.00am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (423, 'Mon-Fri 8.30am-10.30am 4.00pm-6.30pm Sat 8.30am-10.00am', 'Mon-Fri 8.30am-10.30am 4.00pm-6.30pm Sat 8.30am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (424, 'Mon-Fri 8.00am-9.30am 5.00pm-6.30pm', 'Mon-Fri 8.00am-9.30am 5.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (425, 'Mon-Sat 6.30pm-Midnight', 'Mon-Sat 6.30pm-Midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (426, 'Mon-Fri 8.00am-8.30pm Sat 8.00am-4.30pm Sun Noon-4.30pm', 'Mon-Fri 8.00am-8.30pm Sat 8.00am-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (427, '8.30am-9.00pm', '8.30am-9.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (428, 'Mon-Fri 10.00am-2.00pm', 'Mon-Fri 10.00am-2.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (429, 'Mon-Fri 8.00am-6.30pm Sat 8.00am-1.30pm', 'Mon-Fri 8.00am-6.30pm Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (430, 'Mon-Fri 7.30am-9.30am', 'Mon-Fri 7.30am-9.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (431, 'Mon-Fri 8.00am-8.30pm Sat 8.00am-6.30pm Sun Noon-4.30pm', 'Mon-Fri 8.00am-8.30pm Sat 8.00am-6.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (432, 'Mon-Fri 7.00am-8.30pm Sat Noon-4.30 Sun Noon-4.30pm', 'Mon-Fri 7.00am-8.30pm Sat Noon-4.30 Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (433, 'Mon-Fri 8.30am-8.30pm Sat 8.30am-4.30pm Sun Noon-4.30pm', 'Mon-Fri 8.30am-8.30pm Sat 8.30am-4.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (434, 'Mon-Thu 1.00pm-Midnight Fri-Sun 11.00pm-Midnight Midnight-7.00am', 'Mon-Thu 1.00pm-Midnight Fri-Sun 11.00pm-Midnight Midnight-7.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (435, 'Mon-Fri 8.30am-7.00pm', 'Mon-Fri 8.30am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (436, 'Mon-Sat 7.00am-10.00am 4.00pm-7.00pm', 'Mon-Sat 7.00am-10.00am 4.00pm-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (437, '8.30am-9.45am Noon-2.00pm 3.15pm-4.45pm term time only', '8.30am-9.45am Noon-2.00pm 3.15pm-4.45pm term time only');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (438, 'Mon-Fri 8.00am-4.30pm', 'Mon-Fri 8.00am-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (439, 'Mon-Fri 7.00am-10.00am', 'Mon-Fri 7.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (440, 'Mon-Fri 8.00am-8.30pm Sat 8.00am-7.00pm Sun Noon-4.30pm', 'Mon-Fri 8.00am-8.30pm Sat 8.00am-7.00pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (441, 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm Sat 8.00am-1.30pm', 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm Sat 8.00am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (442, 'Mon-Fri 11.00am-6.00am', 'Mon-Fri 11.00am-6.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (444, 'Mon-Fri 8.30am-6.30pm Sat-Sun Noon-4.30pm', 'Mon-Fri 8.30am-6.30pm;Sat-Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (447, 'Mon-Fri 8.00am-10.00pm Sat&Public Hols 8.00am-6.30pm Sun 1.00pm-6.30pm', 'Mon-Fri 8.00am-10.00pm; Sat & Public Hols 8.00am-6.30pm; Sun 1.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (448, 'Mon-Sat 7.00am-8.30pm Sun Noon-4.30pm', 'Mon-Sat 7.00am-8.30pm Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (449, 'Mon-Fri 10.00am-8.00pm Sat-Sun Noon-4.30pm', 'Mon-Fri 10.00am-8.00pm Sat-Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (450, 'Mon-Fri 8.30am-8.30pm Sat-Sun Noon-4.30pm', 'Mon-Fri 8.30am-8.30pm Sat-Sun Noon-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (451, 'Mon-Sun 7.00am-10.00pm', 'Mon-Sun 7.00am-10.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (452, 'Mon-Sat 8.00am-9.00am 4.00pm-7.00pm', 'Mon-Sat 8.00am-9.00am 4.00pm-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (453, 'Mon-Fri 8.30am-8.30pm Sat 8.30am-4.30pm Sun Noon-4.00pm', 'Mon-Fri 8.30am-8.30pm Sat 8.30am-4.30pm Sun Noon-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (454, 'Mon-Fri 5.30pm-3.00am', 'Mon-Fri 5.30pm-3.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (455, 'Mon-Fri 6.00am-8.00pm Sat 8.30am-1.30pm', 'Mon-Fri 6.00am-8.00pm Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (456, 'Mon-Sat 7.00am-10.00am 4.00pm-6.30pm', 'Mon-Sat 7.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (457, 'Mon-Sun 7.00am-6.30pm', 'Mon-Sun 7.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (458, 'Mon-Fri 8.00am-4.00pm Sat 8.00am-6.30pm', 'Mon-Fri 8.00am-4.00pm Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (459, 'Mon-Fri 9.30am-4.30pm Sat 8.00am-6.30pm Sun 10.00am-5.00pm', 'Mon-Fri 9.30am-4.30pm Sat 8.00am-6.30pm Sun 10.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (460, 'Mon-Sat 10.00am-6.30pm', 'Mon-Sat 10.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (461, 'Mon-Fri 9.00am-4.00pm Sat 8.00am-6.30pm', 'Mon-Fri 9.00am-4.00pm Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (462, 'Mon-Fri 9.00am-4.30pm Sat 8.00am-6.30pm', 'Mon-Fri 9.00am-4.30pm Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (463, 'Mon-Fri 9.30am-4.30pm Sat 8.00am-6.30pm', 'Mon-Fri 9.30am-4.30pm Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (465, 'Mon-Sun 9.00am-6.30pm', 'Mon-Sun 9.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (466, 'Mon-Fri 10.00am-5.00pm', 'Mon-Fri 10.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (467, '1.00pm-6.00pm', '1.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (468, 'Mon-Sun 8.30am-10.00pm', 'Mon-Sun 8.30am-10.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (469, 'Mon-Fri 7.00am-7.00pm Sat 7.00am-1.00pm', 'Mon-Fri 7.00am-7.00pm Sat 7.00am-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (470, 'Mon-Fri 8.00am-9.30am 2.45pm-4.15pm', 'Mon-Fri 8.00am-9.30am 2.45pm-4.15pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (471, 'Mon-Fri Midnight-7.00am 7.00pm-Midnight Sat & Sun Midnight-9.00am 6.00pm-Midnight', 'Mon-Fri Midnight-7.00am 7.00pm-Midnight;Sat & Sun Midnight-9.00am 6.00pm-Midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (472, '9.00am-5.00pm', '9.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (473, 'Mon-Fri 10.00am-3.00pm', 'Mon-Fri 10.00am-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (474, '10.00am-2.00pm', '10.00am-2.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (475, 'Mon-Sat 8.00am-10.00pm', 'Mon-Sat 8.00am-10.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (476, '8.00am-8.00pm', '8.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (477, 'Sat & Sun 8.00am-2.00pm', 'Sat & Sun 8.00am-2.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (478, 'Mon-Fri 11.00am-1.00pm', 'Mon-Fri 11.00am-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (479, 'Mon-Sat 8.00am-5.00pm', 'Mon-Sat 8.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (480, 'Mon-Fri 9.00am-6.00pm', 'Mon-Fri 9.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (481, 'Mon-Sat 9.30am-4.00pm', 'Mon-Sat 9.30am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (482, 'Mon-Sat 10.30am-11.30am', 'Mon-Sat 10.30am-11.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (484, '7.00am-11.00am', '7.00am-11.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (485, 'Mon-Sat 9.00am-10.00am', 'Mon-Sat 9.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (486, 'Mon-Fri 9.15am-2.30pm', 'Mon-Fri 9.15am-2.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (487, 'Mon-Fri 8.30.00am-10.00am', 'Mon-Fri 8.30.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (488, 'Mon-Fri 8.30am-9.30am', 'Mon-Fri 8.30am-9.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (489, 'Mon-Fri 9.15am-10.00am', 'Mon-Fri 9.15am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (490, 'Mon-Sat 8.00am-9.30am', 'Mon-Sat 8.00am-9.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (491, 'Mon-Sat 6.00am-9.00pm', 'Mon-Sat 6.00am-9.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (492, '6.00am-9.00pm', '6.00am-9.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (493, '11.00am-10.00pm', '11.00am-10.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (494, 'Mon-Sat 8.30am-8.00pm', 'Mon-Sat 8.30am-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (495, '8.00am-8.30pm', '8.00am-8.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (496, 'Mon-Sat 4.00pm-7.00pm', 'Mon-Sat 4.00pm-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (497, '8.00am-6.30pm', '8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (498, '9.30am-6.30pm', '9.30am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (499, '7.30am-6.00pm', '7.30am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (500, 'Mon-Fri 8.00am-10.30am', 'Mon-Fri 8.00am-10.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (501, 'Mon-Sat 10.00am-3.00pm', 'Mon-Sat 10.00am-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (502, '6.00am-6.00pm', '6.00am-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (503, 'Mon-Sat 8.00am-8.00pm', 'Mon-Sat 8.00am-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (504, 'Mon-Fri 12.00pm-1.00pm', 'Mon-Fri 12.00pm-1.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (505, '6.00pm-midnight midnight-6.00am', '6.00pm-midnight midnight-6.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (506, 'Mon-Fri 8.15am-9.15am 3.00pm-4.15pm', 'Mon-Fri 8.15am-9.15am 3.00pm-4.15pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (507, 'Mon-Fri midnight-10.30am 11.30am-midnight', 'Mon-Fri midnight-10.30am 11.30am-midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (508, 'Mon-Fri midnight-8.00am 10.00am-midnight and Sat & Sun', 'Mon-Fri midnight-8.00am 10.00am-midnight and Sat & Sun');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (509, 'Mon 6.00am-10.30pm Tues & Thurs 6.00am-7.00pm', 'Mon 6.00am-10.30pm Tues & Thurs 6.00am-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (510, 'Mon-Fri 8.00am-9.15am 2.45pm-3.30pm', 'Mon-Fri 8.00am-9.15am 2.45pm-3.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (511, '6.00pm-midnight midnight-7.30am', '6.00pm-midnight midnight-7.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (512, '6.30pm-midnight midnight-8.30am', '6.30pm-midnight midnight-8.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (513, 'Mon-Fri midnight-10.30am 11.30am-midnight and Sat & Sun', 'Mon-Fri midnight-10.30am 11.30am-midnight and Sat & Sun');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (514, 'Mon-Fri midnight-8.00am 9.30am-midnight', 'Mon-Fri midnight-8.00am 9.30am-midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (515, 'Mon-Fri midnight-8.00am 9.30am-midnight and Sat & Sun', 'Mon-Fri midnight-8.00am 9.30am-midnight and Sat & Sun');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (516, '9.00pm-midnight midnight-5.00am', '9.00pm-midnight midnight-5.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (517, 'Mon-Fri 8.00am-9.15am 3.00pm-4.15pm', 'Mon-Fri 8.00am-9.15am 3.00pm-4.15pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (518, 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm and Sat 10.00am-4.00pm', 'Mon-Fri 7.00am-10.00am 4.00pm-7.00pm and Sat 10.00am-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (519, 'Mon-Fri 8.30am-9.15am 2.45pm-3.45pm', 'Mon-Fri 8.30am-9.15am 2.45pm-3.45pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (520, 'Mon-Fri midnight-8.30am 10.00am-midnight', 'Mon-Fri midnight-8.30am 10.00am-midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (521, 'Mon-Fri 8.30am-9.15am 2.45pm-4.00pm', 'Mon-Fri 8.30am-9.15am 2.45pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (522, 'Mon-Fri 8.00am-10.00am 2.00pm-4.00pm', 'Mon-Fri 8.00am-10.00am 2.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (523, 'Mon-Fri midnight-8.30am 10.00am-midnight and Sat & Sun', 'Mon-Fri midnight-8.30am 10.00am-midnight and Sat & Sun');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (524, '8.15am-9.15am 3.00pm-4.15pm', '8.15am-9.15am 3.00pm-4.15pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (464, 'Mon-Sat 8.00am-6.30pm Sun 10.00am-5.00pm', 'Mon-Sat 8.00am-6.30pm Sun 10.00am-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (483, NULL, NULL);
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (525, 'Mon-Fri 8.15.00am-9.15am 3.00pm-4.00pm', 'Mon-Fri 8.15.00am-9.15am 3.00pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (526, 'midnight-8.00am 6.30pm-midnight', 'midnight-8.00am 6.30pm-midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (527, 'Mon-Fri 8.00am-9.30am Sat & Sun 8.00am-2.00pm', 'Mon-Fri 8.00am-9.30am Sat & Sun 8.00am-2.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (528, 'Mon-Fri midnight-9.15am 2.30pm-midnight and Sat & Sun', 'Mon-Fri midnight-9.15am 2.30pm-midnight and Sat & Sun');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (529, 'Mon-Fri 11.30am-midnight midnight-10.30am', 'Mon-Fri 11.30am-midnight midnight-10.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (530, 'Mon-Fri 8.00am-9.00am 4.30pm-6.30pm', 'Mon-Fri 8.00am-9.00am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (531, 'Mon-Fri 8.30am-9.00am 3.30pm-4.00pm', 'Mon-Fri 8.30am-9.00am 3.30pm-4.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (546, 'Mon-Fri 9.30am-10.30am 3.30pm-4.30pm', 'Mon-Fri 9.30am-10.30am 3.30pm-4.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (547, 'Mon-Fri 8.00am-10.00am 4.00pm-6.30pm', 'Mon-Fri 8.00am-10.00am 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (548, '8.30am-midnight', '8.30am-midnight');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (549, 'Mon-Sun 10.00pm-5.00am', 'Mon-Sun 10.00pm-5.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (550, 'Sat 7.00am-3.00pm', 'Sat 7.00am-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (551, 'Mon-Fri 8.00am-10.00am 4.30pm-6.30pm Sat 8.00am-6.30pm', 'Mon-Fri 8.00am-10.00am 4.30pm-6.30pm Sat 8.00am-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (552, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-8.00pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (553, 'Mon-Fri 8.30am-10.00am 4.00pm-7.00pm', 'Mon-Fri 8.30am-10.00am 4.00pm-7.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (554, 'Mon-Fri 8.30am-10.00am 4.00pm-6.30pm Sat 8.30am-10.00pm', 'Mon-Fri 8.30am-10.00am 4.00pm-6.30pm Sat 8.30am-10.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (555, 'Mon-Sat 8.30am-1.30pm', 'Mon-Sat 8.30am-1.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (556, 'Mon-Fri 8.30am-6.30pm Sat 7.00am-3.00pm', 'Mon-Fri 8.30am-6.30pm Sat 7.00am-3.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (557, 'Mon-Sat 8.30am-9.30am', 'Mon-Sat 8.30am-9.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (558, 'Mon-Sat 8.00am-9.00am 3.00pm-5.00pm', 'Mon-Sat 8.00am-9.00am 3.00pm-5.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (559, 'Mon-Fri 8.00am-10.00am 4.30pm-6.30pm Sat 8.00am-10.00am', 'Mon-Fri 8.00am-10.00am 4.30pm-6.30pm Sat 8.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (560, 'Mon-Sat 4.00pm-6.30pm', 'Mon-Sat 4.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (561, 'Mon-Sat 8.30am-10.00am 4.00pm-6.00pm', 'Mon-Sat 8.30am-10.00am 4.00pm-6.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (562, 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm Sun 8.30am-8.00pm', 'Mon-Fri 8.30am-10.00pm Sat 8.30am-6.30pm Sun 8.30am-8.00pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (563, 'Mon-Fri 8.30am-6.30pm Sat 8.00am-10.00am', 'Mon-Fri 8.30am-6.30pm Sat 8.00am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (564, 'Mon-Fri 8.30am-10.00am 4.30pm-6.30pm Sat 8.30am-10.00am', 'Mon-Fri 8.30am-10.00am 4.30pm-6.30pm Sat 8.30am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (565, 'Mon-Fri 8.30am-10.00am 4.00pm-6.30pm Sat 8.30am-10.00am', 'Mon-Fri 8.30am-10.00am 4.00pm-6.30pm Sat 8.30am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (566, 'Mon-Fri midday-6.30pm', 'Mon-Fri midday-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (567, 'Mon-Sat 8.30am-10.00am', 'Mon-Sat 8.30am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (568, 'Mon-Sat 8.30am-10.00am 4.30pm-6.30pm', 'Mon-Sat 8.30am-10.00am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (569, 'Mon-Fri 7.00am-10.00am Sat 8.30am-10.00am', 'Mon-Fri 7.00am-10.00am Sat 8.30am-10.00am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (570, 'Mon-Fri 1.00pm-6.30pm', 'Mon-Fri 1.00pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (571, 'Mon-Fri 8.00am-10.00am 4.30pm-6.30pm', 'Mon-Fri 8.00am-10.00am 4.30pm-6.30pm');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (572, 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm Sat 8.00am-9.30am', 'Mon-Fri 8.00am-9.30am 4.30pm-6.30pm Sat 8.00am-9.30am');
INSERT INTO "public"."TimePeriods" ("Code", "Description", "LabelText") VALUES (573, 'Mon-Fri 8.30am-9.15am 3.15pm-4.00pm', 'Mon-Fri 8.30am-9.15am 3.15pm-4.00pm');


--
-- TOC entry 4785 (class 0 OID 0)
-- Dependencies: 524
-- Name: TimePeriods_Code_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('"public"."TimePeriods_Code_seq"', 572, true);


-- Completed on 2021-01-29 11:15:40

--
-- PostgreSQL database dump complete
--

