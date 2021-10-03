#main.py pip install pg8000
from Database.db import *
from flask import Flask, request, Response,jsonify
from waitress import serve
from numpy import size
import datetime
import settings
import logging

app = Flask(__name__)

db = init_connection_engine()
logger = logging.getLogger()





@app.route('/', methods=['GET'])
def index():
    return jsonify({'Message': 'Nice'})

@app.route('/cargarTemporal', methods=['GET'])
def cargarTemporal():
    return jsonify({'Message': 'Loaded'})

@app.route('/eliminarTemporal', methods=['GET'])
def eliminarTemporal():
    try:
            stmt = sqlalchemy.text("DELETE FROM temporal")
            with db.connect() as conn:
                conn.execute(stmt)
    except Exception as e:
        logger.exception(e)
        return Response(
            status=500,
            response="Error al eliminar temporal"
        )
    return Response(
        status=200,
        response="Temporal eliminado"
    )

@app.route('/cargarModelo', methods=['GET'])
def cargarModelo():
    global ddl
    try:
        for i in range(size(ddl)-1): 
            stmt = sqlalchemy.text(ddl[i])
            with db.connect() as conn:
                conn.execute(stmt)

    except Exception as e:
        logger.exception(e)
        return Response(
            status=500,
            response="Error al cargar modelo"
        )
    return Response(
        status=200,
        response="Modelo cargado correctamente"
    )


@app.route('/', methods=['POST'])
def save_vote():
    # Get the team and time the vote was cast.
    team = request.form['team']
    time_cast = datetime.datetime.utcnow()
    # Verify that the team is one of the allowed options
    if team != "TABS" and team != "SPACES":
        logger.warning(team)
        return Response(
            response="Invalid team specified.",
            status=400
        )

    # [START cloud_sql_postgres_sqlalchemy_connection]
    # Preparing a statement before hand can help protect against injections.
    stmt = sqlalchemy.text(
        "INSERT INTO votes (time_cast, candidate)"
        " VALUES (:time_cast, :candidate)"
    )
    try:
        with db.connect() as conn:
            conn.execute(stmt, time_cast=time_cast, candidate=team)
    except Exception as e:
        logger.exception(e)
        return Response(
            status=500,
            response="Unable to successfully cast vote! Please check the "
                     "application logs for more details."
        )

    return Response(
        status=200,
        response="Vote successfully cast for '{}' at time {}!".format(
            team, time_cast)
    )



if __name__ == '__main__':
    global ddl
    ddl = cargarModeloQuery()
    app.run(port = os.environ["PORT"],debug=True)
    #print("Server on port",5000)
    #serve(app, port= 5000)
