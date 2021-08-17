CREATE SCHEMA IF NOT EXISTS pr_zh;

CREATE SEQUENCE pr_zh.bib_actions_id_action_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE pr_zh.cor_lim_list_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE pr_zh.cor_main_fct_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE pr_zh.t_activity_id_activity_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE pr_zh.t_management_plans_id_plan_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE pr_zh.t_management_structures_id_structure_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE pr_zh.t_references_id_reference_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE pr_zh.t_urban_planning_docs_id_doc_seq START WITH 1 INCREMENT BY 1;

CREATE SEQUENCE pr_zh.t_zh_id_zh_seq START WITH 1 INCREMENT BY 1;

CREATE  TABLE pr_zh.bib_actions ( 
	id_action            integer DEFAULT nextval('pr_zh.bib_actions_id_action_seq'::regclass) NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	CONSTRAINT pk_bib_actions_id_action PRIMARY KEY ( id_action )
 );

CREATE  TABLE pr_zh.bib_cb ( 
	lb_code              varchar(50)  NOT NULL ,
	humidity             varchar(1)  NOT NULL ,
	is_ch                boolean  NOT NULL ,
	CONSTRAINT pk_cor_cb_humidity_lb_code PRIMARY KEY ( lb_code )
 );

COMMENT ON TABLE pr_zh.bib_cb IS 'Correspondance entre code les Corines Biotopes et la variable humidité';

COMMENT ON COLUMN pr_zh.bib_cb.humidity IS 'H = humide ou P = potentiellement humide';

COMMENT ON COLUMN pr_zh.bib_cb.is_ch IS 'true si le Corine Biotope est utilisé pour la liste des cahiers habitats des zones humides';

CREATE  TABLE pr_zh.bib_organismes ( 
	id_org               integer  NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	abbrevation          varchar(6) DEFAULT 'XXXXXX' NOT NULL ,
	is_op_org            boolean DEFAULT true NOT NULL ,
	CONSTRAINT pk_t_organismes_id_org PRIMARY KEY ( id_org )
 );

COMMENT ON TABLE pr_zh.bib_organismes IS 'Liste des organismes qui assurent la gestion de zh';

COMMENT ON COLUMN pr_zh.bib_organismes.abbrevation IS 'abbreviation used for creating the zh code';

COMMENT ON COLUMN pr_zh.bib_organismes.is_op_org IS 'is it an operator organism (not management structure)';

CREATE  TABLE pr_zh.bib_site_space ( 
	id_site_space        integer  NOT NULL ,
	name                 varchar(255)  NOT NULL ,
	CONSTRAINT pk_bib_site_space_id_site_space PRIMARY KEY ( id_site_space )
 );

COMMENT ON TABLE pr_zh.bib_site_space IS 'Liste of site space';

COMMENT ON COLUMN pr_zh.bib_site_space.name IS 'site space name';

CREATE  TABLE pr_zh.cor_impact_types ( 
	id_cor_impact_types  integer  NOT NULL ,
	id_impact            integer  NOT NULL ,
	id_impact_type       integer   ,
	active               boolean DEFAULT true NOT NULL ,
	CONSTRAINT unq_cor_impact_types_id_impact UNIQUE ( id_impact ) ,
	CONSTRAINT pk_cor_impact_types_id_impact PRIMARY KEY ( id_cor_impact_types )
 );

CREATE  TABLE pr_zh.cor_lim_list ( 
	id_lim_list          uuid  NOT NULL ,
	id_lim               integer  NOT NULL ,
	CONSTRAINT pk_cor_lim_list PRIMARY KEY ( id_lim_list, id_lim )
 );

COMMENT ON TABLE pr_zh.cor_lim_list IS 'Correspondance entre zh et critères de délimitation de la zone humide';

CREATE  TABLE pr_zh.cor_main_fct ( 
	id_function          integer  NOT NULL ,
	id_main_function     integer   ,
	active               boolean DEFAULT true NOT NULL ,
	CONSTRAINT pk_cor_main_fct PRIMARY KEY ( id_function )
 );

COMMENT ON TABLE pr_zh.cor_main_fct IS 'Correspondance entre grandes fonctions et fonctions';

CREATE  TABLE pr_zh.cor_protection_level_type ( 
	id_protection        integer  NOT NULL ,
	id_protection_status integer  NOT NULL ,
	id_protection_type   integer   ,
	id_protection_level  integer  NOT NULL ,
	CONSTRAINT pk_cor_protection_level_type_id_protection PRIMARY KEY ( id_protection )
 );

COMMENT ON TABLE pr_zh.cor_protection_level_type IS 'statuts de protection';

