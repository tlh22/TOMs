--- add table for defining section break points (as distinct from corners)

CREATE SEQUENCE mhtc_operations."SectionBreakPoints_id_seq"
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

ALTER SEQUENCE mhtc_operations."SectionBreakPoints_id_seq"
    OWNER TO postgres;

GRANT ALL ON SEQUENCE mhtc_operations."SectionBreakPoints_id_seq" TO postgres;
GRANT SELECT, USAGE ON SEQUENCE mhtc_operations."SectionBreakPoints_id_seq" TO toms_admin, toms_operator, toms_public;

CREATE TABLE mhtc_operations."SectionBreakPoints"
(
    id integer NOT NULL DEFAULT nextval('mhtc_operations."SectionBreakPoints_id_seq"'::regclass),
    geom geometry(Point,27700),
    CONSTRAINT "SectionBreakPoinst_pkey" PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE mhtc_operations."SectionBreakPoints"
    OWNER to postgres;

GRANT ALL ON TABLE mhtc_operations."SectionBreakPoints" TO postgres;
GRANT ALL ON TABLE mhtc_operations."SectionBreakPoints" TO toms_admin, toms_operator;
GRANT SELECT ON TABLE mhtc_operations."SectionBreakPoints" TO toms_public;