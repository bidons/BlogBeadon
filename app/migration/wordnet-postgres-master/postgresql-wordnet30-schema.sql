--
-- PostgreSQL database dump
--

CREATE TABLE casedword (
    wordid numeric(6,0) DEFAULT 0::numeric NOT NULL,
    lemma character varying(80) DEFAULT ''::character varying NOT NULL
);


--
-- Name: categorydef; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE categorydef (
    categoryid numeric(2,0) DEFAULT 0::numeric NOT NULL,
    name character varying(32),
    pos character(1)
);


--
-- Name: framedef; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE framedef (
    frameid numeric(2,0) DEFAULT 0::numeric NOT NULL,
    frame character varying(50)
);


--
-- Name: frameref; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE frameref (
    synsetid numeric(9,0) DEFAULT 0::numeric NOT NULL,
    wordid numeric(6,0) NOT NULL,
    frameid numeric(2,0) DEFAULT 0::numeric NOT NULL
);


--
-- Name: legacy2021; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE legacy2021 (
    mapid numeric(6,0) NOT NULL,
    synsetid numeric(9,0) NOT NULL,
    synsetid2 numeric(9,0) NOT NULL,
    score numeric(3,0)
);


--
-- Name: legacy2030; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE legacy2030 (
    mapid numeric(6,0) NOT NULL,
    synsetid numeric(9,0) NOT NULL,
    synsetid2 numeric(9,0) NOT NULL,
    score numeric(3,0)
);


--
-- Name: legacy2130; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE legacy2130 (
    mapid numeric(6,0) NOT NULL,
    synsetid numeric(9,0) NOT NULL,
    synsetid2 numeric(9,0) NOT NULL,
    score numeric(3,0)
);


--
-- Name: legacysensekey2021; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE legacysensekey2021 (
    mapid numeric(6,0) NOT NULL,
    sensekey character varying(100) DEFAULT ''::character varying NOT NULL
);


--
-- Name: legacysensekey2030; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE legacysensekey2030 (
    mapid numeric(6,0) NOT NULL,
    sensekey character varying(100) DEFAULT ''::character varying NOT NULL
);


--
-- Name: legacysensekey2130; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE legacysensekey2130 (
    mapid numeric(6,0) NOT NULL,
    sensekey character varying(100) DEFAULT ''::character varying NOT NULL
);


--
-- Name: lexlinkref; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE lexlinkref (
    synset1id numeric(9,0) DEFAULT 0::numeric NOT NULL,
    word1id numeric(6,0) DEFAULT 0::numeric NOT NULL,
    synset2id numeric(9,0) DEFAULT 0::numeric NOT NULL,
    word2id numeric(6,0) DEFAULT 0::numeric NOT NULL,
    linkid numeric(2,0) DEFAULT 0::numeric NOT NULL
);


--
-- Name: linkdef; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE linkdef (
    linkid numeric(2,0) DEFAULT 0::numeric NOT NULL,
    name character varying(50),
    recurses character(1) DEFAULT 'N'::bpchar NOT NULL
);


--
-- Name: morphdef; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE morphdef (
    morphid numeric(6,0) DEFAULT 0::numeric NOT NULL,
    lemma character varying(70) DEFAULT ''::character varying NOT NULL
);


--
-- Name: morphref; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE morphref (
    wordid numeric(6,0) DEFAULT 0::numeric NOT NULL,
    pos character(1) NOT NULL,
    morphid numeric(6,0) DEFAULT 0::numeric NOT NULL
);


--
-- Name: sample; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sample (
    synsetid numeric(9,0) DEFAULT 0::numeric NOT NULL,
    sampleid numeric(2,0) DEFAULT 0::numeric NOT NULL,
    sample text NOT NULL
);


--
-- Name: semlinkref; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE semlinkref (
    synset1id numeric(9,0) DEFAULT 0::numeric NOT NULL,
    synset2id numeric(9,0) DEFAULT 0::numeric NOT NULL,
    linkid numeric(2,0) DEFAULT 0::numeric NOT NULL
);