CREATE  TABLE pr_zh.cor_sdage_sage ( 
	id_sdage             integer  NOT NULL ,
	id_sage              integer  NOT NULL ,
	CONSTRAINT pk_cor_sdage_sage PRIMARY KEY ( id_sdage, id_sage )
 );

COMMENT ON TABLE pr_zh.cor_sdage_sage IS 'table de correspondance entre les types SDAGE et sous-types SAGE';

COMMENT ON COLUMN pr_zh.cor_sdage_sage.id_sage IS 'id_nomenclature sage dans ref_nomenclatures.t_nomenclatures';

CREATE  TABLE pr_zh.cor_urban_type_range ( 
	id_cor               integer  NOT NULL ,
	id_range_type        integer  NOT NULL ,
	id_doc_type          integer  NOT NULL ,
	CONSTRAINT pk_cor_urban_type_range PRIMARY KEY ( id_cor )
 );

CREATE  TABLE pr_zh.cor_zh_area ( 
	id_area              integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	cover                integer   ,
	CONSTRAINT pk_t_municipalities PRIMARY KEY ( id_area, id_zh )
 );

COMMENT ON COLUMN pr_zh.cor_zh_area.cover IS 'couverture de la zh par rapport à la municipalité (en pourcentage)';

CREATE  TABLE pr_zh.t_fct_area ( 
	id_fct_area          integer  NOT NULL ,
	geom                 geometry  NOT NULL ,
	CONSTRAINT pk_t_fct_area_id_fct_area PRIMARY KEY ( id_fct_area )
 );

COMMENT ON TABLE pr_zh.t_fct_area IS 'Espaces de fonctionnalités';

CREATE  TABLE pr_zh.cor_zh_cb ( 
	id_zh                integer  NOT NULL ,
	lb_code              varchar(50)  NOT NULL ,
	CONSTRAINT pk_cor_zh_cb PRIMARY KEY ( id_zh, lb_code )
 );

COMMENT ON TABLE pr_zh.cor_zh_cb IS 'Correspondance zh et corine biotope';

CREATE  TABLE pr_zh.t_hydro_area ( 
	id_hydro             integer  NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	geom                 geometry  NOT NULL ,
	CONSTRAINT pk_t_hydro_area_id_hydro PRIMARY KEY ( id_hydro )
 );

COMMENT ON TABLE pr_zh.t_hydro_area IS 'zones hydrographiques';

COMMENT ON COLUMN pr_zh.t_hydro_area.name IS 'nom de la zone hydrographique';

COMMENT ON COLUMN pr_zh.t_hydro_area.geom IS 'emprise geographique de la zone hydro (polygone)';

CREATE  TABLE pr_zh.t_references ( 
	id_reference         integer DEFAULT nextval('pr_zh.t_references_id_reference_seq'::regclass) NOT NULL ,
	authors              varchar(100)   ,
	pub_year             integer   ,
	title                varchar(1000)  NOT NULL ,
	editor               varchar(100)   ,
	editor_location      varchar(50)   ,
	CONSTRAINT pk_t_references_id_reference PRIMARY KEY ( id_reference )
 );

COMMENT ON TABLE pr_zh.t_references IS 'Liste des références bibliographiques par bassin versant';

COMMENT ON COLUMN pr_zh.t_references.pub_year IS 'published_year';

CREATE  TABLE pr_zh.t_river_basin ( 
	id_rb                integer  NOT NULL ,
	name                 varchar(100)  NOT NULL ,
	geom                 geometry  NOT NULL ,
	id_climate_class     integer   ,
	id_river_flow        integer   ,
	CONSTRAINT pk_t_river_basin_id_bv PRIMARY KEY ( id_rb )
 );

COMMENT ON TABLE pr_zh.t_river_basin IS 'liste des bassins versants';

COMMENT ON COLUMN pr_zh.t_river_basin.name IS 'nom du bassin versant';

COMMENT ON COLUMN pr_zh.t_river_basin.id_climate_class IS 'classe de climat';

COMMENT ON COLUMN pr_zh.t_river_basin.id_river_flow IS 'régime des cours d''eau';

