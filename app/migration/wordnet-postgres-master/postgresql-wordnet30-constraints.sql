/*
ALTER TABLE frameref DROP CONSTRAINT fk_frameref_frameid;
ALTER TABLE frameref DROP CONSTRAINT fk_frameref_synsetid;
ALTER TABLE frameref DROP CONSTRAINT fk_frameref_wordid;
ALTER TABLE legacy2030 DROP CONSTRAINT fk_legacy_synsetid;
ALTER TABLE legacy2130 DROP CONSTRAINT fk_legacy2_synsetid;
ALTER TABLE lexlinkref DROP CONSTRAINT fk_lexlinkref_linkid;
ALTER TABLE lexlinkref DROP CONSTRAINT fk_lexlinkref_synset1id;
ALTER TABLE lexlinkref DROP CONSTRAINT fk_lexlinkref_synset2id;
ALTER TABLE lexlinkref DROP CONSTRAINT fk_lexlinkref_word1id;
ALTER TABLE lexlinkref DROP CONSTRAINT fk_lexlinkref_word2id;
ALTER TABLE morphref DROP CONSTRAINT fk_morphref_morphid;
ALTER TABLE morphref DROP CONSTRAINT fk_morphref_wordid;
ALTER TABLE sample DROP CONSTRAINT fk_sample_synsetid;
ALTER TABLE semlinkref DROP CONSTRAINT fk_semlinkref_linkid;
ALTER TABLE semlinkref DROP CONSTRAINT fk_semlinkref_synset1id;
ALTER TABLE semlinkref DROP CONSTRAINT fk_semlinkref_synset2id;
ALTER TABLE sense DROP CONSTRAINT fk_sense_synsetid;
ALTER TABLE sense DROP CONSTRAINT fk_sense_wordid;
ALTER TABLE sentenceref DROP CONSTRAINT fk_sentenceref_sentenceid;
ALTER TABLE sentenceref DROP CONSTRAINT fk_sentenceref_synsetid;
ALTER TABLE sentenceref DROP CONSTRAINT fk_sentenceref_wordid;
ALTER TABLE synset DROP CONSTRAINT fk_synset_categoryid;
ALTER TABLE vnexampleref DROP CONSTRAINT fk_vnexampleref_exampleid;
ALTER TABLE vnexampleref DROP CONSTRAINT fk_vnexampleref_frameid;
ALTER TABLE vnframeref DROP CONSTRAINT fk_vnframeref_classid;
ALTER TABLE vnframeref DROP CONSTRAINT fk_vnframeref_frameid;
ALTER TABLE vnframeref DROP CONSTRAINT fk_vnframeref_wordid;
ALTER TABLE vnrole DROP CONSTRAINT fk_vnrole_classid;
ALTER TABLE vnrole DROP CONSTRAINT fk_vnrole_roletypeid;
ALTER TABLE vnrole DROP CONSTRAINT fk_vnrole_wordid;
ALTER TABLE wordposition DROP CONSTRAINT fk_wordposition_synsetid;
ALTER TABLE wordposition DROP CONSTRAINT fk_wordposition_wordid;
ALTER TABLE xwnparselft DROP CONSTRAINT fk_xwnparselft_synsetid;
ALTER TABLE xwnwsd DROP CONSTRAINT fk_xwnwsd_synsetid;
DROP INDEX k_legacy1_synsetid2;
DROP INDEX k_legacy1_synsetid;
DROP INDEX k_legacy2_synsetid2;
DROP INDEX k_legacy2_synsetid;
DROP INDEX k_legacy_synsetid2;
DROP INDEX k_legacy_synsetid;
DROP INDEX k_legacysensekey1_sensekey;
DROP INDEX k_legacysensekey2_sensekey;
DROP INDEX k_legacysensekey_sensekey;
DROP INDEX k_lexlinkref_synset1id_word1id;
DROP INDEX k_lexlinkref_synset2id_word2id;
DROP INDEX k_morphref_morphid;
DROP INDEX k_morphref_wordid;
DROP INDEX k_sample_synsetid;
DROP INDEX k_semlinkref_synset1id;
DROP INDEX k_semlinkref_synset2id;
DROP INDEX k_sense_synsetid;
DROP INDEX k_sense_wordid;
DROP INDEX k_vnrole_wordid_synsetid;
DROP INDEX k_wnparselft_synsetid;
DROP INDEX unq_casedword_lemma;
DROP INDEX unq_morphdef_lemma;
DROP INDEX unq_vnclass_class;
DROP INDEX unq_vnexampledef_example;
DROP INDEX unq_vnframedef_all;
DROP INDEX unq_vnframeref_wordid_synsetid_frameid_classid;
DROP INDEX unq_vnrole_wordid_synsetid_classid_roletypeid_selrestrsid;
DROP INDEX unq_vnroletype_type;
DROP INDEX unq_vnselrestr_value_type;
DROP INDEX unq_vnselrestrs_selrestrs;
DROP INDEX unq_word_lemma;
DROP INDEX unq_xwnparselft_synsetid_parse_lft;
DROP INDEX unq_xwnwsd_synsetid_wsd_text;
ALTER TABLE casedword DROP CONSTRAINT pk_casedword;
ALTER TABLE framedef DROP CONSTRAINT pk_framedef;
ALTER TABLE frameref DROP CONSTRAINT pk_frameref;
ALTER TABLE legacy2021 DROP CONSTRAINT pk_legacy1;
ALTER TABLE legacy2030 DROP CONSTRAINT pk_legacy;
ALTER TABLE legacy2130 DROP CONSTRAINT pk_legacy2;
ALTER TABLE legacysensekey2021 DROP CONSTRAINT pk_legacysensekey1;
ALTER TABLE legacysensekey2030 DROP CONSTRAINT pk_legacysensekey;
ALTER TABLE legacysensekey2130 DROP CONSTRAINT pk_legacysensekey2;
ALTER TABLE lexlinkref DROP CONSTRAINT pk_lexlinkref;
ALTER TABLE morphdef DROP CONSTRAINT pk_morphdef;
ALTER TABLE morphref DROP CONSTRAINT pk_morphref;
ALTER TABLE sample DROP CONSTRAINT pk_sample;
ALTER TABLE semlinkref DROP CONSTRAINT pk_semlinkref;
ALTER TABLE sense DROP CONSTRAINT pk_sense;
ALTER TABLE sentencedef DROP CONSTRAINT pk_sentencedef;
ALTER TABLE sentenceref DROP CONSTRAINT pk_sentenceref;
ALTER TABLE synset DROP CONSTRAINT pk_synset;
ALTER TABLE vnclass DROP CONSTRAINT pk_vnclass;
ALTER TABLE vnexampledef DROP CONSTRAINT pk_vnexampledef;
ALTER TABLE vnexampleref DROP CONSTRAINT pk_vnexampleref;
ALTER TABLE vnframedef DROP CONSTRAINT pk_vnframedef;
ALTER TABLE vnframeref DROP CONSTRAINT pk_vnframeref;
ALTER TABLE vnrole DROP CONSTRAINT pk_vnrole;
ALTER TABLE vnroletype DROP CONSTRAINT pk_vnroletype;
ALTER TABLE vnselrestr DROP CONSTRAINT pk_vnselrestr;
ALTER TABLE vnselrestrs DROP CONSTRAINT pk_vnselrestrs;
ALTER TABLE word DROP CONSTRAINT pk_word;
ALTER TABLE wordposition DROP CONSTRAINT pk_wordposition;
ALTER TABLE casedword ADD CONSTRAINT pk_casedword PRIMARY KEY (wordid);
ALTER TABLE framedef ADD CONSTRAINT pk_framedef PRIMARY KEY (frameid);
ALTER TABLE frameref ADD CONSTRAINT pk_frameref PRIMARY KEY (synsetid,wordid,frameid);
ALTER TABLE legacy2021 ADD CONSTRAINT pk_legacy1 PRIMARY KEY (mapid);
ALTER TABLE legacy2030 ADD CONSTRAINT pk_legacy PRIMARY KEY (mapid);
ALTER TABLE legacy2130 ADD CONSTRAINT pk_legacy2 PRIMARY KEY (mapid);
ALTER TABLE legacysensekey2021 ADD CONSTRAINT pk_legacysensekey1 PRIMARY KEY (mapid,sensekey);
ALTER TABLE legacysensekey2030 ADD CONSTRAINT pk_legacysensekey PRIMARY KEY (mapid,sensekey);
ALTER TABLE legacysensekey2130 ADD CONSTRAINT pk_legacysensekey2 PRIMARY KEY (mapid,sensekey);
ALTER TABLE lexlinkref ADD CONSTRAINT pk_lexlinkref PRIMARY KEY (word1id,synset1id,word2id,synset2id,linkid);
ALTER TABLE morphdef ADD CONSTRAINT pk_morphdef PRIMARY KEY (morphid);
ALTER TABLE morphref ADD CONSTRAINT pk_morphref PRIMARY KEY(morphid,pos,wordid);
ALTER TABLE sample ADD CONSTRAINT pk_sample PRIMARY KEY (synsetid,sampleid);
ALTER TABLE semlinkref ADD CONSTRAINT pk_semlinkref PRIMARY KEY (synset1id,synset2id,linkid);
ALTER TABLE sense ADD CONSTRAINT pk_sense PRIMARY KEY (synsetid,wordid);
ALTER TABLE sentencedef ADD CONSTRAINT pk_sentencedef PRIMARY KEY(sentenceid);
ALTER TABLE sentenceref ADD CONSTRAINT pk_sentenceref PRIMARY KEY (synsetid,wordid,sentenceid);
ALTER TABLE synset ADD CONSTRAINT pk_synset PRIMARY KEY (synsetid);
ALTER TABLE vnclass ADD CONSTRAINT pk_vnclass PRIMARY KEY (classid);
ALTER TABLE vnexampledef ADD CONSTRAINT pk_vnexampledef PRIMARY KEY (exampleid);
ALTER TABLE vnexampleref ADD CONSTRAINT pk_vnexampleref PRIMARY KEY (frameid,exampleid);
ALTER TABLE vnframedef ADD CONSTRAINT pk_vnframedef PRIMARY KEY (frameid);
ALTER TABLE vnframeref ADD CONSTRAINT pk_vnframeref PRIMARY KEY (framerefid);
ALTER TABLE vnrole ADD CONSTRAINT pk_vnrole PRIMARY KEY (roleid);
ALTER TABLE vnroletype ADD CONSTRAINT pk_vnroletype PRIMARY KEY (roletypeid);
ALTER TABLE vnselrestr ADD CONSTRAINT pk_vnselrestr PRIMARY KEY (selrestrid);
ALTER TABLE vnselrestrs ADD CONSTRAINT pk_vnselrestrs PRIMARY KEY (selrestrsid);
ALTER TABLE word ADD CONSTRAINT pk_word PRIMARY KEY (wordid);
ALTER TABLE wordposition ADD CONSTRAINT pk_wordposition PRIMARY KEY (synsetid,wordid);
CREATE UNIQUE INDEX unq_casedword_lemma ON casedword (lemma);
CREATE UNIQUE INDEX unq_morphdef_lemma ON morphdef (lemma);
CREATE UNIQUE INDEX unq_vnclass_class ON vnclass (class);
CREATE UNIQUE INDEX unq_vnexampledef_example ON vnexampledef (example);
CREATE UNIQUE INDEX unq_vnframedef_all ON vnframedef (number,xtag,description1,description2,syntax,semantics);
CREATE UNIQUE INDEX unq_vnframeref_wordid_synsetid_frameid_classid ON vnframeref (wordid,synsetid,frameid,classid);
CREATE UNIQUE INDEX unq_vnrole_wordid_synsetid_classid_roletypeid_selrestrsid ON vnrole (wordid,synsetid,classid,roletypeid,selrestrsid);
CREATE UNIQUE INDEX unq_vnroletype_type ON vnroletype (type);
CREATE UNIQUE INDEX unq_vnselrestr_value_type ON vnselrestr (value,type);
CREATE UNIQUE INDEX unq_vnselrestrs_selrestrs ON vnselrestrs (selrestrs);
CREATE UNIQUE INDEX unq_word_lemma ON word (lemma);
CREATE UNIQUE INDEX unq_xwnparselft_synsetid_parse_lft ON xwnparselft (synsetid,parse,lft);
CREATE UNIQUE INDEX unq_xwnwsd_synsetid_wsd_text ON xwnwsd (synsetid,wsd,text);
CREATE INDEX k_legacy1_synsetid ON legacy2021 (synsetid);
CREATE INDEX k_legacy1_synsetid2 ON legacy2021 (synsetid2);
CREATE INDEX k_legacy2_synsetid ON legacy2130 (synsetid);
CREATE INDEX k_legacy2_synsetid2 ON legacy2130 (synsetid2);
CREATE INDEX k_legacy_synsetid ON legacy2030 (synsetid);
CREATE INDEX k_legacy_synsetid2 ON legacy2030 (synsetid2);
CREATE INDEX k_legacysensekey1_sensekey ON legacysensekey2021 (sensekey);
CREATE INDEX k_legacysensekey2_sensekey ON legacysensekey2130 (sensekey);
CREATE INDEX k_legacysensekey_sensekey ON legacysensekey2030 (sensekey);
CREATE INDEX k_lexlinkref_synset1id_word1id ON lexlinkref (synset1id,word1id);
CREATE INDEX k_lexlinkref_synset2id_word2id ON lexlinkref (synset2id,word2id);
CREATE INDEX k_morphref_morphid ON morphref (morphid);
CREATE INDEX k_morphref_wordid ON morphref (wordid);
CREATE INDEX k_sample_synsetid ON sample (synsetid);
CREATE INDEX k_semlinkref_synset1id ON semlinkref (synset1id);
CREATE INDEX k_semlinkref_synset2id ON semlinkref (synset2id);
CREATE INDEX k_sense_synsetid ON sense (synsetid);
CREATE INDEX k_sense_wordid ON sense (wordid);
CREATE INDEX k_vnrole_wordid_synsetid ON vnrole (wordid,synsetid);
CREATE INDEX k_wnparselft_synsetid ON xwnparselft (synsetid);
ALTER TABLE frameref ADD CONSTRAINT fk_frameref_frameid FOREIGN KEY (frameid) REFERENCES framedef(frameid);
ALTER TABLE frameref ADD CONSTRAINT fk_frameref_synsetid FOREIGN KEY (synsetid) REFERENCES synset(synsetid);
ALTER TABLE frameref ADD CONSTRAINT fk_frameref_wordid FOREIGN KEY (wordid) REFERENCES word(wordid);
ALTER TABLE legacy2030 ADD CONSTRAINT fk_legacy_synsetid FOREIGN KEY (synsetid) REFERENCES synset(synsetid);
ALTER TABLE legacy2130 ADD CONSTRAINT fk_legacy2_synsetid FOREIGN KEY (synsetid) REFERENCES synset(synsetid);
ALTER TABLE lexlinkref ADD CONSTRAINT fk_lexlinkref_linkid FOREIGN KEY (linkid) REFERENCES linkdef (linkid);
ALTER TABLE lexlinkref ADD CONSTRAINT fk_lexlinkref_synset1id FOREIGN KEY (synset1id) REFERENCES synset (synsetid);
ALTER TABLE lexlinkref ADD CONSTRAINT fk_lexlinkref_synset2id FOREIGN KEY (synset2id) REFERENCES synset (synsetid);
ALTER TABLE lexlinkref ADD CONSTRAINT fk_lexlinkref_word1id FOREIGN KEY (word1id) REFERENCES word (wordid);
ALTER TABLE lexlinkref ADD CONSTRAINT fk_lexlinkref_word2id FOREIGN KEY (word2id) REFERENCES word (wordid);
ALTER TABLE morphref ADD CONSTRAINT fk_morphref_morphid FOREIGN KEY (morphid) REFERENCES morphdef(morphid);
ALTER TABLE morphref ADD CONSTRAINT fk_morphref_wordid FOREIGN KEY (wordid) REFERENCES word(wordid);
ALTER TABLE sample ADD CONSTRAINT fk_sample_synsetid FOREIGN KEY (synsetid) REFERENCES synset(synsetid);
ALTER TABLE semlinkref ADD CONSTRAINT fk_semlinkref_linkid FOREIGN KEY (linkid) REFERENCES linkdef (linkid);
ALTER TABLE semlinkref ADD CONSTRAINT fk_semlinkref_synset1id FOREIGN KEY (synset1id) REFERENCES synset (synsetid);
ALTER TABLE semlinkref ADD CONSTRAINT fk_semlinkref_synset2id FOREIGN KEY (synset2id) REFERENCES synset (synsetid);
ALTER TABLE sense ADD CONSTRAINT fk_sense_synsetid FOREIGN KEY (synsetid) REFERENCES synset(synsetid);
ALTER TABLE sense ADD CONSTRAINT fk_sense_wordid FOREIGN KEY (wordid) REFERENCES word(wordid);
ALTER TABLE sentenceref ADD CONSTRAINT fk_sentenceref_sentenceid FOREIGN KEY (sentenceid) REFERENCES sentencedef(sentenceid);
ALTER TABLE sentenceref ADD CONSTRAINT fk_sentenceref_synsetid FOREIGN KEY (synsetid) REFERENCES synset(synsetid);
ALTER TABLE sentenceref ADD CONSTRAINT fk_sentenceref_wordid FOREIGN KEY (wordid) REFERENCES word(wordid);
ALTER TABLE synset ADD CONSTRAINT fk_synset_categoryid FOREIGN KEY (categoryid) REFERENCES categorydef (categoryid);
ALTER TABLE vnexampleref ADD CONSTRAINT fk_vnexampleref_exampleid FOREIGN KEY (exampleid) REFERENCES vnexampledef(exampleid);
ALTER TABLE vnexampleref ADD CONSTRAINT fk_vnexampleref_frameid FOREIGN KEY (frameid) REFERENCES vnframedef(frameid);
ALTER TABLE vnframeref ADD CONSTRAINT fk_vnframeref_classid FOREIGN KEY (classid) REFERENCES vnclass(classid);
ALTER TABLE vnframeref ADD CONSTRAINT fk_vnframeref_frameid FOREIGN KEY (frameid) REFERENCES vnframedef(frameid);
ALTER TABLE vnframeref ADD CONSTRAINT fk_vnframeref_wordid FOREIGN KEY (wordid) REFERENCES word(wordid);
ALTER TABLE vnrole ADD CONSTRAINT fk_vnrole_classid FOREIGN KEY (classid) REFERENCES vnclass(classid);
ALTER TABLE vnrole ADD CONSTRAINT fk_vnrole_roletypeid FOREIGN KEY (roletypeid) REFERENCES vnroletype(roletypeid);
ALTER TABLE vnrole ADD CONSTRAINT fk_vnrole_wordid FOREIGN KEY (wordid) REFERENCES word(wordid);
ALTER TABLE wordposition ADD CONSTRAINT fk_wordposition_synsetid FOREIGN KEY (synsetid) REFERENCES synset (synsetid);
ALTER TABLE wordposition ADD CONSTRAINT fk_wordposition_wordid FOREIGN KEY (wordid) REFERENCES word (wordid);
ALTER TABLE xwnparselft ADD CONSTRAINT fk_xwnparselft_synsetid FOREIGN KEY (synsetid) REFERENCES synset(synsetid);
ALTER TABLE xwnwsd ADD CONSTRAINT fk_xwnwsd_synsetid FOREIGN KEY (synsetid) REFERENCES synset(synsetid);
*/



