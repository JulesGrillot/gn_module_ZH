from flask import abort

from geonature.utils.env import DB

from sqlalchemy import func, cast

from geoalchemy2.shape import to_shape
from geoalchemy2.types import Geography, Geometry

from .model.zh_schema import TZH

from .api_error import ZHApiError


def set_geom(geometry, id_zh=None):
    if not id_zh:
        id_zh = 0
    polygon = DB.session.query(func.ST_GeomFromGeoJSON(str(geometry))).one()[0]
    q_zh = DB.session.query(TZH).all()
    is_intersected = False
    for zh in q_zh:
        if zh.id_zh != id_zh:
            zh_geom = DB.session.query(func.ST_GeogFromWKB(func.ST_AsEWKB(zh.geom))).scalar()
            polygon_geom = DB.session.query(func.ST_GeogFromWKB(func.ST_AsEWKB(polygon))).scalar()
            if DB.session.query(func.ST_Intersects(polygon_geom, zh_geom)).scalar():
                is_intersected = True
            if DB.session.query(func.ST_Intersects(zh_geom, polygon_geom)).scalar():
                abort(400, 'polygon_contained_in_zh')
            intersect = DB.session.query(
                func.ST_Difference(polygon_geom, zh_geom))
            polygon = DB.session.query(func.ST_GeomFromText(
                to_shape(intersect.scalar()).to_wkt())).one()[0]
    return {
        'polygon': polygon,
        'is_intersected': is_intersected
    }