CREATE  TABLE pr_zh.t_zh ( 
	id_zh                integer DEFAULT nextval('pr_zh.t_zh_id_zh_seq'::regclass) NOT NULL ,
	zh_uuid              uuid DEFAULT uuid_generate_v4() NOT NULL ,
	code                 varchar(12)  NOT NULL ,
	main_name            varchar(100)  NOT NULL ,
	secondary_name       varchar(100)   ,
	is_id_site_space     boolean DEFAULT false  ,
	id_site_space        integer   ,
	create_author        integer  NOT NULL ,
	update_author        integer  NOT NULL ,
	id_org               integer  NOT NULL ,
	create_date          timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL ,
	update_date          timestamp DEFAULT current_timestamp NOT NULL ,
	geom                 geometry  NOT NULL ,
	id_lim_list          uuid  NOT NULL ,
	remark_lim           varchar(2000)   ,
	remark_lim_fs        varchar(2000)   ,
	id_sdage             integer  NOT NULL ,
	id_sage              integer   ,
	remark_pres          varchar(2000)   ,
	v_habref             varchar(10)   ,
	ef_area              integer   ,
	global_remark_activity varchar(2000)   ,
	id_thread            integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('EVAL_GLOB_MENACES')  ,
	id_frequency         integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('SUBMERSION_FREQ')  ,
	id_spread            integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('SUBMERSION_ETENDUE')  ,
	id_connexion         integer   ,
	id_diag_hydro        integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('FONCTIONNALITE_HYDRO')  ,
	id_diag_bio          integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('FONCTIONNALITE_BIO')  ,
	remark_diag          varchar(2000)   ,
	is_other_inventory   boolean DEFAULT false NOT NULL ,
	is_carto_hab         boolean DEFAULT false NOT NULL ,
	nb_hab               integer   ,
	total_hab_cover      varchar(3) DEFAULT 999 NOT NULL ,
	nb_flora_sp          integer   ,
	nb_vertebrate_sp     integer   ,
	nb_invertebrate_sp   integer   ,
	remark_eval_functions varchar(2000)   ,
	remark_eval_heritage varchar(2000)   ,
	remark_eval_thread   varchar(2000)   ,
	remark_eval_actions  varchar(2000)   ,
	CONSTRAINT pk_t_zh_zh_id PRIMARY KEY ( id_zh ),
	CONSTRAINT unq_t_zh_code UNIQUE ( code ) ,
	CONSTRAINT unq_t_zh_name UNIQUE ( main_name ) ,
	CONSTRAINT unq_t_zh UNIQUE ( zh_uuid ) 
 );

COMMENT ON TABLE pr_zh.t_zh IS 'list of zh';

COMMENT ON COLUMN pr_zh.t_zh.id_zh IS 'ZH unique id';

COMMENT ON COLUMN pr_zh.t_zh.code IS '12 caracters unique cod';

COMMENT ON COLUMN pr_zh.t_zh.main_name IS 'Main zh name';

COMMENT ON COLUMN pr_zh.t_zh.secondary_name IS 'Nom secondaire de la zone humide';

COMMENT ON COLUMN pr_zh.t_zh.is_id_site_space IS 'Partie d''un ensemble ?';

COMMENT ON COLUMN pr_zh.t_zh.create_author IS 'Author who created the ZH in the db';

COMMENT ON COLUMN pr_zh.t_zh.update_author IS 'Auteur des dernières modifications';

COMMENT ON COLUMN pr_zh.t_zh.id_org IS 'organisme opérateur';

COMMENT ON COLUMN pr_zh.t_zh.create_date IS 'zh creation date in database';

COMMENT ON COLUMN pr_zh.t_zh.update_date IS 'Date of the last modification';

COMMENT ON COLUMN pr_zh.t_zh.geom IS 'polygone du périmètre de la zone humide';

COMMENT ON COLUMN pr_zh.t_zh.id_lim_list IS 'id de la liste des delimitations détaillé dans cor_lim_list';

COMMENT ON COLUMN pr_zh.t_zh.remark_lim IS 'remark about zh limit';

COMMENT ON COLUMN pr_zh.t_zh.remark_lim_fs IS 'remark about limit of fonctionnal space';

COMMENT ON COLUMN pr_zh.t_zh.id_sdage IS 'typologie sdage';

COMMENT ON COLUMN pr_zh.t_zh.id_sage IS 'sous-types sage (anciennement "typologie locale")';

COMMENT ON COLUMN pr_zh.t_zh.remark_pres IS 'remarque concernant la présentation de la zone humide et de ses milieux';

COMMENT ON COLUMN pr_zh.t_zh.v_habref IS 'version of habref';

COMMENT ON COLUMN pr_zh.t_zh.ef_area IS 'superficie de l''espace fonctionnel (en ha)';

COMMENT ON COLUMN pr_zh.t_zh.id_thread IS 'evolution globale des menaces potentielles ou avancees';

COMMENT ON COLUMN pr_zh.t_zh.id_frequency IS 'Régime hydrique - submersion frequence';

COMMENT ON COLUMN pr_zh.t_zh.id_spread IS 'Regime hydrique - submersion étendue';