CREATE INDEX k_legacy1_synsetid ON legacy2021 USING btree (synsetid);


--
-- Name: k_legacy1_synsetid2; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_legacy1_synsetid2 ON legacy2021 USING btree (synsetid2);


--
-- Name: k_legacy2_synsetid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_legacy2_synsetid ON legacy2130 USING btree (synsetid);


--
-- Name: k_legacy2_synsetid2; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_legacy2_synsetid2 ON legacy2130 USING btree (synsetid2);


--
-- Name: k_legacy_synsetid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_legacy_synsetid ON legacy2030 USING btree (synsetid);


--
-- Name: k_legacy_synsetid2; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_legacy_synsetid2 ON legacy2030 USING btree (synsetid2);


--
-- Name: k_legacysensekey1_sensekey; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_legacysensekey1_sensekey ON legacysensekey2021 USING btree (sensekey);


--
-- Name: k_legacysensekey2_sensekey; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_legacysensekey2_sensekey ON legacysensekey2130 USING btree (sensekey);


--
-- Name: k_legacysensekey_sensekey; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_legacysensekey_sensekey ON legacysensekey2030 USING btree (sensekey);


--
-- Name: k_lexlinkref_synset1id_word1id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_lexlinkref_synset1id_word1id ON lexlinkref USING btree (synset1id, word1id);