--
-- Name: sense; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sense (
    wordid numeric(6,0) DEFAULT 0::numeric NOT NULL,
    casedwordid numeric(6,0),
    synsetid numeric(9,0) DEFAULT 0::numeric NOT NULL,
    rank numeric(2,0) DEFAULT 0::numeric NOT NULL,
    lexid numeric(2,0) DEFAULT 0::numeric NOT NULL,
    tagcount numeric(5,0)
);


--
-- Name: sentencedef; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sentencedef (
    sentenceid numeric(3,0) DEFAULT 0::numeric NOT NULL,
    sentence text
);


--
-- Name: sentenceref; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sentenceref (
    synsetid numeric(9,0) DEFAULT 0::numeric NOT NULL,
    wordid numeric(6,0) DEFAULT 0::numeric NOT NULL,
    sentenceid numeric(3,0) DEFAULT 0::numeric NOT NULL
);


--
-- Name: synset; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE synset (
    synsetid numeric(9,0) DEFAULT 0::numeric NOT NULL,
    pos character(1),
    categoryid numeric(2,0) DEFAULT 0::numeric NOT NULL,
    definition text
);


--
-- Name: vnclass; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vnclass (
    classid numeric(3,0) NOT NULL,
    "class" character varying(64) NOT NULL
);


--
-- Name: vnexampledef; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vnexampledef (
    exampleid numeric(4,0) NOT NULL,
    example character varying(128) NOT NULL
);


--
-- Name: vnexampleref; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vnexampleref (
    frameid numeric(5,0) NOT NULL,
    exampleid numeric(4,0) NOT NULL
);


--
-- Name: vnframedef; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vnframedef (
    frameid numeric(5,0) NOT NULL,
    number character varying(16) NOT NULL,
    xtag character varying(16) NOT NULL,
    description1 character varying(64) NOT NULL,
    description2 character varying(64),
    syntax text NOT NULL,
    semantics text NOT NULL
);


--
-- Name: vnframeref; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vnframeref (
    framerefid numeric(5,0) NOT NULL,
    wordid numeric(6,0) NOT NULL,
    synsetid numeric(9,0),
    frameid numeric(5,0) NOT NULL,
    classid numeric(3,0) NOT NULL,
    quality integer
);


--
-- Name: vnrole; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vnrole (
    roleid numeric(6,0) NOT NULL,
    wordid numeric(6,0) NOT NULL,
    synsetid numeric(9,0),
    classid numeric(3,0) NOT NULL,
    rolesetid numeric(4,0) NOT NULL,
    roletypeid numeric(4,0) NOT NULL,
    selrestrsid numeric(2,0) NOT NULL,
    quality integer
);


--
-- Name: vnroletype; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vnroletype (
    roletypeid numeric(3,0) NOT NULL,
    "type" character varying(32) NOT NULL
);


--
-- Name: vnselrestr; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vnselrestr (
    selrestrid numeric(5,0) NOT NULL,
    value character varying(32) NOT NULL,
    "type" character varying(32) NOT NULL
);


--
-- Name: vnselrestrs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE vnselrestrs (
    selrestrsid numeric(2,0) NOT NULL,
    selrestrs text NOT NULL
);


--
-- Name: word; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE word (
    wordid numeric(6,0) DEFAULT 0::numeric NOT NULL,
    lemma character varying(80) DEFAULT ''::character varying NOT NULL
);


--
-- Name: wordposition; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wordposition (
    synsetid numeric(9,0) DEFAULT 0::numeric NOT NULL,
    wordid numeric(6,0) DEFAULT 0::numeric NOT NULL,
    positionid character(2) DEFAULT 'a'::bpchar NOT NULL
);


--
-- Name: xwnparselft; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE xwnparselft (
    synsetid numeric(9,0) NOT NULL,
    parse text NOT NULL,
    lft text NOT NULL,
    parsequality integer,
    lftquality integer
);


--
-- Name: xwnwsd; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE xwnwsd (
    synsetid numeric(9,0) NOT NULL,
    wsd text NOT NULL,
    text text
);


--
-- Name: pk_casedword; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--


--
-- Name: k_legacy1_synsetid; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--