COMMENT ON COLUMN pr_zh.t_zh.id_connexion IS 'Connexion de la zone humide dans son environnement';

COMMENT ON COLUMN pr_zh.t_zh.id_diag_hydro IS 'fonctionnalité hydrologique';

COMMENT ON COLUMN pr_zh.t_zh.id_diag_bio IS 'fonctionnalité biologique';

COMMENT ON COLUMN pr_zh.t_zh.remark_diag IS 'Remarque sur diagnostic fonctionnel';

COMMENT ON COLUMN pr_zh.t_zh.is_other_inventory IS 'Autres études / inventaires naturalistes ?';

COMMENT ON COLUMN pr_zh.t_zh.is_carto_hab IS 'cartographie d''habitats ?';

COMMENT ON COLUMN pr_zh.t_zh.nb_hab IS 'nombre d''habitats';

COMMENT ON COLUMN pr_zh.t_zh.total_hab_cover IS 'recouvrement total de la zh en pourcentage';

COMMENT ON COLUMN pr_zh.t_zh.nb_flora_sp IS 'flore - nombre d''especes';

COMMENT ON COLUMN pr_zh.t_zh.nb_vertebrate_sp IS 'faune vertebres - nombre d''especes';

COMMENT ON COLUMN pr_zh.t_zh.nb_invertebrate_sp IS 'faune invvertebres - nombre d''especes';

COMMENT ON COLUMN pr_zh.t_zh.remark_eval_functions IS 'remarque sur les fonctions de la zh dans l''evaluation generale du site - 7.1';

COMMENT ON COLUMN pr_zh.t_zh.remark_eval_heritage IS 'remarque sur interet patrimonial de la zh dans l''evaluation generale du site - 7.2';

COMMENT ON COLUMN pr_zh.t_zh.remark_eval_thread IS 'remarque sur les menaces et facteurs influancant la zh dans l''evaluation generale du site. 7.3';

COMMENT ON COLUMN pr_zh.t_zh.remark_eval_actions IS 'remarque sur les orientations d''actions de la zh dans l''evaluation generale du site. 7.4';

CREATE  TABLE pr_zh.cor_impact_list ( 
	id_impact_list       uuid NOT NULL ,
	id_cor_impact_types  integer  NOT NULL ,
	CONSTRAINT pk_cor_activity_impact PRIMARY KEY ( id_impact_list, id_cor_impact_types )
 );

COMMENT ON TABLE pr_zh.cor_impact_list IS 'liste des impacts liés aux activités';

CREATE  TABLE pr_zh.cor_rb_org ( 
	id_rb                integer  NOT NULL ,
	id_org               integer  NOT NULL ,
	CONSTRAINT pk_t_rb_org PRIMARY KEY ( id_rb, id_org )
 );

COMMENT ON TABLE pr_zh.cor_rb_org IS 'Structures de gestion rattachées au bassin versant';

CREATE  TABLE pr_zh.cor_rb_ref ( 
	id_rb                integer  NOT NULL ,
	id_ref               integer  NOT NULL ,
	CONSTRAINT pk_cor_zh_ref PRIMARY KEY ( id_rb, id_ref )
 );

COMMENT ON TABLE pr_zh.cor_rb_ref IS 'correspondance between river basin and references';

CREATE  TABLE pr_zh.cor_zh_corine_cover ( 
	id_cover             integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	CONSTRAINT pk_cor_zh_cover PRIMARY KEY ( id_cover, id_zh )
 );

COMMENT ON TABLE pr_zh.cor_zh_corine_cover IS 'Correspondance zh / Corine Land Cover';

COMMENT ON COLUMN pr_zh.cor_zh_corine_cover.id_cover IS 'id_nomenclature de la nomenclature ''Corine Land Cover''';

CREATE  TABLE pr_zh.cor_zh_fct_area ( 
	id_zh                integer  NOT NULL ,
	id_fct_area          integer  NOT NULL ,
	CONSTRAINT pk_cor_zh_fct_area PRIMARY KEY ( id_zh, id_fct_area )
 );

COMMENT ON TABLE pr_zh.cor_zh_fct_area IS 'Correspondance entre espaces de fonctionnalité et zh';

CREATE  TABLE pr_zh.cor_zh_hydro ( 
	id_zh                integer  NOT NULL ,
	id_hydro             integer  NOT NULL ,
	CONSTRAINT pk_cor_zh_hydro PRIMARY KEY ( id_zh, id_hydro )
 );

COMMENT ON TABLE pr_zh.cor_zh_hydro IS 'Correspondance between zh and hydro area, automatically filled with triggers when zh geom is filled';