--
-- Name: k_lexlinkref_synset2id_word2id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_lexlinkref_synset2id_word2id ON lexlinkref USING btree (synset2id, word2id);


--
-- Name: k_morphref_morphid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_morphref_morphid ON morphref USING btree (morphid);


--
-- Name: k_morphref_wordid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_morphref_wordid ON morphref USING btree (wordid);


--
-- Name: k_sample_synsetid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_sample_synsetid ON sample USING btree (synsetid);


--
-- Name: k_semlinkref_synset1id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_semlinkref_synset1id ON semlinkref USING btree (synset1id);


--
-- Name: k_semlinkref_synset2id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_semlinkref_synset2id ON semlinkref USING btree (synset2id);


--
-- Name: k_sense_synsetid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_sense_synsetid ON sense USING btree (synsetid);


--
-- Name: k_sense_wordid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_sense_wordid ON sense USING btree (wordid);


--
-- Name: k_vnrole_wordid_synsetid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_vnrole_wordid_synsetid ON vnrole USING btree (wordid, synsetid);


--
-- Name: k_wnparselft_synsetid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX k_wnparselft_synsetid ON xwnparselft USING btree (synsetid);


--
-- Name: unq_casedword_lemma; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_casedword_lemma ON casedword USING btree (lemma);


--
-- Name: unq_morphdef_lemma; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_morphdef_lemma ON morphdef USING btree (lemma);


