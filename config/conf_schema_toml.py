'''
   Spécification du schéma toml des paramètres de configurations
   La classe doit impérativement s'appeller GnModuleSchemaConf
   Fichier spécifiant les types des paramètres et leurs valeurs par défaut
   Fichier à ne pas modifier. Paramètres surcouchables dans config/config_gn_module.tml
'''

from marshmallow import Schema, fields


class MapListConfig(Schema):
    pass


default_map_list_conf = [
    {"prop": "code", "name": "Code"},
    {"prop": "main_name", "name": "Nom principal"},
    {"prop": "author", "name": "Auteur"},
    {"prop": "create_date", "name": "Date de creation"}
]


available_maplist_column = [
    {"prop": "id_zh", "name": "Id"},
    {"prop": "code", "name": "Code"},
    {"prop": "main_name", "name": "Nom principal"},
    {"prop": "author", "name": "Auteur"},
    {"prop": "update_author", "name": "Auteur derniere modification"},
    {"prop": "create_date", "name": "Date de creation"},
    {"prop": "update_date", "name": "Date de modification"}
]


class GnModuleSchemaConf(Schema):
    default_maplist_columns = fields.List(fields.Dict(), missing=default_map_list_conf)
    available_maplist_column = fields.List(
        fields.Dict(), missing=available_maplist_column
    )