COMMENT ON COLUMN pr_zh.cor_zh_hydro.id_hydro IS 'id hydro area';

CREATE  TABLE pr_zh.cor_zh_lim_fs ( 
	id_zh                integer  NOT NULL ,
	id_lim_fs            integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('CRIT_DEF_ESP_FCT') NOT NULL ,
	CONSTRAINT pk_cor_zh_lim_fs PRIMARY KEY ( id_zh, id_lim_fs )
 );

COMMENT ON TABLE pr_zh.cor_zh_lim_fs IS 'correspondance between fonctionnal space limits and zh';

COMMENT ON COLUMN pr_zh.cor_zh_lim_fs.id_lim_fs IS 'id of fonctional space limit in id_nomenclatures';

CREATE  TABLE pr_zh.cor_zh_protection ( 
	id_protection        integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	CONSTRAINT pk_cor_zh_protection_id_protection_status PRIMARY KEY ( id_protection, id_zh )
 );

COMMENT ON TABLE pr_zh.cor_zh_protection IS 'Correspondance entre zh et statuts de protection';

CREATE  TABLE pr_zh.cor_zh_rb ( 
	id_zh                integer  NOT NULL ,
	id_rb                integer  NOT NULL ,
	CONSTRAINT pk_cor_zh_river_basin_id_zh PRIMARY KEY ( id_zh, id_rb )
 );

COMMENT ON TABLE pr_zh.cor_zh_rb IS 'Correspondance between zh and river basin, automatically filled with triggers when zh geom is filled';

COMMENT ON COLUMN pr_zh.cor_zh_rb.id_rb IS 'id river basin';

CREATE  TABLE pr_zh.cor_zh_ref ( 
	id_ref               integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	CONSTRAINT pk_cor_zh_references PRIMARY KEY ( id_ref, id_zh )
 );

COMMENT ON TABLE pr_zh.cor_zh_ref IS 'Table de correspondance entre zh et references bibliographiques';

CREATE  TABLE pr_zh.t_actions ( 
	id_action            integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	id_priority_level    integer   ,
	remark               varchar(2000)   ,
	CONSTRAINT pk_t_actions PRIMARY KEY ( id_action, id_zh )
 );

COMMENT ON TABLE pr_zh.t_actions IS 'propositions d''actions et niveau de priorite';

CREATE  TABLE pr_zh.t_activity ( 
	id_activity          integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	id_position          integer  NOT NULL ,
	id_impact_list       uuid NOT NULL UNIQUE  ,
	remark_activity      varchar(2000)   ,
	CONSTRAINT pk_t_activity PRIMARY KEY ( id_activity, id_zh )
 );

COMMENT ON TABLE pr_zh.t_activity IS 'liste des activités par zh';

COMMENT ON COLUMN pr_zh.t_activity.id_activity IS 'activités humaines';

COMMENT ON COLUMN pr_zh.t_activity.id_position IS 'localisation';

COMMENT ON COLUMN pr_zh.t_activity.id_impact_list IS 'id pour lier une activité à un ou plusieurs impacts';

CREATE  TABLE pr_zh.t_functions ( 
	id_function          integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	justification        varchar(2000)   ,
	id_qualification     integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('FONCTIONS_QUALIF') NOT NULL ,
	id_knowledge         integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('FONCTIONS_CONNAISSANCE') NOT NULL ,
	CONSTRAINT pk_t_functions PRIMARY KEY ( id_function, id_zh )
 );

COMMENT ON TABLE pr_zh.t_functions IS 'liste des fonctions par type pour les zh';

CREATE  TABLE pr_zh.t_hab_heritage ( 
	id_zh                integer  NOT NULL ,
	id_corine_bio        integer  NOT NULL ,
	id_cahier_hab        integer  NOT NULL ,
	id_preservation_state integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('ETAT_CONSERVATION') NOT NULL ,
	hab_cover            varchar(3) DEFAULT 999 NOT NULL ,
	CONSTRAINT pk_t_hab PRIMARY KEY ( id_zh, id_corine_bio, id_cahier_hab )
 );

COMMENT ON TABLE pr_zh.t_hab_heritage IS 'liste des habitats naturels humides patrimoniaux pour chaque zh';

COMMENT ON COLUMN pr_zh.t_hab_heritage.id_corine_bio IS 'id of defined hab list in refhab schema (ex : corine biotope)';

COMMENT ON COLUMN pr_zh.t_hab_heritage.id_cahier_hab IS 'cahier habitats';

COMMENT ON COLUMN pr_zh.t_hab_heritage.id_preservation_state IS 'etat de conservation';

COMMENT ON COLUMN pr_zh.t_hab_heritage.hab_cover IS 'recouvrement sur la zh en pourcentage';