--
-- Name: unq_vnclass_class; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_vnclass_class ON vnclass USING btree ("class");


--
-- Name: unq_vnexampledef_example; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_vnexampledef_example ON vnexampledef USING btree (example);


--
-- Name: unq_vnframedef_all; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_vnframedef_all ON vnframedef USING btree (number, xtag, description1, description2, syntax, semantics);


--
-- Name: unq_vnframeref_wordid_synsetid_frameid_classid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_vnframeref_wordid_synsetid_frameid_classid ON vnframeref USING btree (wordid, synsetid, frameid, classid);


--
-- Name: unq_vnrole_wordid_synsetid_classid_roletypeid_selrestrsid; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_vnrole_wordid_synsetid_classid_roletypeid_selrestrsid ON vnrole USING btree (wordid, synsetid, classid, roletypeid, selrestrsid);


--
-- Name: unq_vnroletype_type; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_vnroletype_type ON vnroletype USING btree ("type");


--
-- Name: unq_vnselrestr_value_type; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_vnselrestr_value_type ON vnselrestr USING btree (value, "type");


--
-- Name: unq_vnselrestrs_selrestrs; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_vnselrestrs_selrestrs ON vnselrestrs USING btree (selrestrs);


--
-- Name: unq_word_lemma; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_word_lemma ON word USING btree (lemma);