CREATE  TABLE pr_zh.t_inflow ( 
	id_inflow            integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	id_permanance        integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('PERMANENCE_ENTREE')  ,
	topo                 varchar(2000)   ,
	CONSTRAINT pk_t_inflow PRIMARY KEY ( id_inflow, id_zh )
 );

COMMENT ON TABLE pr_zh.t_inflow IS 'régime hydrique : entrée d''eau';

COMMENT ON COLUMN pr_zh.t_inflow.topo IS 'toponymie';

CREATE  TABLE pr_zh.t_instruments ( 
	id_instrument        integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	instrument_date      timestamp   ,
	CONSTRAINT pk_t_instruments PRIMARY KEY ( id_instrument, id_zh )
 );

COMMENT ON TABLE pr_zh.t_instruments IS 'Instruments contractuels et financiers';

CREATE  TABLE pr_zh.t_management_structures ( 
	id_structure         integer DEFAULT nextval('pr_zh.t_management_structures_id_structure_seq'::regclass) NOT NULL ,
	id_zh                integer  NOT NULL ,
	id_org               integer  NOT NULL ,
	CONSTRAINT pk_t_management_structure PRIMARY KEY ( id_structure ),
	CONSTRAINT unq_t_management_structure UNIQUE ( id_zh, id_org ) 
 );

COMMENT ON TABLE pr_zh.t_management_structures IS 'liste des structures de gestion des zh';

CREATE  TABLE pr_zh.t_outflow ( 
	id_outflow           integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	id_permanance        integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('PERMANENCE_SORTIE')  ,
	topo                 varchar(2000)   ,
	CONSTRAINT pk_t_outflow PRIMARY KEY ( id_outflow, id_zh )
 );

COMMENT ON TABLE pr_zh.t_outflow IS 'régime hydrique : sortie d''eau';

COMMENT ON COLUMN pr_zh.t_outflow.topo IS 'toponymie';

CREATE  TABLE pr_zh.t_ownership ( 
	id_status            integer DEFAULT ref_nomenclatures.get_default_nomenclature_value('STATUT_PROPRIETE') NOT NULL ,
	id_zh                integer  NOT NULL ,
	remark               varchar(2000)   ,
	CONSTRAINT pk_ownership PRIMARY KEY ( id_status, id_zh )
 );

COMMENT ON TABLE pr_zh.t_ownership IS 'regime foncier : statut de propriete';

CREATE  TABLE pr_zh.t_urban_planning_docs ( 
	id_doc               integer DEFAULT nextval('pr_zh.t_urban_planning_docs_id_doc_seq'::regclass) NOT NULL ,
	id_area              integer  NOT NULL ,
	id_zh                integer  NOT NULL ,
	id_urban_type        integer  NOT NULL ,
	remark               varchar(2000)   ,
	CONSTRAINT pk_t_docs_id_doc PRIMARY KEY ( id_doc )
 );

COMMENT ON TABLE pr_zh.t_urban_planning_docs IS 'liste zonage des documents d''urbanisme';

COMMENT ON COLUMN pr_zh.t_urban_planning_docs.id_urban_type IS 'type de classement';

CREATE  TABLE pr_zh.t_management_plans ( 
	id_plan              integer DEFAULT nextval('pr_zh.t_management_plans_id_plan_seq'::regclass) NOT NULL ,
	id_nature            integer  NOT NULL ,
	id_structure         integer  NOT NULL ,
	plan_date            timestamp  NOT NULL ,
	duration             integer  NOT NULL ,
	CONSTRAINT pk_t_management_plan_id_plan PRIMARY KEY ( id_plan )
 );

COMMENT ON TABLE pr_zh.t_management_plans IS 'liste des plan de gestion';

COMMENT ON COLUMN pr_zh.t_management_plans.plan_date IS 'date de resiliation';

COMMENT ON COLUMN pr_zh.t_management_plans.duration IS 'en année';

ALTER TABLE pr_zh.cor_impact_list ADD CONSTRAINT fk_cor_activity_id_impact FOREIGN KEY ( id_cor_impact_types ) REFERENCES pr_zh.cor_impact_types( id_cor_impact_types )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_impact_list ADD CONSTRAINT fk_id_impact_list FOREIGN KEY ( id_impact_list ) REFERENCES pr_zh.t_activity( id_impact_list )  ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE pr_zh.cor_impact_types ADD CONSTRAINT fk_cor_impact_types_id_impact FOREIGN KEY ( id_impact ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_impact_types ADD CONSTRAINT fk_cor_impact_types_id_impact_type FOREIGN KEY ( id_impact_type ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_lim_list ADD CONSTRAINT fk_cor_zh_lim_t_nomenclatures FOREIGN KEY ( id_lim ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_main_fct ADD CONSTRAINT fk_cor_id_main_id_main_fct FOREIGN KEY ( id_main_function ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_main_fct ADD CONSTRAINT fk_cor_main_fct_id_fct FOREIGN KEY ( id_function ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_protection_level_type ADD CONSTRAINT fk_cor_protection_level_type_id_protection_status FOREIGN KEY ( id_protection_status ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_protection_level_type ADD CONSTRAINT fk_cor_protection_level_type_id_protection_type FOREIGN KEY ( id_protection_type ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_protection_level_type ADD CONSTRAINT fk_cor_protection_level_type_id_protection_level FOREIGN KEY ( id_protection_level ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_rb_org ADD CONSTRAINT fk_t_rb_org_t_river_basin FOREIGN KEY ( id_rb ) REFERENCES pr_zh.t_river_basin( id_rb ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_rb_org ADD CONSTRAINT fk_cor_rb_org_t_organismes FOREIGN KEY ( id_org ) REFERENCES pr_zh.bib_organismes( id_org )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_rb_ref ADD CONSTRAINT fk_cor_zh_ref_t_zh FOREIGN KEY ( id_rb ) REFERENCES pr_zh.t_river_basin( id_rb ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_rb_ref ADD CONSTRAINT fk_cor_rb_ref_t_references FOREIGN KEY ( id_ref ) REFERENCES pr_zh.t_references( id_reference )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_sdage_sage ADD CONSTRAINT fk_cor_sdage FOREIGN KEY ( id_sdage ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_sdage_sage ADD CONSTRAINT fk_cor_sage FOREIGN KEY ( id_sage ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_urban_type_range ADD CONSTRAINT fk_cor_urban_range FOREIGN KEY ( id_range_type ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_urban_type_range ADD CONSTRAINT fk_cor_urban_type FOREIGN KEY ( id_doc_type ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_area ADD CONSTRAINT fk_cor_zh_area_id_area FOREIGN KEY ( id_area ) REFERENCES ref_geo.l_areas( id_area )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_cb ADD CONSTRAINT fk_cor_zh_cb_id_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh )  ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_cb ADD CONSTRAINT fk_cor_zh_cb_lb_code FOREIGN KEY ( lb_code ) REFERENCES pr_zh.bib_cb( lb_code )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_corine_cover ADD CONSTRAINT fk_cor_zh_cover_t_updates FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_corine_cover ADD CONSTRAINT cor_zh_corine_cover_id_cover FOREIGN KEY ( id_cover ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_fct_area ADD CONSTRAINT fk_cor_zh_fct_area_t_fct_area FOREIGN KEY ( id_fct_area ) REFERENCES pr_zh.t_fct_area( id_fct_area )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_fct_area ADD CONSTRAINT fk_cor_zh_fct_area_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_hydro ADD CONSTRAINT fk_cor_zh_hydro_t_hydro_area FOREIGN KEY ( id_hydro ) REFERENCES pr_zh.t_hydro_area( id_hydro )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_hydro ADD CONSTRAINT fk_cor_zh_hydro_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_lim_fs ADD CONSTRAINT fk_cor_zh_lim_fs FOREIGN KEY ( id_lim_fs ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_lim_fs ADD CONSTRAINT fk_cor_zh_lim_fs_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_protection ADD CONSTRAINT fk_cor_zh_protection_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_protection ADD CONSTRAINT fk_cor_zh_protection_id_protection FOREIGN KEY ( id_protection ) REFERENCES pr_zh.cor_protection_level_type( id_protection )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_rb ADD CONSTRAINT fk_cor_zh_river_basin_t_river_basin FOREIGN KEY ( id_rb ) REFERENCES pr_zh.t_river_basin( id_rb ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_rb ADD CONSTRAINT fk_cor_zh_river_basin_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_ref ADD CONSTRAINT fk_cor_zh_ref_t_references FOREIGN KEY ( id_ref ) REFERENCES pr_zh.t_references( id_reference )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.cor_zh_ref ADD CONSTRAINT fk_cor_zh_ref_id_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_actions ADD CONSTRAINT fk_t_actions_bib_actions_id FOREIGN KEY ( id_action ) REFERENCES pr_zh.bib_actions( id_action )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_actions ADD CONSTRAINT fk_t_actions_t_zh_id FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_actions ADD CONSTRAINT fk_t_actions_t_nomenclatures FOREIGN KEY ( id_priority_level ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_activity ADD CONSTRAINT fk_t_activity FOREIGN KEY ( id_activity ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_activity ADD CONSTRAINT fk_t_activity_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_activity ADD CONSTRAINT fk_t_activity_position_t_nomenclatures FOREIGN KEY ( id_position ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_functions ADD CONSTRAINT fk_t_functions_t_nomenclatures_qualification FOREIGN KEY ( id_qualification ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_functions ADD CONSTRAINT fk_t_functions_t_nomenclatures_knowledge FOREIGN KEY ( id_knowledge ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_functions ADD CONSTRAINT fk_t_functions_t_zh_id_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_functions ADD CONSTRAINT fk_t_functions_t_nomenclatures FOREIGN KEY ( id_function ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_hab_heritage ADD CONSTRAINT fk_t_hab_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_hab_heritage ADD CONSTRAINT fk_t_hab_t_nomenclatures FOREIGN KEY ( id_preservation_state ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_hab_heritage ADD CONSTRAINT fk_t_hab_heritage_cor_list_habitat FOREIGN KEY ( id_corine_bio ) REFERENCES ref_habitats.cor_list_habitat( id_cor_list ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_inflow ADD CONSTRAINT fk_t_inflow_t_nomenclatures FOREIGN KEY ( id_inflow ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_inflow ADD CONSTRAINT fk_t_inflow_t_nomenclatures_permanance FOREIGN KEY ( id_permanance ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_inflow ADD CONSTRAINT fk_t_inflow_id_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_instruments ADD CONSTRAINT fk_t_instruments FOREIGN KEY ( id_instrument ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_instruments ADD CONSTRAINT fk_t_instruments_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_management_plans ADD CONSTRAINT fk_t_management_plan_id_nature FOREIGN KEY ( id_nature ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_management_plans ADD CONSTRAINT fk_t_management_plan_id_structure FOREIGN KEY ( id_structure ) REFERENCES pr_zh.t_management_structures( id_structure ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_management_structures ADD CONSTRAINT fk_t_management_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_management_structures ADD CONSTRAINT fk_t_management_structures_t_organismes FOREIGN KEY ( id_org ) REFERENCES pr_zh.bib_organismes( id_org )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_outflow ADD CONSTRAINT fk_t_outflow_id_permanence FOREIGN KEY ( id_permanance ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_outflow ADD CONSTRAINT fk_t_outflow_id_outflow FOREIGN KEY ( id_outflow ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_outflow ADD CONSTRAINT fk_t_outflow_id_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_ownership ADD CONSTRAINT fk_ownership_t_zh_id FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_ownership ADD CONSTRAINT fk_ownership_t_nomenclatures_status FOREIGN KEY ( id_status ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_river_basin ADD CONSTRAINT fk_t_river_basin_t_nomenclatures FOREIGN KEY ( id_climate_class ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_river_basin ADD CONSTRAINT fk_t_river_basin_t_nomenclatures_0 FOREIGN KEY ( id_river_flow ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_urban_planning_docs ADD CONSTRAINT fk_t_docs_t_zh FOREIGN KEY ( id_zh ) REFERENCES pr_zh.t_zh( id_zh ) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_urban_planning_docs ADD CONSTRAINT fk_t_urban_planning_docs FOREIGN KEY ( id_urban_type ) REFERENCES pr_zh.cor_urban_type_range( id_cor )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_bib_site_space FOREIGN KEY ( id_site_space ) REFERENCES pr_zh.bib_site_space( id_site_space )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_t_roles FOREIGN KEY ( create_author ) REFERENCES utilisateurs.t_roles( id_role )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_t_nomenclatures_id_frequency FOREIGN KEY ( id_frequency ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_t_nomenclatures_spread FOREIGN KEY ( id_spread ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_t_roles_update_author FOREIGN KEY ( update_author ) REFERENCES utilisateurs.t_roles( id_role )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_t_nomenclatures_thread FOREIGN KEY ( id_thread ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_t_nomenclatures_connexion FOREIGN KEY ( id_connexion ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_t_nomenclatures_diag_hydro FOREIGN KEY ( id_diag_hydro ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_t_nomenclatures_diag_bio FOREIGN KEY ( id_diag_bio ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_sdage_t_nomenclatures FOREIGN KEY ( id_sdage ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_sage_t_nomenclatures FOREIGN KEY ( id_sage ) REFERENCES ref_nomenclatures.t_nomenclatures( id_nomenclature )  ON UPDATE CASCADE;

ALTER TABLE pr_zh.t_zh ADD CONSTRAINT fk_t_zh_id_org FOREIGN KEY ( id_org ) REFERENCES pr_zh.bib_organismes( id_org )  ON UPDATE CASCADE;