--
-- Name: unq_xwnparselft_synsetid_parse_lft; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_xwnparselft_synsetid_parse_lft ON xwnparselft USING btree (synsetid, parse, lft);


--
-- Name: unq_xwnwsd_synsetid_wsd_text; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unq_xwnwsd_synsetid_wsd_text ON xwnwsd USING btree (synsetid, wsd, text);


--
-- PostgreSQL database dump complete
--

ALTER TABLE ONLY casedword
    ADD CONSTRAINT pk_casedword PRIMARY KEY (wordid);


--
-- Name: pk_category; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY categorydef
    ADD CONSTRAINT pk_category PRIMARY KEY (categoryid);


--
-- Name: pk_framedef; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY framedef
    ADD CONSTRAINT pk_framedef PRIMARY KEY (frameid);


--
-- Name: pk_frameref; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY frameref
    ADD CONSTRAINT pk_frameref PRIMARY KEY (synsetid, wordid, frameid);


--
-- Name: pk_legacy; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY legacy2030
    ADD CONSTRAINT pk_legacy PRIMARY KEY (mapid);


--
-- Name: pk_legacy1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY legacy2021
    ADD CONSTRAINT pk_legacy1 PRIMARY KEY (mapid);


--
-- Name: pk_legacy2; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY legacy2130
    ADD CONSTRAINT pk_legacy2 PRIMARY KEY (mapid);


--
-- Name: pk_legacysensekey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY legacysensekey2030
    ADD CONSTRAINT pk_legacysensekey PRIMARY KEY (mapid, sensekey);


--
-- Name: pk_legacysensekey1; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY legacysensekey2021
    ADD CONSTRAINT pk_legacysensekey1 PRIMARY KEY (mapid, sensekey);


--
-- Name: pk_legacysensekey2; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY legacysensekey2130
    ADD CONSTRAINT pk_legacysensekey2 PRIMARY KEY (mapid, sensekey);


--
-- Name: pk_lexlinkref; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY lexlinkref
    ADD CONSTRAINT pk_lexlinkref PRIMARY KEY (word1id, synset1id, word2id, synset2id, linkid);


--
-- Name: pk_linkdef; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY linkdef
    ADD CONSTRAINT pk_linkdef PRIMARY KEY (linkid);


--
-- Name: pk_morphdef; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY morphdef
    ADD CONSTRAINT pk_morphdef PRIMARY KEY (morphid);


--
-- Name: pk_morphref; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY morphref
    ADD CONSTRAINT pk_morphref PRIMARY KEY (morphid, pos, wordid);


--
-- Name: pk_sample; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT pk_sample PRIMARY KEY (synsetid, sampleid);


--
-- Name: pk_semlinkref; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY semlinkref
    ADD CONSTRAINT pk_semlinkref PRIMARY KEY (synset1id, synset2id, linkid);


--
-- Name: pk_sense; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY sense
    ADD CONSTRAINT pk_sense PRIMARY KEY (synsetid, wordid);


--
-- Name: pk_sentencedef; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY sentencedef
    ADD CONSTRAINT pk_sentencedef PRIMARY KEY (sentenceid);


--
-- Name: pk_sentenceref; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY sentenceref
    ADD CONSTRAINT pk_sentenceref PRIMARY KEY (synsetid, wordid, sentenceid);


--
-- Name: pk_synset; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY synset
    ADD CONSTRAINT pk_synset PRIMARY KEY (synsetid);


--
-- Name: pk_vnclass; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY vnclass
    ADD CONSTRAINT pk_vnclass PRIMARY KEY (classid);


--
-- Name: pk_vnexampledef; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY vnexampledef
    ADD CONSTRAINT pk_vnexampledef PRIMARY KEY (exampleid);


--
-- Name: pk_vnexampleref; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY vnexampleref
    ADD CONSTRAINT pk_vnexampleref PRIMARY KEY (frameid, exampleid);


--
-- Name: pk_vnframedef; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY vnframedef
    ADD CONSTRAINT pk_vnframedef PRIMARY KEY (frameid);


--
-- Name: pk_vnframeref; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY vnframeref
    ADD CONSTRAINT pk_vnframeref PRIMARY KEY (framerefid);


--
-- Name: pk_vnrole; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY vnrole
    ADD CONSTRAINT pk_vnrole PRIMARY KEY (roleid);


--
-- Name: pk_vnroletype; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY vnroletype
    ADD CONSTRAINT pk_vnroletype PRIMARY KEY (roletypeid);


--
-- Name: pk_vnselrestr; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY vnselrestr
    ADD CONSTRAINT pk_vnselrestr PRIMARY KEY (selrestrid);


--
-- Name: pk_vnselrestrs; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY vnselrestrs
    ADD CONSTRAINT pk_vnselrestrs PRIMARY KEY (selrestrsid);


--
-- Name: pk_word; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY word
    ADD CONSTRAINT pk_word PRIMARY KEY (wordid);


--
-- Name: pk_wordposition; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY wordposition
    ADD CONSTRAINT pk_wordposition PRIMARY KEY (synsetid, wordid);
